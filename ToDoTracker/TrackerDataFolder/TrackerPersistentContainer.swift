//
//  TrackerPersistentContainer.swift
//  ToDoTracker
//
//  Created by Денис on 17.07.2023.
//

import CoreData
import Foundation

final class TrackerPersistentContainer {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerCoreData")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error as NSError? {
                assertionFailure("Ошибка инициализации контейнера CoreData: \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
}
