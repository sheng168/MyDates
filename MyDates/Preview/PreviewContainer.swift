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
            Item(timestamp: Date()),
            Item(timestamp: Date()),
            Item(timestamp: Date()),
        ]
        
        for item in items {
            container.mainContext.insert(item)
        }
        
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()