//
//  ItemDetail.swift
//  MyDates
//
//  Created by Jin on 8/23/23.
//

import SwiftUI
//import os
import FirebaseRemoteConfig
import WidgetKit
import ActivityKit
import KeweApp


struct ItemDetail: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var stateManager: StateManager
    @Bindable var item: Item
    @State private var showAllResets = false
    
    //    @RemoteConfigProperty(key: "showDebug", fallback: true) var showDebug: Bool
    //    @RemoteConfigProperty(key: "enableActivity", fallback: true) var enableActivity: Bool
    
    var body: some View {
        Form {
            let message = Text(item.timestamp, style: .relative) + Text("\n\(item.name)\n") + Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
            
            
            
            Section("Edit") {
                TextField("Name", text: $item.name)
                    .autocapitalization(.words)
                
                DatePicker(selection: $item.timestamp, displayedComponents: [.date, .hourAndMinute]) {
                    RemoteText("Select a date")
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
                    let d = relativeTimeString(for: item.timestamp)
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
                MyWidgetView(date: item.timestamp, name: item.name)
            }
            
            Section("Lock Screen Preview") {
                Text("Coming soon...")
                //                MyWidgetView(date: item.timestamp, name: item.name)
            }
            
            RemoteConfigConditional(name: "showDebug") {
                Section("Debug") {
                    message
                    
                    Text(Event(name: item.name, date: item.timestamp).toJsonString() ?? "{}")
                        .textSelection(.enabled)
                    Text(item.timestamp, style: .relative)
                    Text(diffs(item.timestamp, .now).description)
                    Text("\(item.timestamp - 60*60*23, style: .timer)")
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
                contentState: initialContentState,
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
                await activity.update(using: updatedDeliveryStatus)
            }

            print("Updated pizza delivery Live Activity")
            
//            showAlert = true
//            alertMsg = "Updated pizza delivery Live Activity"
        }
    }
    func stopDeliveryPizza() {
        Task {
            for activity in Activity<PizzaDeliveryAttributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
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
