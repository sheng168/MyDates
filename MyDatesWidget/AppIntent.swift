//
//  AppIntent.swift
//  MyDatesWidget
//
//  Created by Jin on 1/30/24.
//

import WidgetKit
import AppIntents
import SwiftData

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Event"
    static var description = IntentDescription("Selects the event to display information for.")

    // An example configurable parameter.
//    @Parameter(title: "Favorite Emoji", default: "😃")
//    var favoriteEmoji: String
    
    @Parameter(title: "Event")
    var character: CharacterDetail?


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
    var isAvailable = true
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Event"
    static var defaultQuery = CharacterQuery()
            
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id) \(date, format: .dateTime)")
    }


    static let allCharacters: [CharacterDetail] = [
        CharacterDetail(id: "🤖 Tesla CyberTaxis Event 🚖", avatar: "", healthLevel: 0.14, date: Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 10, hour: 10))!),
        CharacterDetail(id: "🔋 Tesla 100M 4680 Cells", avatar: "", healthLevel: 0.67, date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 14, hour: 14))!, isAvailable: false),
//        CharacterDetail(id: "Power Panda", avatar: "🐼", healthLevel: 0.14, date: "Forest Dweller"),
//        CharacterDetail(id: "Unipony", avatar: "🦄", healthLevel: 0.67, date: "Free Rangers"),
//        CharacterDetail(id: "Spouty", avatar: "🐳", healthLevel: 0.83, date: "Deep Sea Goer")
    ]
}

struct CharacterQuery: EntityQuery {
//    @Query
//    private var items: [Item]

    func entities(for identifiers: [CharacterDetail.ID]) async throws -> [CharacterDetail] {
        CharacterDetail.allCharacters.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [CharacterDetail] {
        if false {
            CharacterDetail.allCharacters.filter { $0.isAvailable }
        } else {
            try await suggestedEntities_()
        }
    }
    
    func defaultResult() async -> CharacterDetail? {
        try? await suggestedEntities().first
    }
}

func suggestedEntities_() async throws -> [CharacterDetail] {
    try fetchTasks(context: ModelContext(SharedModelContainer.sharedModelContainer)).map { item in
        CharacterDetail(id: item.name, avatar: "", healthLevel: 0.14, date: item.timestamp)
    }
}

func fetchTasks(context: ModelContext) throws -> [Item] {
    let _ = FetchDescriptor<Item>(
        predicate: #Predicate<Item> { task in
            task.name.isEmpty == false
        },
        sortBy: [SortDescriptor(\Item.name)]
    )
    
    return try context.fetch(FetchDescriptor<Item>())
}

struct SharedModelContainer {
    static let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    private static func modelContext() -> ModelContext {
        let mc = ModelContext(sharedModelContainer)
//        mc.insert(VehicleItem())
//        try? mc.save()
        
        return mc
    }
}
