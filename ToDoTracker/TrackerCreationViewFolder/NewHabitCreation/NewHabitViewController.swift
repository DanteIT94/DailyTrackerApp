//
//  NewHabitViewController.swift
//  ToDoTracker
//
//  Created by Денис on 27.06.2023.
//

import UIKit

protocol NewHabitViewControllerDelegate: AnyObject {
    func addNewHabit(_ trackerCategory: TrackerCategory)
}

final class NewHabitViewController: UIViewController {
    
    weak var delegate: NewHabitViewControllerDelegate?
    
    //MARK: -Private Properties
    private let habitTextField: UITextField = {
        let habitTextField = UITextField()
        habitTextField.translatesAutoresizingMaskIntoConstraints = false
        habitTextField.backgroundColor = .YPBackgroundDay
        habitTextField.textColor = .YPBlack
        habitTextField.clearButtonMode = .whileEditing
        habitTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: habitTextField.frame.height))
        habitTextField.leftViewMode = .always
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.YPGrey as Any]
        habitTextField.attributedPlaceholder = NSAttributedString(string: "Введите название трекера", attributes: attributes)
        habitTextField.layer.masksToBounds = true
        habitTextField.layer.cornerRadius = 16
        return habitTextField
    }()
    
    private let habitTableView: UITableView = {
        let habitTableView = UITableView()
        habitTableView.translatesAutoresizingMaskIntoConstraints = false
        habitTableView.backgroundColor = .YPWhite
        return habitTableView
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
    
    private let createHabitButton: UIButton = {
        let createHabitButton = UIButton()
        createHabitButton.translatesAutoresizingMaskIntoConstraints = false
        createHabitButton.setTitle("Создать", for: .normal)
        createHabitButton.setTitleColor(.YPWhite, for: .normal)
        createHabitButton.backgroundColor = .YPGrey
        createHabitButton.layer.cornerRadius = 16
        createHabitButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        createHabitButton.isEnabled = false
        createHabitButton.addTarget(nil, action: #selector(createHabitButtonTapped), for: .touchUpInside)
        return createHabitButton
    }()
    
    private var category: String?
    private var choosedDays: [Int] = []
    private var choosedCategoryIndex: Int?
    
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        habitTextField.delegate = self
        view.backgroundColor = .YPWhite
        createHabitLayout()
    }
    
    //MARK: - Private Methods
    
    private func createHabitLayout() {
        navigationItem.title = "Новая привычка"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPBlack") ?? UIColor.black]
        navigationItem.hidesBackButton = true
        
        habitTableView.dataSource = self
        habitTableView.delegate = self
        habitTableView.register(NewHabitCell.self, forCellReuseIdentifier: NewHabitCell.reuseIdentifier)
        habitTableView.separatorStyle = .singleLine
        habitTableView.separatorColor = .YPGrey
        
        [habitTextField, habitTableView, cancelButton, createHabitButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            //Поле название привычки
            habitTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            habitTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habitTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            habitTextField.heightAnchor.constraint(equalToConstant: 75),
            //TableView
            habitTableView.topAnchor.constraint(equalTo: habitTextField.bottomAnchor, constant: 24),
            habitTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            habitTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habitTableView.heightAnchor.constraint(equalToConstant: 2 * 75),
            //Кнопка отменить
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            //Кнопка создать
            createHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createHabitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createHabitButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createHabitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func checkButtonAccessability() {
        if let text = habitTextField.text,
           !text.isEmpty,
           category != nil,
           !choosedDays.isEmpty {
            createHabitButton.isEnabled = true
            createHabitButton.backgroundColor = .YPBlack
            createHabitButton.setTitleColor(.YPWhite, for: .normal)
            
        } else {
            createHabitButton.isEnabled = false
            createHabitButton.backgroundColor = .YPGrey
        }
    }
    
    //MARK: -OBJC Methods
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createHabitButtonTapped() {
        let text: String = habitTextField.text ?? ""
        let category: String = category ?? ""
        if let delegate = delegate {
            delegate.addNewHabit(TrackerCategory(headerName: category, trackerArray: [Tracker(id: UUID(), name: text, color: .colorSection5 ?? .green, emoji: "❤️", schedule: choosedDays)]))
        }
        dismiss(animated: true)
    }
}

//MARK: -UITableViewDelegate
extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let categoryVC = CategoryViewController(choosedCategoryIndex: choosedCategoryIndex)
            categoryVC.delegate = self
            navigationController?.pushViewController(categoryVC, animated: true)
        } else if indexPath.row == 1 {
            let scheduleVC = ScheduleViewController(choosedDays: choosedDays)
            scheduleVC.delegate = self
            navigationController?.pushViewController(scheduleVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: -UITableViewDataSource
extension NewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewHabitCell.reuseIdentifier, for: indexPath) as! NewHabitCell
        cell.backgroundColor = .YPBackgroundDay
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категории"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Расписание"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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

extension NewHabitViewController: CategoryViewControllerDelegate {
    func addCategory(_ category: String, index: Int) {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = habitTableView.cellForRow(at: indexPath) as? NewHabitCell {
            cell.detailTextLabel?.text = category
        }
        self.category = category
        choosedCategoryIndex = index
        checkButtonAccessability()
    }
}
//Доп текст на ячейке "Расписание"
extension NewHabitViewController: ScheduleViewControllerDelegate {
    func addWeekDays(_ weekdays: [Int]) {
        choosedDays = weekdays
        var daysView = ""
        if weekdays.count == 7 {
            daysView = "Каждый день"
        } else {
            for index in choosedDays {
                var calendar = Calendar.current
                calendar.locale = Locale(identifier: "ru_RU")
                let day = calendar.shortWeekdaySymbols[index]
                daysView.append(day)
                daysView.append(", ")
            }
            daysView = String(daysView.dropLast(2))
        }
        let indexPath = IndexPath(row: 1, section: 0)
        if let cell = habitTableView.cellForRow(at: indexPath) as? NewHabitCell {
            cell.detailTextLabel?.text = daysView
        }
        checkButtonAccessability()
    }
}

//MARK: - UITextFieldDelegate
extension NewHabitViewController: UITextFieldDelegate {    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if category == nil || choosedDays.isEmpty {
            showReminderAlert()
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkButtonAccessability()
        habitTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder() // Закрывает клавиатуру при нажатии на свободную область
    }
    
    private func showReminderAlert() {
        let alertController = UIAlertController(title: "Напоминание", message: "Сначала выберите Категорию и Расписание", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

