//
//  String+Extension.swift
//  ToDoTracker
//
//  Created by Денис on 02.07.2023.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

}
