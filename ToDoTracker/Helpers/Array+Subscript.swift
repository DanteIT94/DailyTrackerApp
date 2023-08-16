//
//  Array+Subscript.swift
//  ToDoTracker
//
//  Created by Денис on 02.08.2023.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
