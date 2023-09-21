//
//  ItemRowView.swift
//  MyDates
//
//  Created by Jin on 9/21/23.
//

import SwiftUI

struct ItemRowView: View {
    let item: Item
    let d: DateComponents
    
    let componentFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .short
//        f.allowedUnits = [.hour]
        f.allowsFractionalUnits = true
        return f
    }()
    
    var body: some View {
        LabeledContent {
            VStack {
                if let y = d.year, y != 0 {
                    Text(y, format: .number)
                    Text("Year")
                        .font(.footnote)
                } else if let m = d.month, m != 0 {
                    Text(m, format: .number)
                    Text("Month")
                        .font(.footnote)
                } else if let d = d.day {
                    Text(d, format: .number)
                    Text("Day")
                        .font(.footnote)
                }
            }
        } label: {
            Text(item.name)
            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
            Text(componentFormatter.string(from: d) ?? d.description).lineLimit(1)
        }
    }
}

#Preview {
    List {
        ItemRowView(item: Item(), d: DateComponents())
    }
}
