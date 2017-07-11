//
//  UserPreferencesUtil.swift
//  ExampleProject
//
//  Created by Patrick Sculley on 7/10/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import Foundation

enum Preference {
    case Username
    case AccountId
}

class UserPreferencesUtil    {
    
    static func set(_ preference:Preference, withValue:String)   {
        UserDefaults.standard.setValue(withValue, forKey: String(describing:preference))
    }
    
    static func get(_ preference:Preference) -> String?  {
        return UserDefaults.standard.string(forKey: String(describing:preference))
    }
    
    static func setInt(_ preference:Preference, withValue:Int)   {
        UserDefaults.standard.setValue(withValue, forKey: String(describing:preference))
    }
    
    static func getInt(_ preference:Preference) -> Int  {
        return UserDefaults.standard.integer(forKey: String(describing:preference))
    }
    
    static func setBool(_ preference:Preference, withValue:Bool)   {
        UserDefaults.standard.setValue(withValue, forKey: String(describing:preference))
    }
    
    static func getBool(_ preference:Preference) -> Bool  {
        return UserDefaults.standard.bool(forKey: String(describing:preference))
    }
    
}
