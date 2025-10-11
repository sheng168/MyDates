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
    @State private var expanded: [String: Bool] = [:]

    var body: some View {
        NavigationView {
            List {
                Section(
                    isExpanded: Binding(
                        get: { expanded["__untagged__", default: true] },
                        set: { expanded["__untagged__"] = $0 }
                    ),
                    content: {
                        let untagged = allItems.filter { ($0.tags ?? []).isEmpty }
                        if !untagged.isEmpty {
                            ForEach(untagged) { item in
                                let d = diffs(item.targetDate(), Date())
                                NavigationLink(destination: ItemDetail(item: item)) {
                                    ItemRowView(item: item, d: d)
                                }
                            }
                        } else {
                            Text("No untagged items").foregroundColor(.secondary)
                        }
                    },
                    header: { Text("Untagged").font(.headline) }
                )
                ForEach(allTags) { tag in
                    Section(
                        isExpanded: Binding(
                            get: { expanded[tag.id, default: true] },
                            set: { expanded[tag.id] = $0 }
                        ),
                        content: {
                                if let items = tag.items, !items.isEmpty {
                                    ForEach(items) { item in
                                        let d = diffs(item.targetDate(), Date())
                                        NavigationLink(destination: ItemDetail(item: item)) {
                                            ItemRowView(item: item, d: d)
                                        }
                                    }
                                } else {
                                    Text("No items with this tag").foregroundColor(.secondary)
                                }
                        },
                        header:
                            { Text(tag.name).font(.headline) }
                    )
                }
            }
            .listStyle(.sidebar)
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
            .onAppear {
                for tag in allTags {
                    if expanded[tag.id] == nil {
                        expanded[tag.id] = true
                    }
                }
                if expanded["__untagged__"] == nil {
                    expanded["__untagged__"] = true
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
