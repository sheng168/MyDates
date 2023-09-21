//
//  MyDatesTests.swift
//  MyDatesTests
//
//  Created by Jin on 8/22/23.
//

import XCTest
@testable import MyDates

final class MyDatesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let fmt = ISO8601DateFormatter()

        let date1 = fmt.date(from: "2017-08-06T19:20:42+0000")!
        let date2 = fmt.date(from: "2020-08-06T19:20:46+0000")!

        let diffs = Calendar.current.dateComponents([.year, .month, .day], from: date1, to: date2)
        print(diffs)
    }

    func testJson() throws {
        var empty = """
        {
          "tabList" : [
            {
              "systemImage" : "list.bullet",
              "enable" : true,
              "id" : "List",
              "label" : "List"
            },
            {
              "label" : "About",
              "systemImage" : "gear",
              "id" : "About",
              "enable" : true
            },
            {
              "enable" : true,
              "systemImage" : "cart",
              "id" : "Buy",
              "label" : "Buy"
            }
          ],
          "about" : [
            {
              "detail" : "I built this app to replace one that I've been using. I felt that $10 per year to remove baner ads and access premium features was too much for such as simple app.\n\nWhile my app is currently free, I plan to charge $1 per year so that it can be maintained and enhanced.",
              "id" : "About"
            },
            {
              "id" : "Features",
              "detail" : "- Save list of name and date\n- Quickly see family members' age\n- Calculate year, month, day, hour, minute, seconds\n- Count down to future days\n- Backup and sync to all your iPhone/iPads using your apple ID"
            },
            {
              "detail" : "- Set image or icon with each entry\n- Organize entries into groups\n- Display preferences",
              "id" : "Todos"
            }
          ]
        }
        """
        empty = Config.shared.toJsonString()!
        let cfg = Config.fromJsonString(empty)

        
        guard let cfg else { XCTFail(); return }
        
        guard let json = cfg.toJsonString() else { XCTFail(); return }
        
        XCTAssertEqual(empty, json)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
