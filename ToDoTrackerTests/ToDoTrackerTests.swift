//
//  ToDoTrackerTests.swift
//  ToDoTrackerTests
//
//  Created by Денис on 12.08.2023.
//

import XCTest
import SnapshotTesting
@testable import ToDoTracker

final class ToDoTrackerTests: XCTestCase {
        
    func testViewController() {
            //TODO: - Знаю что нужно делать заглушки, но горят сроки!
            let trackerContainer = TrackerPersistentContainer()
            let trackerStore = TrackerStore(context: trackerContainer.context)
            let trackerCategoryStore = TrackerCategoryStore(
                context: trackerContainer.context,
                trackerDataStore: trackerStore)
            let trackerRecordStore = TrackerRecordStore(context: trackerContainer.context)

            let categoryViewModel = CategoryViewModel(
                trackerCategoryStore: trackerCategoryStore)

            let trackerDataController = TrackerDataController(
                trackerCategoryStore: trackerCategoryStore,
                trackerStore: trackerStore,
                trackerRecordStore: trackerRecordStore,
                context: trackerContainer.context)

            let appMetric = AppMetrics()

            let trackersViewController = TrackersViewController(
                trackerDataController: trackerDataController,
                trackerCategoryStore: trackerCategoryStore,
                categoryViewModel: categoryViewModel,
                trackerStore: trackerStore,
                trackerRecordStore: trackerRecordStore,
                appMetrics: appMetric)

            // Для светлой темы
            assertSnapshot(matching: trackersViewController, as: .image(traits: .init(userInterfaceStyle: .light)))

            // Для темной темы
            assertSnapshot(matching: trackersViewController, as: .image(traits: .init(userInterfaceStyle: .dark)), named: "DarkTheme")
        }
    
}
