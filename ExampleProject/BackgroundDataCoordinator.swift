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
    
    func requestAndLoadEntities(entityType:EntityType, completionHandler:((Bool)->Void)?)     {
        let context:NSManagedObjectContext = CoreDataFetch.persistentContainer.newBackgroundContext()
        context.perform {
            let coreDataLoad:CoreDataLoad = CoreDataLoad(context: context)
            let urlDataService:URLDataService = URLDataService()
            urlDataService.doURLRequest(objectType: EntityBase.entityTypeToString(entityType: entityType)) {
                (array:[Any]?) -> Void in
                if (array != nil)   {
                    for object in array! {
                        if let jsonDictionary = object as? Dictionary<String, Any> {
                            let item = coreDataLoad.loadItem(fromJSON: jsonDictionary)
                            print("Loaded item: \(item.name)")
                        }
                    }
                    completionHandler?(true)
                } else {
                    completionHandler?(false)
                }
            }
        }
    }
}
