//
//  ListView.swift
//  MyDates
//
//  Created by Jin on 8/30/23.
//

import SwiftUI
import AppIntents
import SwiftData
import StoreKit
import FirebaseRemoteConfig
import WidgetKit

struct ListView: View {
    @EnvironmentObject var stateManager: StateManager

    @Environment(\.modelContext) private var modelContext
    @Query
    private var items: [Item]
    
    @State var currentTime = Date()
    @AppStorage("isPro") private var isPro = false
    
    @RemoteConfigProperty(key: "maxFreeItems", fallback: 8) var max: Int
    @RemoteConfigProperty(key: "insertSamples", fallback: "Insert Samples") var insertSamples: String
    @RemoteConfigProperty(key: "uiTitle", fallback: "Events") var uiTitle: String
    
    @RemoteConfigProperty(key: "enableInsertSample", fallback: true) var enableInsertSample: Bool
    @RemoteConfigProperty(key: "sampleEvents", fallback: Config.shared.sampleEvents) var sampleEvents: [Event]

    private var maxItems: Int {
        if isPro {
            800
        } else {
            max
        }
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(searchString: String = "", sortOrder: [SortDescriptor<Item>] = []) {
        _items = Query(filter: #Predicate { item in
            if searchString.isEmpty {
                true
            } else {
                item.name.localizedStandardContains(searchString)
            }
        }, sort: sortOrder)
    }
    
    var body: some View {
//        NavigationView {
            List {
                ForEach(items) { item in
                    let d = diffs(item.timestamp, currentTime)
                    
                    NavigationLink(tag: item.id, selection: $stateManager.selection) {
                        ItemDetail(item: item)
                    } label: {
                        ItemRowView(item: item, d: d)
                    }
                }
                .onDelete(perform: deleteItems)
                
                if enableInsertSample {
//                    Button("Pro \(isPro ? "Off" : "On")") {
//                        isPro.toggle()
//                    }
                    HStack {
                        Spacer() // Pushes the button to the center
                        Button(action: {
                            addSamples()
                        }) {
                            Text("\(insertSamples) \(sampleEvents.count)")
                                .fontWeight(.bold)
                                .frame(width: 150, height: 40)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        Spacer() // Pushes the button to the center
                    }
                }
            }
            .navigationTitle("\(items.count) \(uiTitle)")
            .onInAppPurchaseCompletion { (product: Product, result: Result<Product.PurchaseResult, Error>) in
                if case .success(.success(let transaction)) = result {
                    logger.info("iap: \(transaction.debugDescription)")
                }
            }
            .subscriptionStatusTask(for: "21385947", action: { taskState in
                logger.info("sub: \(taskState.value?.count ?? 0)")
                
                if let value = taskState.value {
                    isPro = !value
                        .filter { $0.state != .revoked && $0.state != .expired }
                        .isEmpty
                } else {
                    isPro = false
                }
            })
            .onReceive(timer, perform: { date in
//                logger.notice("timer \(date)")
                currentTime = date
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
//                    Button(intent: NewItemIntent()) {
//                        Label("Add Item", systemImage: "plus")
//                    }
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                    .disabled(items.count >= maxItems)
                }
#if DEBUG_
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        stateManager.selection = "Alex"
                    } label: {
                        Text("Alex")
                    }
                    
                }
#endif
            }
//        }
//        } detail: {
//            Text("Select an item")
//        }
        .onAppear {
            MyAnalytics.view(self)
//            UIApplication.shared.applicationIconBadgeNumber = 3
            UNUserNotificationCenter.current().setBadgeCount(18)

            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                    
                    UNUserNotificationCenter.current().setBadgeCount(7)
                } else if let error {
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func addItem() {
        MyAnalytics.action("add")
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func addSamples() {
        MyAnalytics.action("addSamples")
        withAnimation {
            for event in sampleEvents {
                let newItem = Item(name: event.name, timestamp: event.date)
                modelContext.insert(newItem)
            }
        }
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func deleteItems(offsets: IndexSet) {
        MyAnalytics.action("delete")
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
}

struct Event: Codable {
    var name: String
    var date: Date
}

#Preview {
    ListView()
        .modelContainer(previewContainer)
        .environmentObject(StateManager())

}
