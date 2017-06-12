//
//  Item.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 6/8/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import Foundation

class Item:EntityBase {
    var bin:Bin?
    
    convenience init(name:String, bin:Bin)   {
        self.init(name:name)
        self.bin = bin
    }
    
    init(name:String)   {
        super.init(name:name, entityTypeName:String(describing:type(of:self)))
    }
}
