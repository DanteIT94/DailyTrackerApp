//
//  CategoryViewModel.swift
//  ToDoTracker
//
//  Created by Денис on 25.07.2023.
//

import Foundation
import UIKit

class CategoryViewModel {
    
    private let trackerCategoryStore: TrackerCategoryStore
    @Observable private(set) var categories: [TrackerCategoryCoreData] = []
    @Observable private(set) var selectedCategory: TrackerCategoryCoreData?

    var numberOfCategories: Int { categories.count }

    
    init(trackerCategoryStore: TrackerCategoryStore) {
        self.trackerCategoryStore = trackerCategoryStore
    }
    
    
    func fetchAllTrackerCategories() {
        // Здесь просто вызываем метод fetchTrackerCategoriesFor у TrackerDataController
        let fetchedResulstController = trackerCategoryStore.fetchResultControllerForCategory
        categories = fetchedResulstController.fetchedObjects ?? []
    }
    
    // Дополнительные методы ViewModel для обработки действий пользователя и другой логики
    
    
}

