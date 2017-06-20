//
//  CoreDataExtension.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 6/19/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import Foundation


enum EntityType {
    case Bin
    case Item
    case Location
}


extension EntityBase    {
    
    var entityType:EntityType?   {
        get {
            return EntityBase.entityTypeFromString(value: entityTypeValue!)
        }
        set {
            self.entityTypeValue = String(describing:newValue!)
        }
    }
    
    static func entityTypeFromString(value:String) -> EntityType?    {
        switch value {
        case String(describing:EntityType.Bin) : return EntityType.Bin
        case String(describing:EntityType.Item) : return EntityType.Item
        case String(describing:EntityType.Location) : return EntityType.Location
        default: return nil
        }
    }

}
