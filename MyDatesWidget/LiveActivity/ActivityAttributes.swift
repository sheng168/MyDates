//
//  PizzaDeliveryAttributes.swift
//  iOS16-Live-Activities
//
//  Created by Ming on 29/7/2022.
//

import SwiftUI
import ActivityKit

struct PizzaDeliveryAttributes: ActivityAttributes {
    public typealias PizzaDeliveryStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var name: String
        var estimatedDeliveryTime: ClosedRange<Date>
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
