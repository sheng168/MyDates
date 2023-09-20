//
//  Analytics.swift
//  RateYourCharge
//
//  Created by Jin on 9/18/23.
//

import Foundation
import FirebaseAnalytics
import FirebaseCore
import FirebaseRemoteConfig
import SwiftUI


class MyAnalytics {
    public static func view(_ name: any View) {
        let t = type(of: name)
        let name = "\(t)"
        view(name)
    }

    public static func view(_ name: String) {
        var parameters: [String: Any] = [:]
        parameters[AnalyticsParameterScreenName] = name
        parameters[AnalyticsParameterScreenClass] = name
        Analytics.logEvent(AnalyticsEventScreenView, parameters: parameters)
    }
    
    public static func action(_ name: String) {
        var parameters: [String: Any] = [:]
//        parameters[AnalyticsParameterItemId] = id
        parameters[AnalyticsParameterItemName] = name
        Analytics.logEvent(AnalyticsEventSelectItem, parameters: parameters)
    }
}

enum FirebaseInit {
    static var remoteConfig = RemoteConfig.remoteConfig()
    
    static func config() {
        FirebaseApp.configure()
        
        // remote config
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        FirebaseInit.remoteConfig.configSettings = settings
        
        FirebaseInit.remoteConfig.addOnConfigUpdateListener { configUpdate, error in
            guard let configUpdate, error == nil else {
                return print("Error listening for config updates: \(error)")
            }
            
            print("Updated keys: \(configUpdate.updatedKeys)")
            
            FirebaseInit.remoteConfig.activate { changed, error in
                guard error == nil else { return print(error) }
//                DispatchQueue.main.async {
//                    self.displayWelcome()
//                }
            }
        }
        
        Task {
            try await FirebaseInit.remoteConfig.fetchAndActivate()
//            Config.shared.loadConfig()
        }
    }
}

/*
let analytics = Analytics<MyAppEvent>()
    .then { a in
        logger.debug("analytics")
//        analytics.register(provider: FirebaseProvider())
    }

extension Analytics: Then {}

enum MyAppEvent {
    case view(name: String)
    case signup(username: String)
    case viewContent(productID: Int)
    case purchase(productID: Int, price: Float)
}

extension MyAppEvent: EventType {
    /// An event name to be logged
    func name(for provider: ProviderType) -> String? {
        switch self {
        case .view: return "view"
        case .signup: return "signup"
        case .viewContent: return "view_content"
        case .purchase: return "purchase"
        }
    }
    
    /// Parameters to be logged
    func parameters(for provider: ProviderType) -> [String: Any]? {
        switch self {
        case let .view(name):
            return ["name": name]
        case let .signup(username):
            return ["username": username]
        case let .viewContent(productID):
            return ["product_id": productID]
        case let .purchase(productID, price):
            return ["product_id": productID, "price": price]
        }
    }
}
*/
