//
//  TrackerStore .swift
//  ToDoTracker
//
//  Created by Денис on 16.07.2023.
//

import Foundation
import CoreData

protocol TrackerStoreProtocol: AnyObject {
    func addTracker()
}

class TrackerStore: NSObject {
    
}

extension TrackerStore: TrackerStoreProtocol {
    func addTracker() {
        
    }
}
