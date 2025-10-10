import SwiftUI
import SwiftData

struct TagsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allTags: [Tag]
    @Query private var allItems: [Item]

    var body: some View {
        NavigationView {
            List {
                ForEach(allTags) { tag in
                    Section(header: Text(tag.name).font(.headline)) {
                        if let items = tag.items, !items.isEmpty {
                            ForEach(items) { item in
                                NavigationLink(destination: ItemDetail(item: item)) {
                                    Text(item.name)
                                }
                            }
                        } else {
                            Text("No items with this tag").foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Tags")
        }
    }
}

#Preview {
    TagsListView()
        .modelContainer(previewContainer)
        .environmentObject(StateManager())
}
