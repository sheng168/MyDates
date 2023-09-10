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
        case List, About, Buy
    }
    @EnvironmentObject var stateManager: StateManager
//    @SceneStorage("tab") var tab = Tabs.About

    var body: some View {
        TabView (selection: $stateManager.tab) {
            ListView()
                .tabItem {
                    Label(Tabs.List.rawValue, systemImage: KeweSymbols.list)
                }
                .tag(Tabs.List)
            
            AboutView()
                .tabItem {
                    Label(Tabs.About.rawValue, systemImage: KeweSymbols.setting)
                }
                .tag(Tabs.About)

            MyStoreView()
                .tabItem {
                    Label(Tabs.Buy.rawValue, systemImage: KeweSymbols.shop)
                }
                .tag(Tabs.Buy)
        }
    }
}

#Preview {
    ContentView()    
        .modelContainer(previewContainer)
        .environmentObject(StateManager())

}
