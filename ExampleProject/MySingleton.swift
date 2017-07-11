//
//  MySingleton.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 7/10/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import Foundation

class MySingleton {
    
    static let getInstance = MySingleton()
    
    func saySomething() -> String   {
        return "Something"
    }
}

