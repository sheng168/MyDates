//
//  MyDatesApp.swift
//  MyDates
//
//  Created by Jin on 8/22/23.
//

import SwiftUI
import SwiftData
import os
import KeweApp

typealias MyAnalytics = KeweAnalytics

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseInit.config()
        MyAnalytics.action("load")
        
        print(Config.shared.toJsonString()!)
        
        return true
    }
}

extension Encodable {
    func toJsonString() -> String? {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error encoding struct to JSON: \(error)")
            return nil
        }
    }
}

extension Decodable {
    static func fromJsonString(_ jsonString: String) -> Self? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert JSON string to data.")
            return nil
        }
        
        let jsonDecoder = JSONDecoder()
        
        do {
            let decodedObject = try jsonDecoder.decode(Self.self, from: jsonData)
            return decodedObject
        } catch {
            print("Error decoding JSON string to struct: \(error)")
            return nil
        }
    }
}

@main
struct MyDatesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

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
