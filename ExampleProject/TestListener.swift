//
//  TestListener.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 7/10/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import Foundation

class TestListener: CoreDataLoadObserver    {
    
    var updated = false
    var name = "None"
    
    init(_ name:String) {
        self.name = name
    }
    
    func coreDataUpdated(entityType:EntityType, id:Int) -> Void {
        print("\(name) coreDataUpdated received: \(entityType) \(id)")
    }
    
    @objc func coreDataUpdateObserved(_ notification:NSNotification) -> Void   {
        let userInfo = notification.userInfo
        print("\(name) coreDataUpdateObserved received notification: \(userInfo?["entityType"]) \(userInfo?["id"])")
        updated = true

    }
}
