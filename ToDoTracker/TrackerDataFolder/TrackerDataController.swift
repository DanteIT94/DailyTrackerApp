//
//  TrackerDataController.swift
//  ToDoTracker
//
//  Created by Денис on 17.07.2023.
//

import Foundation
import CoreData

protocol TrackerDataControllerProtocol: AnyObject {
    func addTrackerCategoryToCoreData(_ trackerCategory: TrackerCategory) throws
    func fetchTrackerCategoriesFor(weekday: Int, animated: Bool)
    func fetchSearchedCategories(textForSearching: String, weekday:Int)
    
    func fetchRecordsCountForId(_ id: UUID) -> Int
    func checkTrackerRecordExists(id: UUID, date: String) -> Bool
    func addTrackerRecord(id: UUID, date: String)
    func deleteTrackerRecord(id: UUID, date: String)
    
    var trackerCategories: [TrackerCategory] { get }
    var delegate: TrackerDataControllerDelegate? { get set }
    
}

protocol TrackerDataControllerDelegate: AnyObject {
    func updateView(trackerCategories: [TrackerCategory], animated: Bool)
    func updateViewWithController(_ update: TrackerCategoryStoreUpdate)
}

final class TrackerDataController: NSObject {
    let trackerCategoryStore: TrackerCategoryStoreProtocol
    let trackerStore: TrackerStoreProtocol
    let trackerRecordStore: TrackerRecordStoreProtocol
    private var context: NSManagedObjectContext
    
    var fetchResultController: NSFetchedResultsController<TrackerCoreData>?
    
    //Блок индексов
    private var insertedIndexes: [IndexPath]?
    private var updatedIndexes: [IndexPath]?
    private var deletedIndexes: [IndexPath]?
    private var movedIndexes: [TrackerCategoryStoreUpdate.IndexMoving]?
    
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

extension TrackerDataController: TrackerDataControllerProtocol {
    func addTrackerCategoryToCoreData(_ trackerCategory: TrackerCategory) throws {
        try trackerCategoryStore.addTrackerCategoryToCoreData(trackerCategory)
    }
    
    func fetchTrackerCategoriesFor(weekday: Int, animated: Bool) {
        let predicate = NSPredicate(format: "ANY %K.%K == %ld", #keyPath(TrackerCoreData.schedule), #keyPath(ScheduleCoreData.weekday), weekday)
        var trackerCategories = trackerCategoryStore.fetchTrackerCategoryWithPredicates(predicate)
        delegate?.updateView(trackerCategories: trackerCategories, animated: animated)
    }
    
    func fetchSearchedCategories(textForSearching: String, weekday: Int) {
        let weekdayPredicate = NSPredicate(format: "Any %K.%K == %ld", #keyPath(TrackerCoreData.schedule), #keyPath(ScheduleCoreData.weekday), weekday)
        let textForSearchingPredicate = NSPredicate(format: "%K Contains[cd] %@", #keyPath(TrackerCoreData.name), textForSearching)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [weekdayPredicate, textForSearchingPredicate])
        let trackerCategories = trackerCategoryStore.fetchTrackerCategoryWithPredicates(compoundPredicate)
//        trackerCategories.sort(by: {$1.headerName > $0.headerName})
        delegate?.updateView(trackerCategories: trackerCategories, animated: true)
        
    }
    
    func fetchRecordsCountForId(_ id: UUID) -> Int {
        trackerRecordStore.fetchTrackerRecordCount(id: id)
    }
    
    func checkTrackerRecordExists(id: UUID, date: String) -> Bool {
        trackerRecordStore.checkIfTrackerRecordExisted(id: id, date: date)
    }
    
    func addTrackerRecord(id: UUID, date: String) {
        trackerRecordStore.addTrackerRecordToCoreData(id: id, date: date)
    }
    
    func deleteTrackerRecord(id: UUID, date: String) {
        trackerRecordStore.deleteTrackerRecord(id: id, date: date)
    }
    
    var trackerCategories: [TrackerCategory] {
        guard let trackerObjects = self.fetchResultController?.fetchedObjects else { return [] }
        let trackerCategories = trackerCategoryStore.convertTrackersCoreDataToTrackerCategory(trackerObjects)
        return trackerCategories
    }
}

extension TrackerDataController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Начало процесса обновления данных, инициализация массивов для отслеживания изменений.
        insertedIndexes = []
        deletedIndexes = []
        updatedIndexes = []
        movedIndexes = []
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Конец процесса обновления данных, все изменения уже отслежены.

        // Создание объекта с информацией об обновлении данных.
        guard let insertedIndexes, let deletedIndexes, let updatedIndexes, let movedIndexes else { return }
        let update = TrackerCategoryStoreUpdate(
            insertedIndexes: insertedIndexes,
            deletedIndexes: deletedIndexes,
            updatedIndexes: updatedIndexes,
            movedIndexes: movedIndexes)
        // Посылка обновления представлению пользовательского интерфейса через делегата.
            delegate?.updateViewWithController(update)
        
        // Сброс массивов, так как процесс обновления данных завершен.
        self.insertedIndexes = nil
        self.deletedIndexes = nil
        self.updatedIndexes = nil
        self.movedIndexes = nil
    }
}
