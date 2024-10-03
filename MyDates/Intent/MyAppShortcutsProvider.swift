//
//  MyAppShortCustsProvider.swift
//  TesWatch
//
//  Created by Jin on 1/27/24.
//

import AppIntents

struct MyAppShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: NewItemIntent(),
            phrases: ["create new item with \(.applicationName)"],
            shortTitle: "New item (st)",
            systemImageName: "plus")
    }
}
