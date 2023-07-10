//
//  TrackerRecord.swift
//  ToDoTracker
//
//  Created by Денис on 25.06.2023.
//

import UIKit

///Сущность для хранения записи о том, что некий трекер был выполнен на некот. дату
struct TrackerRecord {
    let id: UUID
    let date: String
}

extension TrackerRecord: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
