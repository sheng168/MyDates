//
//  QueryBuilderView.swift
//  MyDates
//
//  Created by Jin on 1/16/24.
//

import SwiftUI
import KeweApp

struct QueryBuilderView: View {
    @State var searchText = ""
    @State var sortOrder = [SortDescriptor(\Item.timestamp, order: .reverse)]
    
    var body: some View {
        NavigationView {
            ListView(searchString: searchText, sortOrder: sortOrder)
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort", selection: $sortOrder) {
                                RemoteText("Name (A-Z)")
                                    .tag([SortDescriptor(\Item.name)])
                                RemoteText("Name (Z-A)")
                                    .tag([SortDescriptor(\Item.name,
                                        order: .reverse)])

                                RemoteText("Date")
                                    .tag([SortDescriptor(\Item.timestamp, order: .reverse)])
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    QueryBuilderView()
}
