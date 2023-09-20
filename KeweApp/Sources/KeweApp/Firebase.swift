//
//  Analytics.swift
//  RateYourCharge
//
//  Created by Jin on 9/18/23.
//

import Foundation
import SwiftUI

import FirebaseAnalytics
import FirebaseCore
import FirebaseRemoteConfig


public enum FirebaseInit {
    static var remoteConfig = RemoteConfig.remoteConfig()
    
    public static func config() {
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
