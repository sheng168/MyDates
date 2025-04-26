//
//  Item.swift
//  MyDates
//
//  Created by Jin on 8/22/23.
//

import Foundation
import SwiftData

@Model
class Item: Identifiable { 
    var id = UUID().uuidString
    var timestamp = Date()
    var name: String = "New Event"
    var notes: String = ""
//    var count: Int
//    var icon: String?
//    var stalls: Int?
    
    @Relationship(deleteRule: .cascade, inverse: \Reset.item)
    var resets: [Reset]? = []
    
    @Transient var distance: Double = 0
    
    init(name: String = "New Event", timestamp: Date = Date()) {
        self.timestamp = timestamp
//        self.count = count
        self.name = name
//        self.icon = "-"
        
//        logger.info("id \(self.id)")
    }
}

@Model
class Reset: Identifiable {
    var id = UUID().uuidString
    var timestamp = Date()
    var item: Item?
    
    init(item: Item, timestamp: Date = Date()) {
        self.item = item
        self.timestamp = timestamp
    }
}

