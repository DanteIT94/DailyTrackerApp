//
//  CategoryCell.swift
//  ToDoTracker
//
//  Created by Денис on 30.06.2023.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    static let reuseIdentifier = "CategoryCell"
    
    //    private let arrowImageView: UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.image = UIImage(systemName: "chevron.right")
    //        imageView.tintColor = .YPGrey
    //        imageView.translatesAutoresizingMaskIntoConstraints = false
    //        return imageView
    //    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    
    func setupCell() {
        textLabel?.font = UIFont.systemFont(ofSize: 17)
        textLabel?.textColor = UIColor.YPBlack
        
        layoutMargins = .zero
        separatorInset = .zero
        //        contentView.addSubview(arrowImageView)
        //        NSLayoutConstraint.activate([
        //            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        //            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        //        ])
    }
}
