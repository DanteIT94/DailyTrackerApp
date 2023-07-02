//
//  NewHabitViewController.swift
//  ToDoTracker
//
//  Created by Денис on 27.06.2023.
//

import UIKit

protocol NewHabitViewControllerDelegate: AnyObject {
    func addNewTracker(trackerCategory: TrackerCategory)
}

final class NewHabitViewController: UIViewController {
    
    weak var delegate: NewHabitViewControllerDelegate?
    
    //MARK: -Private Properties
    private let habitTextField: UITextField = {
        let habitTextField = UITextField()
        habitTextField.translatesAutoresizingMaskIntoConstraints = false
        habitTextField.backgroundColor = .YPBackground
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
        habitTableView.backgroundColor = .YPBlack
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
        createHabitButton.addTarget(nil, action: #selector(createHabitButtonTapped), for: .touchUpInside)
        return createHabitButton
    }()
    
//    private var selectedCategories: Set<String> = []
    private var selectedDays: [String] = []
    
    private var category: String?
    private var choosedDays: [Int] = []
    private var choosedCategoryIndex: Int?
    private var buttonIsEnabled = false
    
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPBlack
        createHabitLayout()
        
    }
    
    //MARK: - Private Methods
    
    private func createHabitLayout() {
        navigationItem.title = "Новая привычка"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPWhite") ?? UIColor.white]
        navigationItem.hidesBackButton = true
        
        
        habitTableView.dataSource = self
        habitTableView.delegate = self
        habitTableView.register(NewHabitCell.self, forCellReuseIdentifier: NewHabitCell.reuseIdentifier)
        habitTableView.separatorStyle = .singleLine
        habitTableView.separatorColor = .YPWhite
        
        
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
    
    //MARK: -OBJC Methods
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func createHabitButtonTapped() {
//        guard buttonIsEnabled else { return }
        let text: String = habitTextField.text ?? "Tracker"
        let category: String = category ?? "Category"
        delegate?.addNewTracker(trackerCategory: TrackerCategory(headerName: category, trackerArray: [Tracker(id: UUID(), name: text, color: .colorSection5 ?? .green, emoji: "❤️", schedule: choosedDays)]))
        
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
            let categoryVC = CategoryViewController()
            categoryVC.delegate = self
            navigationController?.pushViewController(categoryVC, animated: true)
        } else if indexPath.row == 1 {
            let scheduleVC = ScheduleViewController()
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
        
        cell.backgroundColor = .YPBackground
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Категории"
//            let selectedCategoriesString = selectedCategories.joined(separator: ", ")
            cell.detailTextLabel?.text = category
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Расписание"
            let selectedDaysString = selectedDays.joined(separator: ", ")
            cell.detailTextLabel?.text = selectedDaysString
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
    func didSelectCategory(withCategory category: String) {
        self.category = category
//        selectedCategories.insert(category)
//        let indexPath = IndexPath(row: 0, section: 0)
//        habitTableView.reloadRows(at: [indexPath], with: .none)
        habitTableView.reloadData()
    }
}

extension NewHabitViewController: ScheduleViewControllerDelegate {
    func didSelectedSchedules(_ viewController: ScheduleViewController, selectedDays: [String]) {
        if selectedDays.count == 7 {
            self.selectedDays = ["Каждый день"]
        }
        self.selectedDays = selectedDays
        habitTableView.reloadData()
    }
}

//    //MARK: -Доделать чуть позже
//    private let emojiCollection: UICollectionView = {
//        let emojiCollection = UICollectionView()
//
//        return emojiCollection
//    }()
//
//    private let colorsCollection: UICollectionView = {
//        let colorsCollection = UICollectionView()
//
//        return colorsCollection
//    }()



//MARK: - UITextFieldDelegate
extension NewHabitViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text,
           text.count >= 3 {
            createHabitButton.isEnabled = true
            createHabitButton.backgroundColor = .YPWhite
        } else {
            createHabitButton.isEnabled = false
            createHabitButton.backgroundColor = .YPGrey
        }
    }
}
