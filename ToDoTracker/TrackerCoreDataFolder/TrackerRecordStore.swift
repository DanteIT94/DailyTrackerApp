//
//  TrackerRecordStore.swift
//  ToDoTracker
//
//  Created by Денис on 16.07.2023.
//

import Foundation
import CoreData


protocol TrackerRecordStoreProtocol: AnyObject {
    func addTrackerRecordToCoreData(id: UUID, date: String)
    func deleteTrackerRecord(id: UUID, date: String)
    func checkIfTrackerRecordExisted(id: UUID, date: String) -> Bool
    func fetchTrackerRecordCount(id: UUID) -> Int
    func calculateCompletedTrackers() -> Int
}

final class TrackerRecordStore: NSObject {
    let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension TrackerRecordStore: TrackerRecordStoreProtocol {
    func addTrackerRecordToCoreData(id: UUID, date: String) {
        let newTrackerRecord = TrackerRecordCoreData(context: context)
        newTrackerRecord.trackerID = id
        newTrackerRecord.date = date
        do {
            try context.save()
        } catch {
            print("Can't save TrackerRecord \(error)")
        }
    }
    
    func deleteTrackerRecord(id: UUID, date: String) {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        let predicateID = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerRecordCoreData.trackerID), id.uuidString)
        
        let predicateDate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerRecordCoreData.date), date)
        
        ///Объединяем предикаты через NSCompoundPredicate
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateID, predicateDate])
        
        do {
            if let trackerRecord = try context.fetch(fetchRequest).first {
                context.delete(trackerRecord)
                try context.save()
            }
        } catch {
            print("Can't delete TrackerRecord (probably notFound)")
        }
    }
    
    func fetchTrackerRecordCount(id: UUID) -> Int {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerRecordCoreData.trackerID), id.uuidString)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print("There is no Trackers - \(error)")
            return 0
        }
    }

    func checkIfTrackerRecordExisted(id: UUID, date: String) -> Bool {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        let predicateID = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerRecordCoreData.trackerID), id.uuidString)
        
        let predicateDate = NSPredicate(
            format: "%K == %@",
            #keyPath(TrackerRecordCoreData.date), date)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateID, predicateDate])
        
        do {
            let trackerCount = try context.count(for: fetchRequest)
            if trackerCount > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print("Exacly tracker doesn't exisists - \(error)")
            return false
        }
    }
    
    func calculateCompletedTrackers() -> Int {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        do {
            let allCompletedTrackers = try context.fetch(fetchRequest)
            return allCompletedTrackers.count
        } catch {
            assertionFailure("Failed to fetch all completed trackers data: \(error)")
            return 0
        }
    }
}


