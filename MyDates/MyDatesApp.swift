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
    static let testArg = "enable-testing"
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
        .environmentObject(StateManager())
    }
    
    let container: ModelContainer = {
#if DEBUG
            if CommandLine.arguments.contains(testArg) {
            //    configureAppForTesting()
                logger.info("testing mode")
            }
#endif
            // Don't force unwrap for real 👀
//            ModelContainer(
            return try! ModelContainer(
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
