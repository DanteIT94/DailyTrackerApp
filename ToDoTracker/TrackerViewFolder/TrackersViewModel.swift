//
//  TrackersViewModel.swift
//  ToDoTracker
//
//  Created by Денис on 25.07.2023.
//

import Foundation
import UIKit

class TrackersViewModel {
    
    //MARK: -Private Properties
    private let trackerDataController: TrackerDataControllerProtocol
    private var visibleCategories: [TrackerCategory] = []
    
    
    init(trackerDataController: TrackerDataControllerProtocol) {
        self.trackerDataController = trackerDataController
    }
    
    //MARK: -Private Methods
    
    func fetch() {
        
    }
    
    
    
    
}
