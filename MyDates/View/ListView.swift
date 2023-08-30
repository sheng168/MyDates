//
//  ListView.swift
//  MyDates
//
//  Created by Jin on 8/30/23.
//

import SwiftUI
import SwiftData

struct ListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.name, order: .forward) private var items: [Item]
    
    @State var currentTime = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    let d = diffs(item.timestamp, currentTime)
                    
                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        ItemDetail(item: item)
                    } label: {
                        LabeledContent {
                            VStack {
                                Text(d.year ?? 0, format: .number)
                                Text("Year")
                            }
                        } label: {
                            Text(item.name)
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                            Text(d.description).lineLimit(1)
                        }

                        
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .onReceive(timer, perform: { date in
                logger.notice("\(date)")
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
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
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
}
