//
//  PizzaDeliveryAttributes.swift
//  iOS16-Live-Activities
//
//  Created by Ming on 29/7/2022.
//

import SwiftUI
import ActivityKit
import AppIntents

struct PizzaDeliveryAttributes: ActivityAttributes {
    public typealias PizzaDeliveryStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var name: String
        var dateRange: ClosedRange<Date>
    }

    var numberOfPizzas: Int
    let id: String
}

struct PizzaAdAttributes_: ActivityAttributes {
    public typealias PizzaAdStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var adName: String
        var showTime: Date
    }
    var discount: String
}

struct CancelIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Cancel"
    
    init() {
    }
    
    init(id: String) {
        self.id = id
    }
    
    @Parameter(title: "VIN", default: "😃")
    var id: String
    
    func perform() async throws -> some IntentResult {
        print(self, id)
        
        return .result()
    }
}
