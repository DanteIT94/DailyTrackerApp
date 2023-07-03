//
//  ScheduleViewController.swift
//  ToDoTracker
//
//  Created by Денис on 29.06.2023.
//
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func addWeekDays(_ weekdays: [Int])
}

final class ScheduleViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: ScheduleViewControllerDelegate?
    
    // MARK: - Private Properties
    private let weekdayTableView: UITableView = {
        let weekdayTableView = UITableView()
        weekdayTableView.translatesAutoresizingMaskIntoConstraints = false
        weekdayTableView.backgroundColor = .YPBlack
        weekdayTableView.isScrollEnabled = false
        return weekdayTableView
    }()
    
    private let okButton: UIButton = {
        let okButton = UIButton()
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.setTitle("Готово", for: .normal)
        okButton.backgroundColor = .YPWhite
        okButton.setTitleColor(.YPBlack, for: .normal)
        okButton.layer.cornerRadius = 16
        okButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        okButton.addTarget(nil, action: #selector(okButtonTapped), for: .touchUpInside)
        return okButton
    }()
    
    private var calendar = Calendar.current
    private var days = [String]()
    private var finalList: [Int] = []
    private var switchStates: [Int: Bool] = [:]
    
    // MARK: - Initializer
    init(choosedDays: [Int]) {
        super.init(nibName: nil, bundle: nil)
        
        calendar.locale = Locale(identifier: "ru_RU")
        days = calendar.weekdaySymbols
        finalList = choosedDays
        setupInitialSelectedDays()
        print(switchStates)
        print(finalList)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPBlack
        createScheduleLayout()
        configDaysArray()
        weekdayTableView.reloadData()
    }
    
    // MARK: - Private Methods
    private func createScheduleLayout() {
        navigationItem.title = "Расписание"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPWhite") ?? UIColor.white]
        navigationItem.hidesBackButton = true
        
        weekdayTableView.dataSource = self
        weekdayTableView.delegate = self
        weekdayTableView.register(SwitchCell.self, forCellReuseIdentifier: SwitchCell.reuseIdentifier)
        weekdayTableView.separatorStyle = .singleLine
        weekdayTableView.separatorColor = .YPWhite
        
        [weekdayTableView, okButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            weekdayTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            weekdayTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekdayTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            weekdayTableView.heightAnchor.constraint(equalToConstant: 7 * 75),
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            okButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            okButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            okButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            okButton.heightAnchor.constraint(equalToConstant: 60)
            
            
        ])
    }
    
//    private func setupInitialSelectedDays() {
//        for (index, day) in days.enumerated() {
//            let weekday = calendar.component(.weekday, from: Date())
//            if weekday == getIndexOfWeek(day) {
//                switchStates[index] = true
//            } else {
//                switchStates[index] = false
//            }
//        }
//    }
    private func setupInitialSelectedDays() {
        for (index, day) in days.enumerated() {
            let weekdayIndex = calendar.weekdaySymbols.firstIndex(of: day.lowercased()) ?? 0
            
            if finalList.contains(weekdayIndex + 1) {
                switchStates[index] = true
            } else {
                switchStates[index] = false
            }
        }
    }
    
    private func configDaysArray() {
        let weekdaySymbols = calendar.weekdaySymbols
        let firstDayIndex = 1 // Index of "Понедельник" in the weekdaySymbols array
        
        // Form a new array with shifted weekdays
        let weekdays = Array(weekdaySymbols[firstDayIndex...]) + Array(weekdaySymbols[..<firstDayIndex])
        days = weekdays.map { $0.capitalizeFirstLetter() }
    }
    
    @objc func okButtonTapped() {
        finalList.removeAll()
        
        let tableView = weekdayTableView
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? SwitchCell else { continue }
                guard cell.switcher.isOn else { continue }
                guard let text = cell.textLabel?.text else { continue }
                guard let weekday = getIndexOfWeek(text) else { continue }
                finalList.append(weekday)
            }
        }
        delegate?.addWeekDays(finalList)
        navigationController?.popViewController(animated: true)
    }
    
    private func getIndexOfWeek(_ text: String) -> Int? {
        return calendar.weekdaySymbols.firstIndex(of: text.lowercased())
    }
}

// MARK: - UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.reuseIdentifier, for: indexPath) as! SwitchCell
        cell.backgroundColor = .YPBackground
        cell.textLabel?.text = days[indexPath.row]
        
        // Get the switch state value from the dictionary
        let switchState = switchStates[indexPath.row] ?? false
        
        // Set the switch state value
        cell.switcher.isOn = switchState
        
        // Add a target for the switch value change event
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numbersOfRows = tableView.numberOfRows(inSection: 0)
        
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == numbersOfRows - 1 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        // MARK: - Draw separator
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0))
        
        let lastRowIndex = numbersOfRows - 1
        if indexPath.row == lastRowIndex {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        }
    }
}
// MARK: - SwitchCellDelegate
extension ScheduleViewController: SwitchCellDelegate {
    func switchCellDidToggle(_ cell: SwitchCell, isOn: Bool) {
        if let indexPath = weekdayTableView.indexPath(for: cell) {
            // Save the switch state value in the dictionary
            switchStates[indexPath.row] = isOn
        }
    }
}





//import UIKit
//
//protocol ScheduleViewControllerDelegate: AnyObject {
//    func addWeekDays(_ weekdays: [Int])
//}
//
//final class ScheduleViewController: UIViewController {
//    //MARK: -Public Properties
//    weak var delegate: ScheduleViewControllerDelegate?
//
//    //MARK: -Private properties
//    private let weekdayTableView: UITableView = {
//        let weekdayTableView =  UITableView()
//        weekdayTableView.translatesAutoresizingMaskIntoConstraints = false
//        weekdayTableView.backgroundColor = .YPBlack
//        weekdayTableView.isScrollEnabled = false
//        return weekdayTableView
//    }()
//
//    private let okButton: UIButton = {
//        let okButton = UIButton()
//        okButton.translatesAutoresizingMaskIntoConstraints = false
//        okButton.setTitle("Готово", for: .normal)
//        okButton.backgroundColor = .YPWhite
//        okButton.setTitleColor(.YPBlack, for: .normal)
//        okButton.layer.cornerRadius = 16
//        okButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        okButton.addTarget(nil, action: #selector(okButtonTapped), for: .touchUpInside)
//        return okButton
//    }()
//
//    private var calendar = Calendar.current
//    private var days = [String]()
//    private var finalList: [Int] = []
//    //Cловарь, где ключом будет являться индекс ячейки, а значением - состояние переключателя. Cохраняем состояние переключателей для каждой ячейки независимо от их переиспользования.
//    private var switchStates: [Int: Bool] = [:]
//
//    //MARK: - Initializer
//    init(choosedDays: [Int]) {
//        super.init(nibName: nil, bundle: nil)
//
//        calendar.locale = Locale(identifier: "ru_RU")
//        days = calendar.weekdaySymbols
//        finalList = choosedDays
//        setupInitialSelectedDays()
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    //MARK: - LifeCycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .YPBlack
//        createScheduleLayout()
//        configDaysArray()
////        for day in finalList {
////            if let row = days.firstIndex(where: { getIndexOfWeek($0) == day }) {
////                let indexPath = IndexPath(row: row, section: 0)
////                guard let cell = weekdayTableView.cellForRow(at: indexPath) as? SwitchCell else { continue }
////                cell.switcher.setOn(true, animated: false)
////            }
////        }
//        weekdayTableView.reloadData()
//    }
//
//    //MARK: -Private Methods
//    private func createScheduleLayout() {
//        navigationItem.title = "Расписание"
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPWhite") ?? UIColor.white]
//        navigationItem.hidesBackButton = true
//
//        weekdayTableView.dataSource = self
//        weekdayTableView.delegate = self
//        weekdayTableView.register(SwitchCell.self, forCellReuseIdentifier: SwitchCell.reuseIdentifier)
//        weekdayTableView.separatorStyle = .singleLine
//        weekdayTableView.separatorColor = .YPWhite
//
//
//        [weekdayTableView, okButton].forEach{
//            view.addSubview($0)}
//
//        NSLayoutConstraint.activate([
//            weekdayTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            weekdayTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            weekdayTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            weekdayTableView.heightAnchor.constraint(equalToConstant: 7 * 75),
//            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            okButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            okButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            okButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
//            okButton.heightAnchor.constraint(equalToConstant: 60)
//        ])
//    }
//
//    private func setupInitialSelectedDays() {
//        for (index, day) in days.enumerated() {
//            let weekday = calendar.component(.weekday, from: Date())
//            if weekday == getIndexOfWeek(day) {
//                switchStates[index] = true
//            } else {
//                switchStates[index] = false
//            }
//        }
//    }
//
//
//    private func configDaysArray() {
//        let weekdaySymbols = calendar.weekdaySymbols
//        let firstDayIndex = 1 // Индекс "Понедельника" в массиве weekdaySymbols
//
//        // Формируем новый массив с перенесенными днями недели
//        let weekdays = Array(weekdaySymbols[firstDayIndex...]) + Array(weekdaySymbols[..<firstDayIndex])
//        days = weekdays.map { $0.capitalizeFirstLetter() }
//    }
//
//    @objc func okButtonTapped() {
//        finalList.removeAll()
//
//        let tableView = weekdayTableView
//        for section in 0..<tableView.numberOfSections {
//            for row in 0..<tableView.numberOfRows(inSection: section) {
//                guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? SwitchCell else { continue }
//                guard cell.switcher.isOn else { continue }
//                guard let text = cell.textLabel?.text else { continue }
//                guard let weekday = getIndexOfWeek(text) else { continue }
//                finalList.append(weekday)
//            }
//        }
//        delegate?.addWeekDays(finalList)
//        navigationController?.popViewController(animated: true)
//    }
//
//    private func getIndexOfWeek(_ text: String) -> Int? {
//        return calendar.weekdaySymbols.firstIndex(of: text.lowercased())
//    }
//}
//
////MARK: -UITableViewDelegate
//extension ScheduleViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
//
////MARK: -UITableViewDataSource
//extension ScheduleViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return days.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.reuseIdentifier, for: indexPath) as! SwitchCell
//        cell.backgroundColor = .YPBackground
//        cell.textLabel?.text = days[indexPath.row]
//
//        // Получаем значение состояния переключателя из словаря
//        let switchState = switchStates[indexPath.row] ?? false
//
//        // Устанавливаем значение состояния переключателя
//        cell.switcher.isOn = switchState
//
//        // Добавляем обработчик события изменения состояния переключателя
//        cell.switcher.addTarget(self, action: #selector(switcherValueChanged), for: .valueChanged)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let numbersOfRows = tableView.numberOfRows(inSection: 0)
//
//        if indexPath.row == 0 {
//            cell.layer.cornerRadius = 16
//            cell.clipsToBounds = true
//            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        } else if indexPath.row == numbersOfRows - 1 {
//            cell.layer.cornerRadius = 16
//            cell.clipsToBounds = true
//            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        }
//
//        // MARK: - Отрисовка разграничителя
//        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//
//        let lastRowIndex = numbersOfRows - 1
//        if indexPath.row == lastRowIndex {
//            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
//        }
//    }
//
//
//    @objc private func switcherValueChanged(_ sender: UISwitch) {
//        if let cell = sender.superview?.superview as? SwitchCell,
//           let indexPath = weekdayTableView.indexPath(for: cell) {
//            let isSelected = sender.isOn
//
//            // Сохраняем значение состояния переключателя в словаре
//            switchStates[indexPath.row] = isSelected
//        }
//    }
//}
