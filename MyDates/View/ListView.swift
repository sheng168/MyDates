//
//  ListView.swift
//  MyDates
//
//  Created by Jin on 8/30/23.
//

import SwiftUI
import SwiftData
import StoreKit

struct ListView: View {
    @EnvironmentObject var stateManager: StateManager

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) private var items: [Item]
    
    @State var currentTime = Date()
    @AppStorage("isPro") private var isPro = false
    
    private var maxItems: Int {
        if isPro {
            800
        } else {
            8
        }
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
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
            }
            .navigationTitle("\(items.count) Events")
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
        }
//        } detail: {
//            Text("Select an item")
//        }
        .onAppear {
            MyAnalytics.view(self)
        }
    }

    private func addItem() {
        MyAnalytics.action("add")
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        MyAnalytics.action("delete")
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ListView()
        .modelContainer(previewContainer)
        .environmentObject(StateManager())

}
