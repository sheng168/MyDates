//
//  Config.swift
//  MyDates
//
//  Created by Jin on 9/20/23.
//

import Foundation
import KeweApp

struct Config: Codable {
    static var shared = Config()
    
    var tabList = [
        Tab(label: "Dates", systemImage: KeweSymbols.list, tag: Tabs.List.rawValue),
        Tab(label: Tabs.Wishlist.rawValue, systemImage: "gift", tag: Tabs.Wishlist.rawValue),
        Tab(label: Tabs.Buy.rawValue, systemImage: KeweSymbols.shop, tag: Tabs.Buy.rawValue),
        Tab(label: Tabs.About.rawValue, systemImage: KeweSymbols.setting, tag: Tabs.About.rawValue),
    ]
    
    var about = [
        Section(id: "About", detail: """
        I built this app to replace one that I've been using. I felt that $10 per year to remove baner ads and access premium features was too much for such as simple app.
        
        While my app is currently free, I plan to charge $1 per year so that it can be maintained and enhanced.
        """),
        Section(id: "Features", detail:"""
        - Save list of name and date
        - Quickly see family members' age
        - Calculate year, month, day, hour, minute, seconds
        - Count down to future days
        - Backup and sync to all your iPhone/iPads using your apple ID
        """),
        Section(id: "Todos", detail:"""
        - Set image or icon with each entry
        - Organize entries into groups
        - Display preferences
        """),        
    ]
    
    var sampleEvents = [
        Event(name: "Tesla CyberTaxi Event", date: dateParser(s: "2024-10-10")!),
        Event(name: "Anniversary", date: Date(timeIntervalSince1970: 161800))
        ]
}

func dateParser(s: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.date(from: s)
}
