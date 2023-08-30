//
//  ContentView.swift
//  MyDates
//
//  Created by Jin on 8/22/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.name, order: .forward) private var items: [Item]
    
    @State var currentTime = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        TabView { //}(selection: $viewModel.state.value.selectedTab) {
            ListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Reviews")
                }
            
            Text("TODO")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(3)

        }
    }

    
}

#Preview {
    ContentView()    
        .modelContainer(previewContainer)
}
