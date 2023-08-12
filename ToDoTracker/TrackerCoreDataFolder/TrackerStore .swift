//
//  TrackerStore .swift
//  ToDoTracker
//
//  Created by Денис on 16.07.2023.
//

import CoreData
import UIKit

enum TrackerStoreError: Error {
    case decodingError
    case fetchError
}

protocol TrackerStoreProtocol: AnyObject {
    func convertCoreDataToTracker(_ entity: TrackerCoreData) throws -> Tracker
    func convertTrackerToCoreData(_ tracker: Tracker) -> TrackerCoreData
}

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?

    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // Initialize and return fetchedResultsController
    func fetchedResultsControllerForTracker() -> NSFetchedResultsController<TrackerCoreData> {
        if let fetchedResultsController = fetchedResultsController {
            return fetchedResultsController
        } else {
//            setupFetchedResultsController()
            guard let fetchedResultsController = fetchedResultsController else {
                assertionFailure("Failed to initialize fetchedResultsController")
                return .init()
            }
            return fetchedResultsController
        }
    }
    
    //Функция для чтения трекера по ID в EditingVC
    func readTracker(by id: UUID) throws -> Tracker {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let coreDataTrackers = try context.fetch(request)
            guard let coreDataTracker = coreDataTrackers.first else { throw TrackerStoreError.decodingError }
            guard let tracker = try? convertCoreDataToTracker(coreDataTracker) else { throw TrackerStoreError.decodingError }
            return tracker
        } catch {
            throw TrackerStoreError.fetchError
        }
    }
    
    ///Конвертируем Расписание под CoreData
    private func convertScheduleToScheduleCoreData(_ weekday: [Int]) -> NSSet {
        var scheduleCoreDataSet: Set<ScheduleCoreData> = []
        for day in weekday {
            let scheduleCoreData = ScheduleCoreData(context: context)
            scheduleCoreData.weekday = Int32(day)
            scheduleCoreDataSet.insert(scheduleCoreData)
        }
        return NSSet(set: scheduleCoreDataSet)
    }
    
    ///Конвертируем данные CoreData по массив дней
    private func convertScheduleCoreDataToSchedule(_ entity: NSSet) -> [Int] {
        var daysArray: [Int] = []
        for i in entity {
            guard let scheduleCoreData = i as? ScheduleCoreData else { return [] }
            let day = scheduleCoreData.weekday
            daysArray.append(Int(day))
        }
        return daysArray
    }
    
    //MARK: - CRUD Methods
    func updateTracker(_ updatedTracker: Tracker) throws {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", updatedTracker.id as CVarArg)
        guard let tracker = try context.fetch(request).first else {
            throw TrackerStoreError.fetchError
        }
        tracker.name = updatedTracker.name
        tracker.color = updatedTracker.color.hexString()
        tracker.emoji = updatedTracker.emoji
        tracker.isPinned = updatedTracker.isPinned
        tracker.schedule = convertScheduleToScheduleCoreData(updatedTracker.schedule)
        tracker.previousCategory = updatedTracker.previousCategory

        
        // Обновляем отношение категории
        let categoryRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        categoryRequest.predicate = NSPredicate(format: "headerName == %@", updatedTracker.category)
        if let category = try context.fetch(categoryRequest).first {
            tracker.trackerCategory = category
        } else {
            // Если категории с таким именем нет, создаем новую
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.headerName = updatedTracker.category
            tracker.trackerCategory = newCategory
        }
        
        try context.save()
    }
    
    func deleteTracker(_ deleteTracker: Tracker) throws {
        // Удаление связанных записей
        let recordsRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        recordsRequest.predicate = NSPredicate(format: "trackerID == %@", deleteTracker.id as CVarArg)

        let trackersToDelete = try? context.fetch(recordsRequest)
        trackersToDelete?.forEach { context.delete($0) }

        // Удаление самого трекера
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", deleteTracker.id as CVarArg)
        
        do {
            let trackersToDelete = try context.fetch(request)
            trackersToDelete.forEach { context.delete($0) }
            
            try context.save()
        } catch {
            print("Ошибка при удалении трекера и связанных записей: \(error)")
            throw error
        }
    }
    
    func fetchPreviousCategory(forTrackerWithID id: UUID) -> String? {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            guard let fetchedTrackerCoreData = try context.fetch(request).first else {
                print("Трекер с ID \(id) не найден")
                return nil
            }
            return fetchedTrackerCoreData.previousCategory
        } catch {
            print("Ошибка при извлечении previousCategory из CoreData")
            return nil
        }
    }

}

extension TrackerStore: TrackerStoreProtocol {
    func convertTrackerToCoreData(_ tracker: Tracker) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.color = tracker.color.hexString()
        trackerCoreData.name = tracker.name
        trackerCoreData.id = tracker.id
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = convertScheduleToScheduleCoreData(tracker.schedule)
        trackerCoreData.isEvent = tracker.isEvent
        return trackerCoreData
    }
    
    func convertCoreDataToTracker(_ entity: TrackerCoreData) throws -> Tracker {
        guard let id = entity.id,
              let name = entity.name,
              let colorString = entity.color,
              let emoji = entity.emoji,
              let scheduleSet = entity.schedule,
                let category = entity.trackerCategory?.headerName
              else {
            throw TrackerStoreError.decodingError
        }
        let isEvent = entity.isEvent
        let isPinned = entity.isPinned
        let schedule = convertScheduleCoreDataToSchedule(scheduleSet)
        let tracker = Tracker(
            id: id,
            name: name,
            color: .color(from: colorString),
            emoji: emoji,
            schedule: schedule,
            isEvent: isEvent,
            isPinned: isPinned,
            category: category
        )
    return tracker
    }
    

}
