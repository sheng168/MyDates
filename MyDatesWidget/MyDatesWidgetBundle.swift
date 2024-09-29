//
//  MyDatesWidgetBundle.swift
//  MyDatesWidget
//
//  Created by Jin on 1/30/24.
//

import WidgetKit
import SwiftUI
//import FirebaseCore
import KeweApp

@main
struct MyDatesWidgetBundle: WidgetBundle {
    init() {
        print("MyDatesWidgetBundle.init")
//        FirebaseApp.configure()
        FirebaseInit.config()
    }
    var body: some Widget {
        MyDatesWidget()
    }
}
