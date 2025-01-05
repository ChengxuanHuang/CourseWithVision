//
//  ShoppingCartView.swift
//  CurriX
//
//  Created by James Guo on 3/18/24.
//

import SwiftUI

struct ShoppingCartView: View {
    @EnvironmentObject var shoppingCart: UserChosenShoppingCart
    @EnvironmentObject var calendar: UserChosenCalendar
    @State var showActionSheet = false
    @State var selectedCourse: Course? = nil
    @State var showCalendarSelection = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(shoppingCart.sortedCourseList, id: \.self) { course in
                    HStack {
                        Text("\(course.subject.code.trimmingCharacters(in: .whitespaces)) \(course.catalogNumber) \(course.courseTitleLong ?? "")")
                            .shadow(radius: 1, x: 1, y: 1)
                            .draggable(course)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .padding(.all, 10.0)
                            .background(
                                course.subject.code.contains("MENG") ?
                                RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.red.opacity(0.8)) :
                                RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.red.opacity(0.0))
                            )
                        Spacer()
                        Button {
                            showActionSheet = true
                            selectedCourse = course
                        } label: {
                            Image(systemName: "ellipsis")
                                .symbolRenderingMode(.palette)
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                                .symbolEffect(.bounce.byLayer.down, value: showActionSheet)
                        }
                        .controlSize(.mini)
                    }
                    .padding(EdgeInsets(top: 6, leading: 24, bottom: 6, trailing: 24))
                    .confirmationDialog("Extra Functions", isPresented: $showActionSheet) {
//                        Button("Add to Calendar") {
//                            showActionSheet = false
//                            showCalendarSelection = true
//                        }
                        
                        Button("Delete", role: .destructive) {
                            if let selectedCourse = self.selectedCourse {
                                shoppingCart.remove(selectedCourse)
                            }
                            self.selectedCourse = nil
                        }
                        
                        Button("Cancel", role: .cancel) {
                            showActionSheet = false
                        }
                    }
                    .sheet(isPresented: $showCalendarSelection) {
                        if let selectedCourse = selectedCourse {
                            CalendarSelection(selectedCourse: selectedCourse)
                        } else {
                            Text("").onAppear {
                                showCalendarSelection = false
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(.vertical)
        }
        .dropDestination(for: Course.self) { items, location in
            for course in items {
                calendar.remove(course)
                shoppingCart.add(course)
            }
            return true
        }
    }
}

struct CalendarSelection: View {
    @State var selectedCourse: Course
    @State var dukeClasses: [DukeClass] = []
    @State var loading = true
    @State var componentSelection: (Course, [DukeClass])? = nil
    @State var chosenTerm: Term? = nil
    
    @EnvironmentObject var calendar: UserChosenCalendar
    
    var body: some View {
        ForEach(canChooseTerms, id: \.self) { term in
            Button(action: {
                chosenTerm = term
            }, label: {
                Text(term.termString)
            })
                .padding()
                .sheet(isPresented: .constant(componentSelection != nil), onDismiss: {
                    componentSelection = nil
                }) {
                    List {
                        if let (course, componentSelection) = componentSelection,
                           let chosenTerm = chosenTerm {
                            ForEach(componentSelection) { dukeClass in
                                MyOutlineGroup(course: course, dukeClass: dukeClass, term: chosenTerm.termString, dismiss: {
                                    self.componentSelection = nil
                                }, onError: {_ in })
                            }
                        }
                    }
                            .presentationDetents([.medium, .large])
                            .presentationBackgroundInteraction(.automatic)
                }
            
        }
        .onChange(of: chosenTerm ?? Term(code: "", desc: "")) { _, newTerm in
            Task {
                defer { loading = false }
                dukeClasses = try await downloadCourseDetail(strm: newTerm, crse: selectedCourse)
                var componentCount = 0
                for dukeClass in dukeClasses {
                    for _ in dukeClass.components {
                        componentCount += 1
                    }
                }
                
                if componentCount > 1 {
                    componentSelection = (selectedCourse, dukeClasses)
                } else if componentCount == 1 {
                    _ = calendar.add(newTerm.termString, course: selectedCourse, dukeClass: dukeClasses[0], classComponent: dukeClasses[0].components[0])
                }
            }
        }
    }
}

#Preview {
    ShoppingCartView()
}
