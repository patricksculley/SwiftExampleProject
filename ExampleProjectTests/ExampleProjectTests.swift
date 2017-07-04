//
//  ExampleProjectTests.swift
//  ExampleProjectTests
//
//  Created by Patrick Sculley on 6/4/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import XCTest
@testable import ExampleProject

class ExampleProjectTests: XCTestCase {
    
    let coreDataFetch = CoreDataFetch()

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testCoreDataFetchEntity()  {
        //Test happy path:
        let testId = 1
        var item:Item? = coreDataFetch.fetchEntity(byId: NSNumber.init(value: testId))
        XCTAssert(Int(item!.id)  == testId)
        //Test no object path:
        item = coreDataFetch.fetchEntity(byId: NSNumber.init(value: 123))
        XCTAssertNil(item)
        //Test error path:
        let entityBase:EntityBase? = coreDataFetch.fetchEntity(byId: NSNumber.init(value: 123))
        XCTAssertNil(entityBase)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
