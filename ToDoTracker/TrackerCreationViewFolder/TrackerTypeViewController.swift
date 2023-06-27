//
//  TrackerTypeViewController.swift
//  ToDoTracker
//
//  Created by Денис on 27.06.2023.
//

import UIKit

protocol TrackerTypeViewControllerDelegate: AnyObject {
    
}

final class TrackerTypeViewController: UIViewController {
    
    //MARK: - Private Propeties
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .YPWhite
        titleLabel.text = "Создание трекера"
        return titleLabel
    }()
    
    private let habbitButton: UIButton = {
        let habbitButton = UIButton()
        habbitButton.translatesAutoresizingMaskIntoConstraints = false
        habbitButton.setTitle("Привычки", for: .normal)
        habbitButton.setTitleColor(.YPBlack, for: .normal)
        habbitButton.backgroundColor = .YPWhite
        habbitButton.layer.cornerRadius = 16
        habbitButton.layer.masksToBounds = true
        habbitButton.imageView?.contentMode = .scaleAspectFill
        habbitButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        habbitButton.addTarget(nil, action: #selector(dayCheckButtonTapped), for: .touchUpInside)
        return habbitButton
    }()
    
    private let nonRegularEventButton: UIButton = {
        let nonRegularEventButton = UIButton()
        nonRegularEventButton.translatesAutoresizingMaskIntoConstraints = false
        nonRegularEventButton.setTitle("Нерегулярные события", for: .normal)
        nonRegularEventButton.setTitleColor(.YPBlack, for: .normal)
        nonRegularEventButton.backgroundColor = .YPWhite
        nonRegularEventButton.layer.cornerRadius = 16
        nonRegularEventButton.layer.masksToBounds = true
        nonRegularEventButton.imageView?.contentMode = .scaleAspectFill
        nonRegularEventButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        nonRegularEventButton.addTarget(nil, action: #selector(dayCheckButtonTapped), for: .touchUpInside)
        return nonRegularEventButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPBlack
        createLayout()
        
    }
    
    //MARK: - Private Methods
    
    private func createLayout() {
        [titleLabel, habbitButton, nonRegularEventButton].forEach {
            view.addSubview($0)
        }
            
            NSLayoutConstraint.activate([
                ///Настройка надписи
                titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
                titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                ///Кнопка "Привычки"
                habbitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 281),
                habbitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                habbitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                habbitButton.heightAnchor.constraint(equalToConstant: 60),

                nonRegularEventButton.topAnchor.constraint(equalTo: habbitButton.bottomAnchor, constant: 16),
                nonRegularEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                nonRegularEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                nonRegularEventButton.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
    }
