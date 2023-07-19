//
//  TrackerDataController.swift
//  ToDoTracker
//
//  Created by Денис on 17.07.2023.
//

import Foundation
import CoreData

protocol TrackerDataControllerProtocol: AnyObject {
    
}

protocol TrackerDataControllerDelegate: AnyObject {
    
}

final class TrackerDataController: NSObject {
    let trackerCategoryStore: TrackerCategoryStoreProtocol
    let trackerStore: TrackerStoreProtocol
    let trackerRecordStore: TrackerRecordStoreProtocol
    private var context: NSManagedObjectContext
    
    var fetchResultController: NSFetchedResultsController<TrackerCoreData>?
    
    //Блок индексов
    let insertedIndexes: [IndexSet]?
    let updatedIndexes: [IndexSet]?
    let deletedIndexes: [IndexSet]?
    let movedIndexes: [TrackerCategoryStoreUpdate.IndexMoving]
    
    weak var delegate: TrackerDataControllerDelegate?
    
    init(trackerCategoryStore: TrackerCategoryStore, trackerStore: TrackerStore, trackerRecordStore: TrackerRecordStore, context: NSManagedObjectContext) {
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerStore = trackerStore
        self.trackerRecordStore = trackerRecordStore
        self.context = context
        
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        controller.delegate = self
        
        self.fetchResultController = controller
        try? controller.performFetch()
        
    }
    
    
}

extension TrackerDataController: NSFetchedResultsControllerDelegate {
    
}
