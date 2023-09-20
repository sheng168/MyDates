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
        Tab(label: Tabs.List.rawValue, systemImage: KeweSymbols.list, tag: Tabs.List.rawValue),
        Tab(label: Tabs.About.rawValue, systemImage: KeweSymbols.setting, tag: Tabs.About.rawValue),
        Tab(label: Tabs.Buy.rawValue, systemImage: KeweSymbols.shop, tag: Tabs.Buy.rawValue),
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
}
