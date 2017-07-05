//
//  ExampleProjectUITests.swift
//  ExampleProjectUITests
//
//  Created by Patrick Sculley on 6/4/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import XCTest

class ExampleProjectUITests: XCTestCase {
    
    let app = XCUIApplication()

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
    
    func testCreateItem() {
        print(app.debugDescription)
        let itemName = "Test item"
        let itemTextField = app.textFields["Item Name Input"]
        itemTextField.tap()
        itemTextField.typeText(itemName)
        
        let qtyTextField = app.textFields["Item Quantity Input"]
        qtyTextField.tap()
        qtyTextField.typeText("13")
        createLocation()
        createBin()
        app.buttons["Save Button"].tap()
        XCTAssert((itemTextField.value as! String).isEmpty)

    }
    
    func createLocation()    {
        let testName = "My test location"
        app.buttons["Add Location Button"].tap()
        let alert = app.alerts["Create Location"]
        let binTextField = alert.textFields["Location Name Input"]
        binTextField.typeText(testName)
        alert.buttons["OK"].tap()
        XCTAssert(app.textFields["Location Input"].value as! String == testName)
    }
    
    func createBin()    {
        let testName = "My test bin"
        app.buttons["Add Bin Button"].tap()
        let alert = app.alerts["Create Bin"]
        let binTextField = alert.textFields["Bin Name Input"]
        binTextField.typeText(testName)
        alert.buttons["OK"].tap()
        XCTAssert(app.textFields["Bin Input"].value as! String == testName)
    }

    
}
