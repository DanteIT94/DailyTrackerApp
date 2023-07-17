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

class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
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
    
}

extension TrackerStore: TrackerStoreProtocol {
    func convertTrackerToCoreData(_ tracker: Tracker) -> TrackerCoreData {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.color = tracker.color.hexString()
        trackerCoreData.name = tracker.name
        trackerCoreData.id = tracker.id
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = convertScheduleToScheduleCoreData(tracker.schedule)
        return trackerCoreData
    }
    
    func convertCoreDataToTracker(_ entity: TrackerCoreData) throws -> Tracker {
        guard let id = entity.id,
              let name = entity.name,
              let colorString = entity.color,
              let emoji = entity.emoji,
              let scheduleSet = entity.schedule else {
            throw TrackerStoreError.decodingError
        }
        let schedule = convertScheduleCoreDataToSchedule(scheduleSet)
        let tracker = Tracker(
            id: id,
            name: name,
            color: UIColor().color(from: colorString),
            emoji: emoji,
            schedule: schedule
        )
    return tracker
    }
}
