//
//  CoreDataLoadObserver
//  ExampleProject
//
//  Created by Patrick Sculley on 7/10/17.
//  Copyright © 2017 PixelFlow. All rights reserved.
//

import Foundation

protocol CoreDataLoadObserver: class {
    
    func coreDataUpdated(entityType:EntityType, id:Int) -> Void
    
    func coreDataUpdateObserved(_ notification:NSNotification) -> Void

}
