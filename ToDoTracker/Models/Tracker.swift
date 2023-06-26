//
//  Tracker.swift
//  ToDoTracker
//
//  Created by Денис on 25.06.2023.
//

import UIKit

//Сущн. для хранения информации про терекр
struct Tracker {
    ///Можно ли заменить на UUID?
    let id: String
    let name: String
    ///Можно ли заменить на String?
    let color: UIColor
    let emoji: String
    let schedule: [Int]
}
