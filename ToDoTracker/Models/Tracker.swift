//
//  Tracker.swift
//  ToDoTracker
//
//  Created by Денис on 25.06.2023.
//

import UIKit

//Сущн. для хранения информации про терекр
struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Int]
}
