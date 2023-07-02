//
//  SwitchCell.swift
//  ToDoTracker
//
//  Created by Денис on 29.06.2023.
//

import UIKit

protocol SwitchCellDelegate: AnyObject {
    func switchCellDidToggle(_ cell: SwitchCell, isOn: Bool)
}

final class SwitchCell: UITableViewCell {
    static let reuseIdentifier = "SwitchCellIdentifier"
    weak var delegate: SwitchCellDelegate?
    
    let switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.tintColor = .YPWhite
        switcher.onTintColor = .YPBlue
        return switcher
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSwitcher()
        selectionStyle = .none
        
        switcher.addTarget(self, action: #selector(switcherValueChanged), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSwitcher()
    }
    
    private func setupSwitcher() {
        textLabel?.font = UIFont.systemFont(ofSize: 17)
        textLabel?.textColor = UIColor.YPWhite
        contentView.addSubview(switcher)
        
        NSLayoutConstraint.activate([
            switcher.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func switcherValueChanged(_ sender: UISwitch) {
        delegate?.switchCellDidToggle(self, isOn: sender.isOn)
    }
}
