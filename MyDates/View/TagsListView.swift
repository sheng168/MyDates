import SwiftUI
import SwiftData

struct TagsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Tag.name, order: .forward)]) private var allTags: [Tag]
    @Query private var allItems: [Item]
    @EnvironmentObject var stateManager: StateManager
    @State private var newTagName: String = ""
    @State private var isPresentingNewTagSheet = false
    @State private var expandedTagIDs: Set<String> = []
    @State private var expanded: [String: Bool] = [:]

    /// Formats the duration between two adjacent rows.
    private let gapFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .abbreviated
        f.allowedUnits = [.year, .month, .day, .hour, .minute]
        f.maximumUnitCount = 2
        return f
    }()

    /// A subtle separator row showing the time gap between two adjacent events.
    @ViewBuilder
    private func adjacentDiffRow(from: Item, to: Item) -> some View {
        let start = Swift.min(from.targetDate(), to.targetDate())
        let end = Swift.max(from.targetDate(), to.targetDate())

        HStack(spacing: 4) {
            Image(systemName: "arrow.up.and.down")
            Text(gapFormatter.string(from: start, to: end) ?? "")
        }
        .font(.caption2)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .center)
        .listRowBackground(Color.clear)
    }

    var body: some View {
        NavigationView {
            List {
                Section(
                    isExpanded: Binding(
                        get: { expanded["__untagged__", default: true] },
                        set: { expanded["__untagged__"] = $0 }
                    ),
                    content: {
                        let untagged = allItems
                            .filter { ($0.tags ?? []).isEmpty }
                            .sorted(by: { lhs, rhs in
                                let lDate = lhs.targetDate()
                                let rDate = rhs.targetDate()
                                if lDate != rDate { return lDate < rDate }
                                return lhs.name < rhs.name
                            })
                        if !untagged.isEmpty {
                            ForEach(Array(untagged.enumerated()), id: \.element.id) { index, item in
                                let d = diffs(item.targetDate(), Date())
                                NavigationLink(destination: ItemDetail(item: item)) {
                                    ItemRowView(item: item, d: d)
                                }

                                // Show the time difference to the adjacent (next) row.
                                if index < untagged.count - 1 {
                                    adjacentDiffRow(from: item, to: untagged[index + 1])
                                }
                            }
                        } else {
                            Text("No untagged items").foregroundColor(.secondary)
                        }
                    },
                    header: {
                        let untaggedCount = allItems.filter { ($0.tags ?? []).isEmpty }.count
                        Text("Untagged (\(untaggedCount))").font(.headline)
                    }
                )
                ForEach(allTags) { tag in
                    Section(
                        isExpanded: Binding(
                            get: { expanded[tag.id, default: true] },
                            set: { expanded[tag.id] = $0 }
                        ),
                        content: {
                                if let items = tag.items?.sorted(by: { lhs, rhs in
                                    let lDate = lhs.targetDate()
                                    let rDate = rhs.targetDate()
                                    if lDate != rDate { return lDate < rDate }
                                    return lhs.name < rhs.name
                                }), !items.isEmpty {
                                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                                        let d = diffs(item.targetDate(), Date())
                                        NavigationLink(destination: ItemDetail(item: item)) {
                                            ItemRowView(item: item, d: d)
                                        }

                                        // Show the time difference to the adjacent (next) row.
                                        if index < items.count - 1 {
                                            adjacentDiffRow(from: item, to: items[index + 1])
                                        }
                                    }
                                } else {
                                    Text("No items with this tag").foregroundColor(.secondary)
                                }
                        },
                        header: {
                            let count = (tag.items ?? []).count
                            Text("\(tag.name) (\(count))").font(.headline)
                        }
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
