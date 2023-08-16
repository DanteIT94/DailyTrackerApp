//
//  AppMetricsParametrs.swift
//  ToDoTracker
//
//  Created by Денис on 16.08.2023.
//

import Foundation

enum AppMetricsParams {
    enum Item: String {
        ///Добавление Трекера
        case add_track
        ///При нажатии на "Done" опцию трекера
        case track
        ///При нажатии на "Фильтры"
        case filter
        ///Взаимодействие с "Редактировать" контектсного меню
        case edit
        ///Взаимодействие с "Удалить" контектсного меню
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
        ///Открытие нового экрана
        case open
        ///Закрытие  прежнего экрана
        case close
        ///Обработка нажатия на кликабельный объект
        case click
    }
}
