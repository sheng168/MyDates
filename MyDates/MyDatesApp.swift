//
//  MyDatesApp.swift
//  MyDates
//
//  Created by Jin on 8/22/23.
//

import SwiftUI
import SwiftData

@main
struct MyDatesApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
