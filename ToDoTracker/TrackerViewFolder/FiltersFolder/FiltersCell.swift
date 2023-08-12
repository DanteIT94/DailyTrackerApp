//
//  FiltersCell.swift
//  ToDoTracker
//
//  Created by Денис on 05.08.2023.
//


import UIKit

final class FiltersCell: UITableViewCell {
    
    static let reuseIdentifier = "FiltersCell"
    
    //    private let arrowImageView: UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.image = UIImage(systemName: "chevron.right")
    //        imageView.tintColor = .YPGrey
    //        imageView.translatesAutoresizingMaskIntoConstraints = false
    //        return imageView
    //    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    
    func setupCell() {
        textLabel?.font = UIFont.systemFont(ofSize: 17)
        textLabel?.textColor = UIColor.YPBlack
        detailTextLabel?.textColor = UIColor.YPGrey
        
        layoutMargins = .zero
        separatorInset = .init(top: 0, left: 16, bottom: 0, right: -16)
        
    }
}
