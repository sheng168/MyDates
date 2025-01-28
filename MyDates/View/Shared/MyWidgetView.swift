//
//  MyWidgetView.swift
//  MyDates
//
//  Created by Jin on 1/28/25.
//

import SwiftUI

struct MyWidgetView: View {
    var date = Date()
    var name: String = "Hello, World!"

    var body: some View {
        
        LabeledContent {
            EmptyView()
        } label: {
            
//            ForEach(items) { item in
//                Text(item.name)
//            }
//
            Text(date, style: .relative) // 2 units
//            Text(date, style: .offset) // +/- 1 unit

            Text(name)
            
            Text("")
            Text(date, style: .date)
            Text(date, style: .time)
//            if showDebug {
//                Text(date, style: .timer)
//            }
//            Text("")
//            Text("Date Radar")
        }

    }
}

#Preview {
    MyWidgetView(date: Date(), name: "Alex")
}
