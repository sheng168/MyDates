//
//  ItemDetail.swift
//  MyDates
//
//  Created by Jin on 8/23/23.
//

import SwiftUI
import os
import FirebaseRemoteConfig

struct ItemDetail: View {
    @EnvironmentObject var stateManager: StateManager
    @Bindable var item: Item
    
    @RemoteConfigProperty(key: "showDebug", fallback: true) var showDebug: Bool
    
    var body: some View {
        Form {
            Section("Edit") {
                TextField("Name", text: $item.name)
                DatePicker(selection: $item.timestamp, displayedComponents: [.date, .hourAndMinute]) {
                    Text("Select a date")
                }
//                .datePickerStyle(.compact)
                TextField("Notes", text: $item.notes)
            }
            
            if showDebug {
                Section("Debug") {
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
