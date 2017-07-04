//
//  BackgroundDataLoader.swift
//  CoreDataExample
//
//  Created by Patrick Sculley on 6/21/17.
//  Copyright © 2017 Nisum. All rights reserved.
//

import CoreData
import UIKit
import Foundation

class BackgroundDataCoordinator {
    
    func requestAndLoadEntities(objectType:String)    {
        let context:NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
        
        context.perform {
            let coreDataLoad:CoreDataLoad = CoreDataLoad(context: context)
            let urlDataService:URLDataService = URLDataService()
            urlDataService.doURLRequest(objectType: objectType, responseHandler:{
                (array:[Any]?) -> Void in
                    if (array != nil)   {
                        for object in array! {
                            if let jsonDictionary = object as? Dictionary<String, Any> {
                                for (key, value) in jsonDictionary {
                                    print("got \(key): \(value)")
                                }
                                
                                let item = coreDataLoad.loadItem(fromJSON: jsonDictionary)
                                print("Loaded item: \(item.name)")
                            }
                        }
                    }
            })
        }
    }
    
}
