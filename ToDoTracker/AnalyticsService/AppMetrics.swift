//
//  AppMetric.swift
//  ToDoTracker
//
//  Created by Денис on 13.08.2023.
//

import Foundation
import YandexMobileMetrica

enum AppMetricsParams {
    enum Item: String {
        case add_track
        case track
        case filter
        case edit
        case delete
        
        case habitButton
        case eventButton

        case saveNewTracker
        case trackerCategory
        case trackerSchedule
        case emoji
        case color
    }
    
    enum Event: String {
        case open
        case close
        case click
    }
}

protocol AppMetricsProtocol {
    func reportEvent(screen: String, event: AppMetricsParams.Event, item: AppMetricsParams.Item?)
}

class AppMetrics: AppMetricsProtocol {
    func reportEvent(screen: String, event: AppMetricsParams.Event, item: AppMetricsParams.Item?) {
        var paramenters = ["screen" : screen]
        if let item {
            paramenters["item"] = item.rawValue
         }
        print("Event:", event.rawValue, paramenters)
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: paramenters)
    }
    
    
}
