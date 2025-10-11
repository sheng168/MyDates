import SwiftUI
import SwiftData

struct TagsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allTags: [Tag]
    @Query private var allItems: [Item]
    @EnvironmentObject var stateManager: StateManager
    @State private var newTagName: String = ""
    @State private var isPresentingNewTagSheet = false
    @State private var expandedTagIDs: Set<String> = []

    var body: some View {
        NavigationView {
            List {
                ForEach(allTags) { tag in
                    Section(header:
                        HStack {
                            Button(action: {
                                if expandedTagIDs.contains(tag.id) {
                                    expandedTagIDs.remove(tag.id)
                                } else {
                                    expandedTagIDs.insert(tag.id)
                                }
                            }) {
                                Image(systemName: expandedTagIDs.contains(tag.id) ? "chevron.down" : "chevron.right")
                            }
                            .buttonStyle(.plain)
                            Text(tag.name).font(.headline)
                        }
                    ) {
                        if expandedTagIDs.contains(tag.id) {
                            if let items = tag.items, !items.isEmpty {
                                ForEach(items) { item in
                                    NavigationLink(destination: ItemDetail(item: item)) {
                                        Text(item.name)
                                    }
                                }
                            } else {
                                Text("No items with this tag").foregroundColor(.secondary)
                            }
                        } else {
                            if let items = tag.items {
                                Text("(\(items.count)) items").foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tags")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresentingNewTagSheet = true
                    }) {
                        Label("Add Tag", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewTagSheet) {
                NavigationView {
                    Form {
                        Section(header: Text("Tag Name")) {
                            TextField("Enter name", text: $newTagName)
                        }
                    }
                    .navigationTitle("New Tag")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingNewTagSheet = false
                                newTagName = ""
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let trimmed = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard !trimmed.isEmpty else { return }
                                let newTag = Tag(name: trimmed)
                                modelContext.insert(newTag)
                                stateManager.tab = .Tags
                                isPresentingNewTagSheet = false
                                newTagName = ""
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TagsListView()
        .modelContainer(previewContainer)
        .environmentObject(StateManager())
}
