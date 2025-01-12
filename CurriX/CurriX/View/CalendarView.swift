//
//  CalendarView.swift
//  CurriX
//
//  Created by James Guo on 3/17/24.
//  This view is a universal view that should work in both iPad and visionOS
//

import SwiftUI
import SwiftData

// Part of the following is generated by ChatGPT4



struct CalendarView: View {
    let daysOfWeek = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    @State var events: [Event] = [
        Event(day: "MON,WED,FRI", title: "ECE 564 MOBILE APP DEVELOPMENT", location: "Hudson Hall 222", timeRange: "13-14"),
        Event(day: "TUE,THU", title: "ECE 553 COMPILER CONSTRUCTION", location: "Teer 106", timeRange: "11-12"),
        // Add other events here
    ]
    let chosenTerm: String
    let termText: String

    @Binding var showing: [String]
    
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var calendar: UserChosenCalendar
    @EnvironmentObject var shoppingCart: UserChosenShoppingCart

    @State var loading = false
    @State var error: String? = nil
    @State var componentSelection: (Course, [DukeClass])? = nil
    
    var body: some View {
        if loading {
            ProgressView(label: {
                Text("Loading")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            ).progressViewStyle(.circular)
        } else {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Text(termText)
                    Spacer()
                }
                HStack {
                    ForEach(Days.allCases, id: \.self) { day in
                        Text(day.shorthand)
                            .frame(maxWidth: .infinity)
                    }
                }
                Divider()

                GeometryReader { geometry in
                    ScrollView {
                        HStack(spacing: 0) {
                            ForEach(Days.allCases, id: \.self) { day in
                                VStack(spacing: 0) {
                                    ForEach(calendar.generateBlocks(term: chosenTerm, day: day)) { calendarBlock in
                                        if let course = calendarBlock.course {
                                            CalendarCell(geometry: geometry, event: course, duration: calendarBlock.interval)
                                                .draggable(course)
                                        } else {
                                            Rectangle()
                                                .frame(width: geometry.size.width / 5, height: calendarBlock.interval/60)
                                                .opacity(0)
                                        }
                                    }
                                    Spacer()
                                }.frame(width: geometry.size.width / 5)
                            }
                        }
                    }
                }
                .alert(Text(error ?? ""),
                       isPresented: .constant(error != nil),
                        actions: {
                            Button("Cancel", role: .cancel) {
                                error = nil
                            }
                        }, message: {
                            Text("")
                        }
                    )
                .sheet(isPresented: .constant(componentSelection != nil), onDismiss: {
                    componentSelection = nil
                }) {
                    List {
                        if let (course, componentSelection) = componentSelection {
                            ForEach(componentSelection) {dukeClass in
                                MyOutlineGroup(course: course, dukeClass: dukeClass, term: chosenTerm, dismiss: {
                                    self.componentSelection = nil
                                }, onError: {
                                    self.error = $0
                                })
                            }
                        }
                    }
                    .padding()
                    .presentationDetents([.medium, .large])
                    .presentationBackgroundInteraction(.automatic)
                    .frame(width: 600, height: 800)
                }
                .dropDestination(for: Course.self) { items, location in
                    for course in items {
                        Task {
                            loading = true
                            defer {
                                loading = false
                            }
                            do {
                                let resp = try await downloadCourseDetail(strmStr: chosenTerm, crseId: course.courseID, crseOfferNum: course.courseOfferNum)
                                var componentsCount = 0
                                var component: ClassComponent? = nil
                                var dukeClass: DukeClass? = nil
                                for _dukeClass in resp {
                                    for _component in _dukeClass.components {
                                        component = _component
                                        componentsCount += 1
                                        dukeClass = _dukeClass
                                    }
                                }

                                if componentsCount > 1 {
                                    self.componentSelection = (course, resp)
                                } else {
                                    let added = calendar.add(chosenTerm, course: course, dukeClass: dukeClass!, classComponent: component!)
                                    if !added {
                                        self.error = "Time conflict. Please remove a course to continue"
                                    } else {
                                        shoppingCart.remove(course)
                                    }
                                    print(calendar.dictClass[chosenTerm] as Any, chosenTerm)
                                }
                            } catch {
                                print("Error info: \(error)")
                                self.error = "\(error)"
                            }
                        }
                    }
                    return true
                }
            }
            .padding(.all)
        }
    }
}

struct MyOutlineGroup: View {
    let course: Course
    let dukeClass: DukeClass?
    @State var isExpanded = true
    @EnvironmentObject var calendar: UserChosenCalendar
    @EnvironmentObject var shoppingCart: UserChosenShoppingCart
    let term: String
    let dismiss: () -> ()
    let onError: (String) -> ()

    var body: some View {
        if let title = dukeClass?.title {
            DisclosureGroup(title, isExpanded: $isExpanded) {
                component
            }
        } else {
            component
        }
    }


    var component: some View {
        ForEach(dukeClass?.components ?? []) {
            component in
            if component.meetingPattern?.startTime != nil {
                Button(action: {
                    let added = calendar.add(term, course: course, dukeClass: dukeClass!, classComponent: component)
                    if !added {
                        onError("Time conflict. Please remove a course to continue")
                    } else {
                        shoppingCart.remove(course)
                    }
                    dismiss()
                }) {
                    Text("\(component.meetingPattern?.description ?? "") \(component.meetingPattern?.instructors.joined(separator: ", ") ?? "")")
                }
            }
        }
    }
}

struct CalendarCell: View {
    let geometry: GeometryProxy
    let event: Course
    let duration: TimeInterval
    
    let colors = [
        Color.green, Color.blue, Color.yellow, Color.gray, Color.cyan, Color.mint
        ]

    var body: some View {
        RoundedRectangle(cornerRadius: 20.0, style: .continuous)
            .fill(colors[abs(event.hashValue) % colors.count])
            .frame(width: geometry.size.width / 5, height: duration/60)
            .overlay {
                Text("\(event.courseTitleLong ?? "")")
                    .lineLimit(2)
                    .padding()
                    .background(
                        event.subject.code.contains("MENG") ?
                        RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.red.opacity(0.8)) :
                        RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.red.opacity(0.0))
                    )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                    .strokeBorder(Color.black, lineWidth: 0.5)
            }
    }
}

struct Event: Hashable {
    let day: String
    let title: String
    let location: String
    let timeRange: String
}
