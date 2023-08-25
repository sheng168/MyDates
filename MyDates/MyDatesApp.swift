//
//  MyDatesApp.swift
//  MyDates
//
//  Created by Jin on 8/22/23.
//

import SwiftUI
import SwiftData

import os

@main
struct MyDatesApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
    
    let container: ModelContainer = {
            // Don't force unwrap for real 👀
//            ModelContainer(
            try! ModelContainer(
                for: Item.self
//                .init(
//                    "iCloud.us.jsy.MyDates"
//                )
            )
        }()
}

extension Logger {
    static let main = Logger(subsystem: "us.jsy", category: "main")
}

let logger = Logger.main
