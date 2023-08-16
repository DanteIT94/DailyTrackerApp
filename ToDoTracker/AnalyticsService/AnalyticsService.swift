//
//  AnalyticsService.swift
//  ToDoTracker
//
//  Created by Денис on 13.08.2023.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "889ce810-823e-4c6f-83bf-feb1e148e624") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
}
