//
//  Location.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 6/8/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import Foundation

class Location:EntityBase {
    init(name:String)   {
        super.init(name:name, entityTypeName:String(describing:type(of:self)))
    }
}
