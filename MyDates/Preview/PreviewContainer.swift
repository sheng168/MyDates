//
//  PreviewContainer.swift
//  MyDates
//
//  Created by Jin on 8/24/23.
//

import Foundation
import SwiftData

// https://www.andrewcbancroft.com/blog/ios-development/data-persistence/pre-populate-swiftdata-persistent-store/

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        let items = [
            Item(name: "Son's Birthday", timestamp: Date() - 60*60*24*365*3.93),
            Item(name: "Daughter's Birthday", timestamp: Date() - 60*60*24*350),
            Item(name: "Start Timer", timestamp: Date()),
            Item(name: "Countdown", timestamp: Date() + 60*60*24*16),
            Item(name: "My Age", timestamp: Date() - 60*60*24*365*38.93),
        ]
        
        for item in items {
            let id = item.id
            logger.info("\(id )")
            
            container.mainContext.insert(item)
        }
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
