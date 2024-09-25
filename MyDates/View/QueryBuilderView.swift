//
//  QueryBuilderView.swift
//  MyDates
//
//  Created by Jin on 1/16/24.
//

import SwiftUI

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
                                Text("Name (A-Z)")
                                    .tag([SortDescriptor(\Item.name)])
                                Text("Name (Z-A)")
                                    .tag([SortDescriptor(\Item.name,
                                        order: .reverse)])

                                Text("Date")
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
