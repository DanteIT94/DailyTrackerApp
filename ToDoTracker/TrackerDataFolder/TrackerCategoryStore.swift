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
    struct IndexMoving: Hashable {
        let oldIndex: IndexPath
        let newIndex: IndexPath
    }
    let insertedIndexes: [IndexPath]
    let deletedIndexes: [IndexPath]
    let updatedIndexes: [IndexPath]
    let movedIndexes: [IndexMoving]
    
}

protocol TrackerCategoryStoreProtocol: AnyObject {
    ///Метод добавления категории и добавления в нее нового трекера
    func addTrackerCategoryToCoreData(_ trackerCategory: TrackerCategory) throws
    func convertTrackerCategoryCoreDataToTrackerCategory(_ objects: [TrackerCategoryCoreData]) throws -> [TrackerCategory]
    func convertTrackersCoreDataToTrackerCategory(_ trackersCoreData: [TrackerCoreData]) -> [TrackerCategory]
    func fetchTrackerCategoryWithPredicates(_ predicates: NSPredicate) -> [TrackerCategory]
    func setTrackerDataController(_ controller: NSFetchedResultsController<TrackerCoreData>?)
}


final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private let trackerDataStore: TrackerStoreProtocol
    private weak var trackerDataController: NSFetchedResultsController<TrackerCoreData>?
    
    init(context: NSManagedObjectContext, trackerDataStore: TrackerStoreProtocol) {
        self.context = context
        self.trackerDataStore = trackerDataStore
    }
}

extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    func addTrackerCategoryToCoreData(_ trackerCategory: TrackerCategory) throws {
        ///Проверяем наличие трекеров в нужной категории
        guard let tracker = trackerCategory.trackerArray.first else {
            throw TrackerCategoryStoreError.noTrackerInTrackerCategory
        }
        ///конверт трекера в Сущность CoreДаты
        let trackerCoreData = trackerDataStore.convertTrackerToCoreData(tracker)
        //запрос для получения категории трекеров из Core Data
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.headerName), trackerCategory.headerName)
        
        do {
            //выполняю запрос на получение категорий
            let trackerCategories = try context.fetch(request)
            
            if let trackerCategory = trackerCategories.first {
                //Добавляем трекер при наличии категории
                trackerCategory.addToTrackers(trackerCoreData)
            } else {
                //Если нет -> Добавляем новую категорию, а в нее - новый трекер
                let newTrackerCategoryCoreData = TrackerCategoryCoreData(context: context)
                newTrackerCategoryCoreData.headerName = trackerCategory.headerName
                newTrackerCategoryCoreData.addToTrackers(trackerCoreData)
            }
            try context.save()
        } catch {
            print("Error\(error)")
        }
    }
    
    func convertTrackerCategoryCoreDataToTrackerCategory(_ objects: [TrackerCategoryCoreData]) throws -> [TrackerCategory] {
        var categories = [TrackerCategory]()
        
        for object in objects {
            guard let headerName = object.headerName,
                  let trackerSet = object.trackers else {
                throw TrackerCategoryStoreError.decodingError
            }
            //КомпактМапим трекеры из КорДаты
            let trackers = Array(trackerSet.compactMap( {try? trackerDataStore.convertCoreDataToTracker($0 as! TrackerCoreData)}))
            let category = TrackerCategory(headerName: headerName, trackerArray: trackers)
            categories.append(category)
        }
        return categories
    }
    
    func convertTrackersCoreDataToTrackerCategory(_ trackersCoreData: [TrackerCoreData]) -> [TrackerCategory] {
        var trackersCategory = [TrackerCategory]()
        do {
            // Группируем Трекеры по связанным с ними именам категориий
            let groupedTrackers = Dictionary(grouping: trackersCoreData) {$0.trackerCategory?.headerName}
            //преобразуем каждый объект TrackerCoreData в  Tracker
            for (key, value) in groupedTrackers {
                let trackers = try value.map({ try trackerDataStore.convertCoreDataToTracker($0)})
                //проверям, что ключ "действителен"
                guard let key else { return [] }
                
                //Создаем TrackerCategory с кей-именем и связанными с ним Трекерами
                let trackerCategory = TrackerCategory(headerName: key, trackerArray: trackers)
                trackersCategory.append(trackerCategory)
            }
        } catch {
            print("Ошибка преобразования")
        }
        return trackersCategory
    }
    

    
    func fetchTrackerCategoryWithPredicates(_ predicates: NSPredicate) -> [TrackerCategory] {
        //Проверка на доступ к fetchRequest из trackerDataController
        guard let fetchRequest = trackerDataController?.fetchRequest else { return []}
        //Указывает Core Data не загружать объекты в виде "faults" (заглушек)
        fetchRequest.returnsObjectsAsFaults = false
        //Устанавливаем сортировку запроса по свойству name объекта TrackerCoreData в возрастающем порядке.
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)]
        //Устанавливаем предикат запроса
        fetchRequest.predicate = predicates
        
        do {
            //Выполняем запрос с использованием performFetch(). Используем try для обработки возможных ошибок при выполнении запроса.
            try trackerDataController?.performFetch()
            //Проверка на получении объектов из запроса
            guard let trackersCoreData =  trackerDataController?.fetchedObjects else { return [] }
            //Заводим полученные объекты TrackerCoreData в объекты TrackerCategory
            let trackerCategories = convertTrackersCoreDataToTrackerCategory(trackersCoreData)
            return trackerCategories
        } catch {
            return []
        }
    }
    
    func setTrackerDataController(_ controller: NSFetchedResultsController<TrackerCoreData>?) {
        self.trackerDataController = controller
    }
    
    
}
