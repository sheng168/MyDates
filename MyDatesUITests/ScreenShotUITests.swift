//
//  ScreenShotUITests.swift
//  MyDatesUITests
//
//  Created by Jin on 10/7/23.
//

import XCTest

final class ScreenShotUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        // UI tests must launch the application that they test.
        setupSnapshot(app)
        
        app.launchArguments = ["enable-testing"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let tabBar = app.tabBars["Tab Bar"]

//        snapshot("01LaunchScreen")

        tabBar.buttons["List"].tap()
        snapshot("0List")

        tabBar.buttons["Wishlist"].tap()
        snapshot("1Wishlist")

        tabBar.buttons["Buy"].tap()
        snapshot("2Buy")

        tabBar.buttons["About"].tap()
        snapshot("3About")
        
    }
    
//    func testExample2() throws {
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        snapshot("02LaunchScreen")
//    }
}
