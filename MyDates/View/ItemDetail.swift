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

struct ItemDetail: View {
    @EnvironmentObject var stateManager: StateManager
    @Bindable var item: Item
    
    @RemoteConfigProperty(key: "showDebug", fallback: true) var showDebug: Bool
    
    var body: some View {
        Form {
            Section("Edit") {
                TextField("Name", text: $item.name)
                    .autocapitalization(.words)
                
                DatePicker(selection: $item.timestamp, displayedComponents: [.date, .hourAndMinute]) {
                    Text("Select a date")
                }
//                .datePickerStyle(.compact)
                TextField("Notes", text: $item.notes)
            }
            
            if showDebug {
                Section("Debug") {
                    Button {
                        startDeliveryPizza()
                    } label: {
                        Text("Start Activity")
                    }
                    
                    Text(Event(name: item.name, date: item.timestamp).toJsonString() ?? "{}")
                        .textSelection(.enabled)
                    Text(item.timestamp, style: .relative)
                    Text(diffs(item.timestamp, .now).description)
                    Text("\(item.timestamp - 60*60*23, style: .timer)")
                    Text("Debug ID: \(item.id.storeIdentifier ?? "-")")
                    Button {
                        stateManager.selection = nil
                    } label: {
                        Text("Go Back")
                    }
                    Button {
                        stateManager.selection = "Alex"
                    } label: {
                        Text("Alex")
                    }
                    
                    Button {
                        stateManager.tab = .About
                    } label: {
                        Text("About")
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
    
    func startDeliveryPizza() {
//        startingEvent = true
        
        print(ActivityAuthorizationInfo().areActivitiesEnabled)
        
        let pizzaDeliveryAttributes = PizzaDeliveryAttributes(numberOfPizzas: 3, totalAmount:"$8")

        let initialContentState = PizzaDeliveryAttributes.PizzaDeliveryStatus(driverName: "\(item.name) 👨🏻‍🍳", estimatedDeliveryTime: Date()...Date().addingTimeInterval(15 * 60))
                                                  
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
