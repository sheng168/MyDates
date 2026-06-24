//
//  ItemDetail.swift
//  MyDates
//
//  Created by Jin on 8/23/23.
//

import SwiftUI
import SwiftData
//import os
import FirebaseRemoteConfig
import WidgetKit
import ActivityKit
import KeweApp


struct ItemDetail: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var stateManager: StateManager
    @Bindable var item: Item
    @Query private var allTags: [Tag]
    @State private var showAllResets = false
    @State private var newTagName: String = ""
    
    //    @RemoteConfigProperty(key: "showDebug", fallback: true) var showDebug: Bool
    //    @RemoteConfigProperty(key: "enableActivity", fallback: true) var enableActivity: Bool
    
    var body: some View {
        Form {
            let message = Text(item.targetDate(), style: .relative) + Text("\n\(item.name)\n") + Text(item.targetDate(), format: Date.FormatStyle(date: .numeric, time: .standard))
            
            
            
            Section("Edit") {
                TextField("Name", text: $item.name)
                    .autocapitalization(.words)
                
                DatePicker(selection: $item.timestamp, displayedComponents: [.date, .hourAndMinute]) {
                    RemoteText("Select a date")
                }
                
                // NOTE: SwiftUI's Stepper recurses infinitely in the style resolver
                // under "My Mac (Designed for iPhone)", so it's replaced with a pair
                // of buttons that clamp the offset to ±24h.
                HStack {
                    Text("Offset")
                    Spacer()
                    Text("\(Int(item.offset/3600))h")
                        .foregroundStyle(.secondary)
                    Button {
                        item.offset = max(item.offset - 60*60, -24*60*60)
                    } label: {
                        Image(systemName: "minus.circle")
                    }
                    .buttonStyle(.borderless)
                    Button {
                        item.offset = min(item.offset + 60*60, 24*60*60)
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .buttonStyle(.borderless)
                }
                
                RemoteConfigConditional(name: "enableRestart") {
                    Button {
                        item.timestamp = .now
                        modelContext.insert(Log(item: item, label: .reset))
                    } label: {
                        RemoteText("Reset to now")
                    }
                }
                
                //                .datePickerStyle(.compact)
                TextField("Notes", text: $item.notes)
                
                RemoteConfigConditional(name: "enableShare") {
                    // https://www.hackingwithswift.com/books/ios-swiftui/how-to-let-the-user-share-content-with-sharelink
                    ShareLink(item: URL(string: "https://apps.apple.com/us/app/date-radar-countdown-stopwatch/id6463448697")!, subject: Text("\(item.name)"), message: message)
                        // .simultaneousGesture(TapGesture().onEnded() {
                        //     print("clicked")
                        
                        //     modelContext.insert(Log(item: item, label: .share))
                        //     MyAnalytics.action("Share")
                        // })
                            
                }
                
                RemoteConfigConditional(name: "enableTwitter", fallback: true) {
                    let d = relativeTimeString(for: item.targetDate())
                    Button {
                        send(tweet: """
                            \(item.name)
                            \(d)
                            
                            Sent using @DateRadarApp
                            """)
                    } label: {
                        Text("Tweet/X") //  \(d)
                    }
                }
                
                RemoteConfigConditional(name: "enableActivity", fallback: true) {
                    Button {
                        startDeliveryPizza()
                    } label: {
                        RemoteText("Add to Lock Screen")
                    }
                }
            }

            Section("Tags") {
                let trimmedTagName = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
                let isDuplicateTag = allTags.contains { $0.name.caseInsensitiveCompare(trimmedTagName) == .orderedSame }
                HStack {
                    TextField("New tag...", text: $newTagName)
                    Button(action: {
                        let trimmed = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty, !isDuplicateTag else { return }
                        let newTag = Tag(name: trimmed)
                        modelContext.insert(newTag)
                        newTagName = ""

                        // Add to this item's tags
                        if item.tags == nil {
                            item.tags = [newTag]
                        } else {
                            item.tags?.append(newTag)
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.accentColor)
                    }
                    .disabled(trimmedTagName.isEmpty || isDuplicateTag)
                }
                if isDuplicateTag && !trimmedTagName.isEmpty {
                    Text("A tag with this name already exists.")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                ForEach(allTags) { tag in
                    let isSelected = (item.tags ?? []).contains(where: { $0.id == tag.id })
                    Toggle(tag.name, isOn: Binding(
                        get: { isSelected },
                        set: { newValue in
                            if newValue {
                                if !isSelected {
                                    if item.tags == nil { item.tags = [] }
                                    item.tags?.append(tag)
                                }
                            } else {
                                item.tags?.removeAll { $0.id == tag.id }
                            }
                        }
                    ))
                }
            }
            
            if let resets = item.resets {
                Section("Log: (\(resets.count))") {
                    ForEach(showAllResets ? resets.reversed().prefix(50) : resets.reversed().prefix(5)) { r in
                        LabeledContent {
                            Text(r.label.rawValue)
                                .foregroundColor(.secondary)
                        } label: {
                            Text("\(r.timestamp, style: .relative)")
                        }
                    }
                    
                    if resets.count > 5 {
                        Button(showAllResets ? "Show Less" : "Show More") {
                            showAllResets.toggle()
                        }
                    }
                }
            }
            
            Section("Widget Preview") {
                MyWidgetView(date: item.targetDate(), name: item.name)
            }
            
            Section("Lock Screen Preview") {
                Text("Coming soon...")
                //                MyWidgetView(date: item.timestamp, name: item.name)
            }
            
            RemoteConfigConditional(name: "showDebug") {
                Section("Debug") {
                    message
                    
                    Text(Event(name: item.name, date: item.targetDate()).toJsonString() ?? "{}")
                        .textSelection(.enabled)
                    Text(item.targetDate(), style: .relative)
                    Text(diffs(item.targetDate(), .now).description)
                    Text("\(item.targetDate() - 60*60*23, style: .timer)")
                    Text("Debug ID: \(item.id.storeIdentifier ?? "-")")
                    Button {
                        stateManager.selection = nil
                    } label: {
                        RemoteText("Go Back")
                    }
                    Button {
                        stateManager.selection = "Alex"
                    } label: {
                        RemoteText("Alex")
                    }
                    
                    Button {
                        stateManager.tab = .About
                    } label: {
                        RemoteText("About")
                    }
                }
            }
        }
        .onAppear {
            MyAnalytics.view(self)
        }
        .onDisappear {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    // Function to get the relative time as a string
    func relativeTimeString(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full // You can customize the style (.short, .full, etc.)
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

extension ItemDetail { // activity
    
    func startDeliveryPizza() {
        //        startingEvent = true
        
        print(ActivityAuthorizationInfo().areActivitiesEnabled)
        
        let pizzaDeliveryAttributes = PizzaDeliveryAttributes(id: item.id)
                
        let initialContentState = PizzaDeliveryAttributes.PizzaDeliveryStatus(name: "\(item.name)", timestamp: item.timestamp)
        
        do {
            let deliveryActivity = try Activity<PizzaDeliveryAttributes>.request(
                attributes: pizzaDeliveryAttributes,
                content: ActivityContent(state: initialContentState, staleDate: nil),
                pushType: .token)   // Enable Push Notification Capability First (from pushType: nil)
            
            print("Requested a pizza delivery Live Activity \(deliveryActivity.id)")
            
            // Send the push token to server
            Task {
                for await pushToken in deliveryActivity.pushTokenUpdates {
                    let pushTokenString = pushToken.reduce("") { $0 + String(format: "%02x", $1) }
                    print(pushTokenString)
                    
                    //                    alertMsg = "Requested a pizza delivery Live Activity \(deliveryActivity.id)\n\nPush Token: \(pushTokenString)"
                    //                    showAlert = true
                    //                    startingEvent = false
                }
            }
        } catch (let error) {
            print("Error requesting pizza delivery Live Activity \(error.localizedDescription)")
            //            alertMsg = "Error requesting pizza delivery Live Activity \(error.localizedDescription)"
            //            showAlert = true
            //            startingEvent = false
        }
    }
    func updateDeliveryPizza() {
        Task {
            let updatedDeliveryStatus = PizzaDeliveryAttributes.PizzaDeliveryStatus(name: "TIM 👨🏻‍🍳", timestamp: Date().addingTimeInterval(60 * 60))
            
            for activity in Activity<PizzaDeliveryAttributes>.activities{
                await activity.update(ActivityContent(state: updatedDeliveryStatus, staleDate: nil))
            }

            print("Updated pizza delivery Live Activity")
            
//            showAlert = true
//            alertMsg = "Updated pizza delivery Live Activity"
        }
    }
    func stopDeliveryPizza() {
        Task {
            for activity in Activity<PizzaDeliveryAttributes>.activities{
                await activity.end(nil, dismissalPolicy: .immediate)
            }

            print("Cancelled all pizza delivery Live Activity")

//            showAlert = true
//            alertMsg = "Cancelled pizza delivery Live Activity"
        }
    }
    func showAllDeliveries() {
        Task {
            var orders = ""
            for activity in Activity<PizzaDeliveryAttributes>.activities {
                print("Pizza delivery details: \(activity.id) -> \(activity.attributes)")
                orders.append("\n\(activity.id) -> \(activity.attributes)\n")
            }

//            showAlert = true
//            alertMsg = orders
        }
    }

}

func diffs(_ date: Date, _ date2: Date) -> DateComponents {
//    let fmt = ISO8601DateFormatter()

//    let date1 = fmt.date(from: "2017-08-06T19:20:42+0000")!
//    let date2 = fmt.date(from: "2020-08-06T19:20:46+0000")!
    

    let calComp: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
    
    let diffs = Calendar.current.dateComponents(calComp, from: date, to: date2)
//    logger.trace("\(diffs)")
    
//    if diffs.year == 0 {
//        diffs.year = nil
//        
//        if diffs.month == 0 {
//            diffs.month = nil
//        }
//    } else {
//        diffs.second = nil
//        diffs.minute = nil
//    }
    

    return diffs
}

#Preview {
    ModelPreview { item in
        ItemDetail(item: item)
            .modelContainer(previewContainer)
            .environmentObject(StateManager())
    }
//    Text("TODO")
}

