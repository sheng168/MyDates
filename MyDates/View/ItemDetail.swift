//
//  ItemDetail.swift
//  MyDates
//
//  Created by Jin on 8/23/23.
//

import SwiftUI
import os

struct ItemDetail: View {
    @Bindable var item: Item
    
    var body: some View {
        Form {
            TextField("Name", text: $item.name)
            DatePicker(selection: $item.timestamp, displayedComponents: [.date, .hourAndMinute]) {
                Text("Select a date")
            }
//            .datePickerStyle(.graphical)
            Text(diffs(item.timestamp, .now).description)
        }
    }
    
}

func diffs(_ date: Date, _ date2: Date) -> DateComponents {
//    let fmt = ISO8601DateFormatter()

//    let date1 = fmt.date(from: "2017-08-06T19:20:42+0000")!
//    let date2 = fmt.date(from: "2020-08-06T19:20:46+0000")!
    

    let calComp: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
    
    var diffs = Calendar.current.dateComponents(calComp, from: date, to: date2)
    logger.warning("\(diffs)")
    
    if diffs.year == 0 {
        diffs.year = nil
        
        if diffs.month == 0 {
            diffs.month = nil
        }
    } else {
        diffs.second = nil
        diffs.minute = nil
    }
    

    return diffs
}

#Preview {
    ModelPreview { item in
        ItemDetail(item: item)
            .modelContainer(previewContainer)
    }
//    Text("TODO")
}
