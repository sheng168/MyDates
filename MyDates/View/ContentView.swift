//
//  ContentView.swift
//  MyDates
//
//  Created by Jin on 8/22/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    enum Tabs: String {
        case List, About
    }
    
    @SceneStorage("tab") var tab = Tabs.About

    var body: some View {
        TabView (selection: $tab) {
            ListView()
                .tabItem {
                    Label(Tabs.List.rawValue, systemImage: "list.bullet")
                }
                .tag(Tabs.List)
            
            AboutView()
                .tabItem {
                    Label(Tabs.About.rawValue, systemImage: "gear")
                }
                .tag(Tabs.About)

        }
    }

    
}

#Preview {
    ContentView()    
        .modelContainer(previewContainer)
}
