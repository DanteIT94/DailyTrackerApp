//
//  NewEventViewController.swift
//  ToDoTracker
//
//  Created by Денис on 03.07.2023.
//

import UIKit

protocol NewEventViewControllerDelegate: AnyObject {
    func addNewEvent(_ trackerCategory: TrackerCategory)
}

final class NewEventViewController: UIViewController {
    
    weak var delegate: NewEventViewControllerDelegate?
    
    //MARK: -Private Properties
    private let eventTextField: UITextField = {
        let eventTextField = UITextField()
        eventTextField.translatesAutoresizingMaskIntoConstraints = false
        eventTextField.backgroundColor = .YPBackgroundDay
        eventTextField.textColor = .YPBlack
        eventTextField.clearButtonMode = .whileEditing
        eventTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: eventTextField.frame.height))
        eventTextField.leftViewMode = .always
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.YPGrey as Any]
        eventTextField.attributedPlaceholder = NSAttributedString(string: "Введите название трекера", attributes: attributes)
        eventTextField.layer.masksToBounds = true
        eventTextField.layer.cornerRadius = 16
        return eventTextField
    }()
    
    private let eventTableView: UITableView = {
        let eventTableView = UITableView()
        eventTableView.translatesAutoresizingMaskIntoConstraints = false
        eventTableView.backgroundColor = .YPWhite
        return eventTableView
    }()
    
    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.YPRed, for: .normal)
        cancelButton.layer.borderColor = UIColor.YPRed?.cgColor
        cancelButton.layer.borderWidth = 2.0
        cancelButton.backgroundColor = .clear
        cancelButton.layer.cornerRadius = 16
        cancelButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cancelButton.addTarget(nil, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return cancelButton
    }()
    
    private let createEventButton: UIButton = {
        let createEventButton = UIButton()
        createEventButton.translatesAutoresizingMaskIntoConstraints = false
        createEventButton.setTitle("Создать", for: .normal)
        createEventButton.setTitleColor(.YPWhite, for: .normal)
        createEventButton.backgroundColor = .YPGrey
        createEventButton.layer.cornerRadius = 16
        createEventButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        createEventButton.isEnabled = false
        createEventButton.addTarget(nil, action: #selector(createEventButtonTapped), for: .touchUpInside)
        return createEventButton
    }()
    
    private var category: String?
    private var choosedCategoryIndex: Int?
    private var choosedDays: [Int] = Array(0...6)
    
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTextField.delegate = self
        view.backgroundColor = .YPWhite
        createEventLayout()
    }
    
    //MARK: - Private Methods
    
    private func createEventLayout() {
        navigationItem.title = "Новое нерегулярное событие"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPBlack") ?? UIColor.black]
        navigationItem.hidesBackButton = true
        
        eventTableView.dataSource = self
        eventTableView.delegate = self
        eventTableView.register(NewEventCell.self, forCellReuseIdentifier: NewEventCell.reuseIdentifier)
        eventTableView.separatorStyle = .singleLine
        eventTableView.separatorColor = .YPGrey
        
        [eventTextField, eventTableView, cancelButton, createEventButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            //Поле название привычки
            eventTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            eventTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            eventTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            eventTextField.heightAnchor.constraint(equalToConstant: 75),
            //TableView
            eventTableView.topAnchor.constraint(equalTo: eventTextField.bottomAnchor, constant: 24),
            eventTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            eventTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            eventTableView.heightAnchor.constraint(equalToConstant: 2 * 75),
            //Кнопка отменить
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            //Кнопка создать
            createEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createEventButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createEventButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func checkButtonAccessability() {
        if  let text = eventTextField.text,
            !text.isEmpty,
            category != nil {
            createEventButton.isEnabled = true
            createEventButton.backgroundColor = .YPBlack
            createEventButton.setTitleColor(.YPWhite, for: .normal)
            
        } else {
            createEventButton.isEnabled = false
            createEventButton.backgroundColor = .YPGrey
        }
    }
    
    //MARK: -OBJC Methods
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createEventButtonTapped() {
        let text: String = eventTextField.text ?? ""
        let category: String = category ?? ""
        if let delegate = delegate {
            delegate.addNewEvent(TrackerCategory(headerName: category, trackerArray: [Tracker(id: UUID(), name: text, color: .colorSection5 ?? .green, emoji: "❤️", schedule: choosedDays)]))
        } else {
            print("Delegate is not set")
        }
        dismiss(animated: true)
    }
}

//MARK: -UITableViewDelegate
extension NewEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let categoryVC = CategoryViewController(choosedCategoryIndex: choosedCategoryIndex)
            categoryVC.delegate = self
            navigationController?.pushViewController(categoryVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: -UITableViewDataSource
extension NewEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewEventCell.reuseIdentifier, for: indexPath) as! NewEventCell
        cell.backgroundColor = .YPBackgroundDay
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категории"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if indexPath.row == numberOfRows - 1 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        //MARK: - Отрисовка разграничителя
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0))
        
        let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section) - 1
        if indexPath.row == lastRowIndex {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        }
    }
}

extension NewEventViewController: CategoryViewControllerDelegate {
    func addCategory(_ category: String, index: Int) {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = eventTableView.cellForRow(at: indexPath) as? NewEventCell {
            cell.detailTextLabel?.text = category
        }
        self.category = category
        choosedCategoryIndex = index
        checkButtonAccessability()
    }
}

//MARK: - UITextFieldDelegate
extension NewEventViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if category == nil {
            showReminderAlert()
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkButtonAccessability()
        eventTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder() // Закрывает клавиатуру при нажатии на свободную область
    }
    
    private func showReminderAlert() {
        let alertController = UIAlertController(title: "Напоминание", message: "Сначала выберите Категорию", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
