//
//  HeaderCollectionReusableView.swift
//  ToDoTracker
//
//  Created by Денис on 26.06.2023.
//

import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {
    
    private let headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.textColor = .YPBlack
        headerLabel.font = .boldSystemFont(ofSize: 19)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()
    
    func configHeader(text: String) {
        headerLabel.text = text
        addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
