//
//  ContentView.swift
//  MyDates
//
//  Created by Jin on 8/22/23.
//

import SwiftUI
import SwiftData
import KeweApp

enum Tabs: String {
    case List, About, Buy, Wishlist
    //TODO: https://www.swiftbysundell.com/articles/avoiding-anyview-in-swiftui/
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .List:
            ListView()
        case .About:
            AboutView()
        case .Buy:
            MyStoreView()
        case .Wishlist:
            WishKitView()
        }
    }
}

struct ContentView: View {
    var tab = Tabs.List
    @EnvironmentObject var stateManager: StateManager

    var body: some View {
        TabView () { // selection: $stateManager.tab
            ForEach(Config.shared.tabList) { tab in
                if let view = Tabs(rawValue: tab.id)?.view() {
                    view
                        .tabItem {
                            Label(tab.label, systemImage: tab.systemImage)
                        }
                        .tag(tab.id)
                }
            }
            
//            Tabs.List.view()
//                .tabItem {
//                    Label(Tabs.List.rawValue, systemImage: KeweSymbols.list)
//                }
//                .tag(Tabs.List)
//            
//            Tabs.About.view()
//                .tabItem {
//                    Label(Tabs.About.rawValue, systemImage: KeweSymbols.setting)
//                }
//                .tag(Tabs.About)
//
//            Tabs.Buy.view()
//                .tabItem {
//                    Label(Tabs.Buy.rawValue, systemImage: KeweSymbols.shop)
//                }
//                .tag(Tabs.Buy)
        }
    }
}

#Preview {
    ContentView()    
        .modelContainer(previewContainer)
        .environmentObject(StateManager())

}
