//
//  Date Formmator +Extension.swift
//  ToDoTracker
//
//  Created by Денис on 28.07.2023.
//

import Foundation

extension DateFormatter {
    static var shortDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }
}
