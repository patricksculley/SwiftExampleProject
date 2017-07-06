//
//  ExampleProjectSearchTests.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 7/5/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import XCTest

class ExampleProjectSearchTests: XCTestCase {
    
    let app = XCUIApplication()
    
    let itemName = "Item 1"

    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchAllItems()   {
        print(app.debugDescription)
        app.navigationBars["Create Item"].buttons["Search"].tap()
        XCTAssert(app.tables.cells.containing(.staticText, identifier:"Item: \(itemName)").element.exists)
        app.navigationBars["Item Search"].buttons["Cancel"].tap()
        XCTAssert(app.navigationBars["Create Item"].exists)
    }
    
    func testTableRefresh() {
        app.navigationBars["Create Item"].buttons["Search"].tap()
        let firstCell = app.tables.cells.element(boundBy: 0)
        let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx:0, dy:0))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx:0, dy:6))
        for _ in 0..<3 {
            start.press(forDuration: 0, thenDragTo: finish)
        }
        XCTAssert(app.tables.cells.containing(.staticText, identifier:"Item: \(itemName)").element.exists)
    }
    
    func testSearchFiltering()  {
        app.navigationBars["Create Item"].buttons["Search"].tap()
        app.tables.searchFields["Search"].tap()
        app.buttons["Item"].tap()
        app.searchFields["Search"].typeText(itemName)
        XCTAssert(app.tables.cells.containing(.staticText, identifier:"Item: \(itemName)").element.exists)

    }
    
}
