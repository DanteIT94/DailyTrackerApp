//
//  TrackerHeaderCollectionReusableView.swift
//  ToDoTracker
//
//  Created by Денис on 26.06.2023.
//

import UIKit

final class TrackerHeaderCollectionReusableView: UICollectionReusableView {
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .YPBlack
        label.font = .boldSystemFont(ofSize: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configHeader(text: String) {
        label.text = text
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -12),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 14)
        ])
    }
}
