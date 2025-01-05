//
//  CurriXApp.swift
//  CurriX
//
//  Created by Welkin Y on 3/7/24.
//

import SwiftUI
import SwiftData
import Logging

let logger: Logger = {
    var log = Logger(label: "CurriX")
    log.logLevel = .debug
    return log
}()

@main
struct CurriXApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Term.self, Subject.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State var showing: [String] = []
    @StateObject private var shoppingCart = UserChosenShoppingCart.shared
    @StateObject private var calendar = UserChosenCalendar.shared
    @State var size: (CGFloat, CGFloat) = (1920, 1080)

    var body: some Scene {
        WindowGroup {
            ContentView(showing: $showing, size: $size)
                .environmentObject(calendar)
                .environmentObject(shoppingCart)
                .frame(
                    minWidth: size.0, maxWidth: size.0,
                    minHeight: size.1, maxHeight: size.1
                )
        }
        .windowResizability(.contentSize)
        .modelContainer(sharedModelContainer)

        WindowGroup("", id: "shopping-cart") {
            ShoppingCartView()
                .environmentObject(calendar)
                .environmentObject(shoppingCart)
        }
        .defaultSize(width: 500, height: 300)
    }
}
