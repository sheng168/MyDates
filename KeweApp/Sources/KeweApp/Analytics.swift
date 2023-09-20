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


public class KeweAnalytics {
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

