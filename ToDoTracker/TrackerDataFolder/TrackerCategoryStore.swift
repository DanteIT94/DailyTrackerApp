//
//  TrackerCategoryStore.swift
//  ToDoTracker
//
//  Created by Денис on 16.07.2023.
//

import Foundation
import CoreData

enum TrackerCategoryStoreError: Error {
    case noTrackerInTrackerCategory
    case decodingError
    case fetchError
}

struct TrackerCategoryStoreUpdate {
    struct IndexUpdating: Hashable {
        let oldIndex: IndexPath
        let newIndex: IndexPath
    }
    let insertedIndexes: IndexPath
    
    
}


final class TrackerCategoryStore: NSObject {
    
}
