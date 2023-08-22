//
//  Item.swift
//  MyDates
//
//  Created by Jin on 8/22/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
