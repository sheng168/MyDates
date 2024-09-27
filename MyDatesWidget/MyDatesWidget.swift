//
//  MyDatesWidget.swift
//  MyDatesWidget
//
//  Created by Jin on 1/30/24.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct MyDatesWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Query
    private var items: [Item]

    var body: some View {
        let date = entry.configuration.character?.date ?? entry.date
        
        LabeledContent {
            EmptyView()
        } label: {
            
//            ForEach(items) { item in
//                Text(item.name)
//            }
//            
            Text(date, style: .relative) // 2 units
//            Text(date, style: .offset) // +/- 1 unit

            Text(entry.configuration.character?.name ?? "-")
            
            Text("")
            Text(date, style: .date)
            Text(date, style: .time)
            Text(date, style: .timer)
//            Text("")
//            Text("Date Radar")
        }

        
    }
}

struct MyDatesWidget: Widget {
    let kind: String = "MyDatesWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MyDatesWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: Item.self)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "Tesla CyberTaxis Event 🤖🚖"
        intent.character = CharacterDetail.allCharacters.first!
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
        intent.character = CharacterDetail.allCharacters.last!
        return intent
    }
}

#Preview(as: .systemSmall

) {
    MyDatesWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
