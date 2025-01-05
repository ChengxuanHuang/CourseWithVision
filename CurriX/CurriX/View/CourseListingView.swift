//
//  ShoppingCartView.swift
//  CurriX
//
//  Created by James Guo on 3/18/24.
//

import SwiftUI

struct CourseListingView: View {
    @State var items: [Course] = []
    @State var itemsMap: [String:Course] = [:]
    @State var selection: String?
    @State var loading = true
    @State private var semester = 0
    @State private var isOccasional = false
    @EnvironmentObject var shoppingCart: UserChosenShoppingCart
    
    @State private var searchText: String = ""

    var body: some View {
        VStack {
            if loading {
                Spacer()
                ProgressView(label: {
                    Text("Loading")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                ).progressViewStyle(.circular)
                Spacer()
            } else {
                NavigationSplitView {
                    Picker("Select a semester", selection: $semester) {
                        Text("All").tag(0)
                        Text("Fall").tag(1)
                        Text("Spring").tag(2)
                    }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                    if semester == 0 {
                        Toggle("Show Occasional", isOn: $isOccasional)
                            .padding(.horizontal)
                    }
                    List(items.filter({
                        if searchText != "", let title = $0.courseTitleLong {
                            if !title.lowercased().contains(searchText.lowercased()) {
                                return false
                            }
                        }
                        switch semester {
                        case 1: return (($0.termsStr?.contains("FALL")) == true)
                        case 2: return (($0.termsStr?.contains("SPRING")) == true || ($0.termsStr?.contains("SPRNG")) == true)
                        default:
                            return isOccasional || $0.termsStr?.contains("OCCASIONAL") == false
                        }
                    }), id:\.self.courseID, selection: $selection) {item in
                        HStack{
                            Text("\(item.catalogNumber.trimmingCharacters(in: .whitespaces)) \(item.courseTitleLong ?? "")")
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .badge(badge(item.termsStr, added: shoppingCart.isAdded(item)))
                                .padding(.all, 10.0)
                                .background(
                                    item.subject.code.contains("MENG") ?
                                    RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.red.opacity(0.8)) :
                                    RoundedRectangle(cornerRadius: 20, style: .continuous).fill(.red.opacity(0.0))
                                )
                        }
                    }.searchable(text: $searchText, prompt: "Search course title")
                        .navigationBarTitle("Course Listing")
                        .navigationBarTitleDisplayMode(.inline)
                } detail: {
                    if let selection, let course = itemsMap[selection] {
                        CourseDetailView(course: .constant(course))
                    } else {
                        Text("Select a course on the left to view its detail.")
                            .font(.title)
                    }
                }
            }
        }
        .onAppear {
            Task {
                let ECECourses = try await downloadCoursesBySubject("ECE")
                let MENGCourses = try await downloadCoursesBySubject("MENG")
                items = (MENGCourses.filter({
                    let num = $0.catalogNumber.trimmingCharacters(in: .whitespaces)
                    return num == "570" || num == "540"
                }) + ECECourses.filter({$0.catalogNumber.trimmingCharacters(in: .whitespaces) >= "500"})).filter({
                    return !$0.catalogNumber.contains("K")
                })
                itemsMap = Dictionary(uniqueKeysWithValues: items.map{ ($0.courseID, $0) })
                loading = false
            }
        }
    }

    func badge(_ str: String?, added: Bool) -> Text? {
        if added {
            return Text("Added").foregroundColor(.green)
        }
        switch str {
        case "FALL":
            return Text("Fall")
        case "SPRING":
            return Text("Spring")
        case "OCCASIONAL":
            return Text("Occasional")
        default:
            return nil
        }
    }
}

#Preview {
    CourseListingView()
}
