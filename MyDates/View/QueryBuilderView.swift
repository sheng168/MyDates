//
//  QueryBuilderView.swift
//  MyDates
//
//  Created by Jin on 1/16/24.
//

import SwiftUI

struct QueryBuilderView: View {
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            ListView(searchString: searchText)
                .searchable(text: $searchText)
        }
    }
}

#Preview {
    QueryBuilderView()
}
