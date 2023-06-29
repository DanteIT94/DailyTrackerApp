//
//  TrackerTypeViewController.swift
//  ToDoTracker
//
//  Created by Денис on 27.06.2023.
//

import UIKit

protocol NewTrackerTypeViewControllerDelegate: AnyObject {
    
}

final class NewTrackerTypeViewController: UIViewController {
    
    //MARK: - Private Propeties
    
    private let habitButton: UIButton = {
        let habitButton = UIButton()
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.setTitle("Привычки", for: .normal)
        habitButton.setTitleColor(.YPBlack, for: .normal)
        habitButton.backgroundColor = .YPWhite
        habitButton.layer.cornerRadius = 16
        habitButton.layer.masksToBounds = true
        habitButton.imageView?.contentMode = .scaleAspectFill
        habitButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        habitButton.addTarget(nil, action: #selector(habitButtonTapped), for: .touchUpInside)
        return habitButton
    }()
    
    private let eventButton: UIButton = {
        let eventButton = UIButton()
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.setTitle("Нерегулярные события", for: .normal)
        eventButton.setTitleColor(.YPBlack, for: .normal)
        eventButton.backgroundColor = .YPWhite
        eventButton.layer.cornerRadius = 16
        eventButton.layer.masksToBounds = true
        eventButton.imageView?.contentMode = .scaleAspectFill
        eventButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //        nonRegularEventButton.addTarget(nil, action: #selector(nonRegularEventButtonTapped), for: .touchUpInside)
        return eventButton
    }()
    
    private var newHabitViewController: UIViewController?
    
    //MARK: -Initizlizer
    init(newHabitViewController: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        self.newHabitViewController = newHabitViewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPBlack
        createLayout()
        
    }
    
    //MARK: - Private Methods
    
    private func createLayout() {
        
        navigationItem.title = "Создание Трекера"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPWhite") ?? UIColor.white]
        
        [habitButton, eventButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            ///Кнопка "Привычки"
            habitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 281),
            habitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            eventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    //MARK: -@OBJC Methods
    @objc private func habitButtonTapped() {
        let newHabitViewController = NewHabitViewController()
        navigationController?.pushViewController(newHabitViewController, animated: true)
        
    }
    
    @objc private func eventButtonTapped() {
        
    }
    
}
