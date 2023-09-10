//
//  MyDatesApp.swift
//  MyDates
//
//  Created by Jin on 8/22/23.
//

import SwiftUI
import SwiftData
import Umbrella

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
//        analytics.register(provider: FirebaseProvider())

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
let analytics = Analytics<MyAppEvent>()

enum MyAppEvent {
  case signup(username: String)
  case viewContent(productID: Int)
  case purchase(productID: Int, price: Float)
}

extension MyAppEvent: EventType {
  /// An event name to be logged
  func name(for provider: ProviderType) -> String? {
    switch self {
    case .signup: return "signup"
    case .viewContent: return "view_content"
    case .purchase: return "purchase"
    }
  }

  /// Parameters to be logged
  func parameters(for provider: ProviderType) -> [String: Any]? {
    switch self {
    case let .signup(username):
      return ["username": username]
    case let .viewContent(productID):
      return ["product_id": productID]
    case let .purchase(productID, price):
      return ["product_id": productID, "price": price]
    }
  }
}
