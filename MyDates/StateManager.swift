//
//  StateMgr.swift
//  MyDates
//
//  Created by Jin on 8/30/23.
//

import Foundation

class StateManager: ObservableObject {
    @Published var selection: String? = nil {
        didSet {
            logger.info("selection: \(self.selection ?? "nil")")
        }
    }
    @Published var tab: ContentView.Tabs = .List
    
    func openItem(name: String) {
        tab = .List
        selection = name
    }
}
