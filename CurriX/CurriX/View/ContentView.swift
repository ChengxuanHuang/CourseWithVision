//
//  ContentView.swift
//  CurriX
//
//  Created by Welkin Y on 3/7/24.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Term.termNumber, order: .reverse) private var allterm: [Term]
    @Query(sort: \Subject.code) private var allsubject: [Subject]
    @Binding var showing: [String]
    @Binding var size: (CGFloat, CGFloat)
    @EnvironmentObject var shoppingCart: UserChosenShoppingCart
    @EnvironmentObject var calendar: UserChosenCalendar
    @State var activeTab: Int = 2
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        TabView(selection: $activeTab){
            CourseListingView().tabItem {
                Label("Listing", systemImage: "list.bullet")
            }.tag(2)
            VStack {
                HStack {
                    CalendarView(chosenTerm: "1830", termText: "2023 Spring", showing: $showing)
                        .frame(minWidth: size.0/2, idealWidth: size.0/2, maxWidth: size.0, minHeight: size.1/2, idealHeight: size.1/2, maxHeight: size.1)
                        .padding()
                    CalendarView(chosenTerm: "1860", termText: "2023 Fall", showing: $showing)
                        .frame(minWidth: size.0/2, idealWidth: size.0/2, maxWidth: size.0, minHeight: size.1/2, idealHeight: size.1/2, maxHeight: size.1)
                        .padding()
                }
                HStack {
                    CalendarView(chosenTerm: "1870", termText: "2024 Spring", showing: $showing)
                        .frame(minWidth: size.0/2, idealWidth: size.0/2, maxWidth: size.0, minHeight: size.1/2, idealHeight: size.1/2, maxHeight: size.1)
                        .padding()
                    CalendarView(chosenTerm: "1900", termText: "2024 Fall", showing: $showing)
                        .frame(minWidth: size.0/2, idealWidth: size.0/2, maxWidth: size.0, minHeight: size.1/2, idealHeight: size.1/2, maxHeight: size.1)
                        .padding()
                }
            }
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(0)
        } .onAppear {
            do {
                try modelContext.delete(model: Term.self)
                try modelContext.delete(model: Subject.self)
            } catch {
                print("Failed to clear all data.")
            }

            Task {
                try await AllTerms.shared.obtainTerms()
                AllTerms.shared.terms.forEach {
                    modelContext.insert($0)
                }
            }

            Task {
                try await AllSubjects.shared.obtainSubjects()
                AllSubjects.shared.subjects.forEach {
                    modelContext.insert($0)
                }
            }
        }
        .task(id: activeTab) {
            switch activeTab {
            case 0:
                dismissWindow(id: "shopping-cart")
                size = (1920, 1280)
                openWindow(id: "shopping-cart")
            default:
                size = (1280, 720)
                dismissWindow(id: "shopping-cart")
            }
        }
    }
}
