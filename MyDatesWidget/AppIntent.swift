//
//  AppIntent.swift
//  MyDatesWidget
//
//  Created by Jin on 1/30/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Event"
    static var description = IntentDescription("Selects the event to display information for.")

    // An example configurable parameter.
//    @Parameter(title: "Favorite Emoji", default: "😃")
//    var favoriteEmoji: String
    
    @Parameter(title: "Event")
    var character: CharacterDetail


    init(character: CharacterDetail) {
        self.character = character
    }

    init() {
    }
}

struct CharacterDetail: AppEntity {
    let id: String
    let avatar: String
    let healthLevel: Double
    let date: Date
    let isAvailable = true
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Character"
    static var defaultQuery = CharacterQuery()
            
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(avatar) \(id)")
    }


    static let allCharacters: [CharacterDetail] = [
        CharacterDetail(id: "🤖 Tesla CyberTaxis Event 🚖", avatar: "", healthLevel: 0.14, date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 10, hour: 10))!),
        CharacterDetail(id: "🔋 Tesla 100M 4680 Cells", avatar: "", healthLevel: 0.67, date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 14, hour: 14))!),
//        CharacterDetail(id: "Power Panda", avatar: "🐼", healthLevel: 0.14, date: "Forest Dweller"),
//        CharacterDetail(id: "Unipony", avatar: "🦄", healthLevel: 0.67, date: "Free Rangers"),
//        CharacterDetail(id: "Spouty", avatar: "🐳", healthLevel: 0.83, date: "Deep Sea Goer")
    ]
}

struct CharacterQuery: EntityQuery {
    func entities(for identifiers: [CharacterDetail.ID]) async throws -> [CharacterDetail] {
        CharacterDetail.allCharacters.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [CharacterDetail] {
        CharacterDetail.allCharacters.filter { $0.isAvailable }
    }
    
    func defaultResult() async -> CharacterDetail? {
        try? await suggestedEntities().first
    }
}
