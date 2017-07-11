//
//  UtilTests.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 7/10/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import XCTest
@testable import ExampleProject

class UtilTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStringPreference() {
        let username = "Patrick"
        UserPreferencesUtil.set(Preference.Username, withValue:username)
        XCTAssert(username == UserPreferencesUtil.get(Preference.Username))
    }
    
    func testSingleton()    {
        print("Say \(MySingleton.getInstance.saySomething())")
    }
    
    func testCoreDataLoadObserver() {
        
        let backgroundDataCoordinator = BackgroundDataCoordinator()
        let testListener:TestListener = TestListener("Listener 1")
        let testListener2:TestListener = TestListener("Listener 2")

//        backgroundDataCoordinator.addCoreDataLoadObserver(observer: testListener)
//        backgroundDataCoordinator.addCoreDataLoadObserver(observer: testListener2)

        backgroundDataCoordinator.addCoreDataLoadNotificationObserver(observer: testListener)
        backgroundDataCoordinator.addCoreDataLoadNotificationObserver(observer: testListener2)

        backgroundDataCoordinator.requestAndLoadEntities(entityType: EntityType.Item) {
            (success:Bool) in
            XCTAssert(success)
        }
        
        expectation(forNotification: backgroundDataCoordinator.CoreDataLoadNotificationName, object: backgroundDataCoordinator, handler: nil)
        
        waitForExpectations(timeout: 1) {
            error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }

    }
}
