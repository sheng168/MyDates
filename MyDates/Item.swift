//
//  Item.swift
//  MyDates
//
//  Created by Jin on 8/22/23.
//

import Foundation
import SwiftData

@Model
class Item { 
    var timestamp = Date()
    var name: String = "New Event"
//    var count: Int
//    var icon: String?
//    var stalls: Int?
    
    @Transient var distance: Double = 0
    
    init(timestamp: Date = Date(), name: String = "New Event") {
        self.timestamp = timestamp
//        self.count = count
        self.name = name
//        self.icon = "-"
    }
}
