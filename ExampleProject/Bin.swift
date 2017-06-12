//
//  Bin.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 6/8/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import Foundation

class Bin:EntityBase {
    var location:Location?
    
    convenience init(name:String, location:Location)   {
        self.init(name:name)
        self.location = location
    }
    
    init(name:String)   {
        super.init(name:name, entityTypeName:String(describing:type(of:self)))
    }
}
