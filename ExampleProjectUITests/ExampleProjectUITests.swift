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
    
    let testItemName = "Test item"
    let testLocationName = "My test location"
    let testBinName = "My test bin"

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
    
    func testCreateLocation()    {
        createLocation(locationName: testLocationName)
        createLocation(locationName: "Another Location")
    }
    
    func createLocation(locationName:String)    {
        app.buttons["Add Location Button"].tap()
        let alert = app.alerts["Create Location"]
        let binTextField = alert.textFields["Location Name Input"]
        binTextField.typeText(locationName)
        alert.buttons["OK"].tap()
        XCTAssert(app.textFields["Location Input"].value as! String == locationName)
    }
    
    func testCreateBin()    {
        createBin(binName: testBinName)
        createBin(binName: "Another Bin")
    }
    
    func createBin(binName:String)    {
        app.buttons["Add Bin Button"].tap()
        let alert = app.alerts["Create Bin"]
        let binTextField = alert.textFields["Bin Name Input"]
        binTextField.typeText(binName)
        alert.buttons["OK"].tap()
        XCTAssert(app.textFields["Bin Input"].value as! String == binName)
    }
    
    func testCreateItem() {
        print(app.debugDescription)
        let itemTextField = app.textFields["Item Name Input"]
        itemTextField.tap()
        itemTextField.typeText(testItemName)
        
        let qtyTextField = app.textFields["Item Quantity Input"]
        qtyTextField.tap()
        qtyTextField.typeText("13")
        selectLocation()
        selectBin()
        app.buttons["Save Button"].tap()
        XCTAssert((itemTextField.value as! String).isEmpty)
    }
    
    func selectLocation()   {
        let textField = app.textFields["Location Input"]
        textField.tap()
        app.pickerWheels.element.adjust(toPickerWheelValue: testLocationName)
        waitForElementValueToUpdate(element: textField, expectedValue: testLocationName)
        XCTAssert(app.textFields["Location Input"].value as! String == testLocationName)
    }
    
    func selectBin()   {
        let textField = app.textFields["Bin Input"]
        textField.tap()
        app.pickerWheels.element.adjust(toPickerWheelValue: testBinName)
        waitForElementValueToUpdate(element: textField, expectedValue: testBinName)
        XCTAssert(app.textFields["Bin Input"].value as! String == testBinName)
    }
    
    func waitForElementToAppear(_ element: XCUIElement) {
        let predicate = NSPredicate(format: "exists == true")
        let _ = expectation(for: predicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 1)
    }
    
    func waitForElementToDisappear(_ element: XCUIElement) {
        let predicate = NSPredicate(format: "exists == false")
        let _ = expectation(for: predicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 1)
    }
    
    func waitForElementValueToUpdate(element: XCUIElement, expectedValue: String) {
        let predicate = NSPredicate(format: "value == %@", expectedValue)
        let _ = expectation(for: predicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 1)
    }
}
