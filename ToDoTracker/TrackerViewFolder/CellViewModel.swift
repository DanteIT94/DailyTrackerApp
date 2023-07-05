//
//  CellViewController.swift
//  ToDoTracker
//
//  Created by Денис on 26.06.2023.
//

import UIKit

struct CellViewModel {
    let dayCounter: Int
    var buttonIsChecked: Bool
    let buttonIsEnable: Bool
    let tracker: Tracker
    let indexPath: IndexPath
}
