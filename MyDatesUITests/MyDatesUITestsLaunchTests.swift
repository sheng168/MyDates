//
//  MyDatesUITestsLaunchTests.swift
//  MyDatesUITests
//
//  Created by Jin on 8/22/23.
//

import XCTest
//@testable import MyDates

final class MyDatesUITestsLaunchTests: XCTestCase {
    let app = XCUIApplication()

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments = ["MyDatesApp.testArg"]
        app.launch()
    }

    func testLaunch() throws {
        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
        
        
//        let app = XCUIApplication()
//        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Add Item"].tap()
//        app.collectionViews["Sidebar"].staticTexts["New Event"].tap()
//        
//        let attachment2 = XCTAttachment(screenshot: app.screenshot())
//        attachment2.name = "Edit Screen"
//        attachment2.lifetime = .keepAlways
//        add(attachment2)
    }
    
    func _testCreateDelete() {
        app.navigationBars.element.buttons["Add Item"].tap()

        let sidebarCollectionView = app.collectionViews["Sidebar"]
        sidebarCollectionView.staticTexts["New Event"].tap()
        
        let navigationBar = app.navigationBars.element
        
        attachScreenshot(name: "Edit Screen")
 
        navigationBar.buttons["Back"].tap()
        navigationBar/*@START_MENU_TOKEN@*/.buttons["Edit"]/*[[".otherElements[\"Edit\"].buttons[\"Edit\"]",".buttons[\"Edit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        // leading red cirle
        sidebarCollectionView.children(matching: .cell).element(boundBy: 4).otherElements.containing(.image, identifier:"remove").element.tap()
        
        attachScreenshot(name: "Delete from list")

        sidebarCollectionView.buttons["Delete"].tap()
        navigationBar/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".otherElements[\"Done\"].buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

    }
    
    func attachScreenshot(name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func _testCRUD() {
        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Add Item"].tap()

        let sidebarCollectionView = app.collectionViews["Sidebar"]
        sidebarCollectionView.staticTexts["New Event"].tap()
        
        let ttgc7swiftui32navigationstackhostingNavigationBar = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]
        
        let attachment2 = XCTAttachment(screenshot: app.screenshot())
        attachment2.name = "Edit Screen"
        attachment2.lifetime = .keepAlways
        add(attachment2)
 
        ttgc7swiftui32navigationstackhostingNavigationBar.buttons["Back"].tap()
        ttgc7swiftui32navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["Edit"]/*[[".otherElements[\"Edit\"].buttons[\"Edit\"]",".buttons[\"Edit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sidebarCollectionView.children(matching: .cell).element(boundBy: 4).otherElements.containing(.image, identifier:"remove").element.tap()
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Delete from list"
        attachment.lifetime = .keepAlways
        add(attachment)

        sidebarCollectionView.buttons["Delete"].tap()
        ttgc7swiftui32navigationstackhostingNavigationBar/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".otherElements[\"Done\"].buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
    }
}
