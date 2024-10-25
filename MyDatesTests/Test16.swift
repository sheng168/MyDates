//
//  Test16.swift
//  MyDatesTests
//
//  Created by Jin on 10/19/24.
//

import Testing
import Foundation

struct Test16 {

    @Test func fail() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        #expect(5 == 1+2+3)
        
        #expect(7 == 1+2+3)
    }

    @Test func date() async throws {
        // the date you want to format
        let exampleDate = Date.now.addingTimeInterval(-15000)

        // ask for the full relative date
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full

        // get exampleDate relative to the current date
        let relativeDate = formatter.localizedString(for: exampleDate, relativeTo: Date.now)

        // print it out
        print("Relative date is: \(relativeDate)")
        
        #expect(relativeDate == "4 hours ago")
        
        let relativeDate2 = formatter.localizedString(for: exampleDate, relativeTo: exampleDate.addingTimeInterval(75))
        #expect(relativeDate2 == "1 minute ago")
        
        let comp: DateComponents = DateComponents(day: 3, hour: 13)
        let relativeDate3 = formatter.localizedString(from: comp)
        #expect(relativeDate3 == "")
        
        
        #expect(comp.description == "")
    }
}
