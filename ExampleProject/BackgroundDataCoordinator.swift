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
    
    var coreDataLoadObservers = [CoreDataLoadObserver]()
    let CoreDataLoadNotificationName = "CoreDataLoadNotification"

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
                            
                            self.dispatchLoadObserverEvent(entityType: item.entityType!, id: Int(item.id))
                            self.dispatchLoadObserverNotification(entityType: item.entityType!, id: Int(item.id))
                        }
                    }
                    completionHandler?(true)
                } else {
                    completionHandler?(false)
                }
            }
        }
    }
    
    func addCoreDataLoadObserver(observer:CoreDataLoadObserver) {
        if !coreDataLoadObservers.contains{ $0 === observer } {
            coreDataLoadObservers.append(observer)
        }
    }
    
    func removeCoreDataLoadObserver(observer:CoreDataLoadObserver) {
        if !coreDataLoadObservers.contains{ $0 === observer } {
            coreDataLoadObservers.remove(at:
                coreDataLoadObservers.index(where: {
                    (item) -> Bool in item === observer
                })!)
        }
    }
    
    func dispatchLoadObserverEvent(entityType:EntityType, id:Int) {
        for observer in coreDataLoadObservers {
            observer.coreDataUpdated(entityType:entityType, id:id)
        }
    }
    
    func addCoreDataLoadNotificationObserver(observer:CoreDataLoadObserver) {
        NotificationCenter.default.addObserver(
            observer,
//            #selector(coreDataUpdated(notification:)),
            selector: Selector("coreDataUpdateObserved:"),
            name: Notification.Name(CoreDataLoadNotificationName),
            object: self)
    }
    
    func removeCoreDataNotificationObserver(observer:CoreDataLoadObserver) {
        NotificationCenter.default.removeObserver(observer, name: Notification.Name(CoreDataLoadNotificationName), object: self)
        
    }
    
    func dispatchLoadObserverNotification(entityType:EntityType, id:Int) {
        let userInfo = ["entityType": String(describing:entityType),
                        "id": "\(id)"]
        NotificationCenter.default.post(name: Notification.Name(CoreDataLoadNotificationName), object: self, userInfo: userInfo)
    }

}
