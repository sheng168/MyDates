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
    @Published var tab: Tabs = .List {
        didSet {
            logger.info("tab: \(self.tab.rawValue)")
        }
    }
    
    func openItem(name: String) {
        tab = .List
        selection = name
    }
}
