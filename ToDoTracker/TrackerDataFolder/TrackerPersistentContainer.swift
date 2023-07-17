//
//  TrackerPersistentContainer.swift
//  ToDoTracker
//
//  Created by Денис on 17.07.2023.
//

import CoreData
import Foundation

final class TrackerPersistentContainer {
    private lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "TrackerCoreData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Ошибка инициализации контейнера CoreData: \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
}
