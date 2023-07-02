//
//  ScheduleViewController.swift
//  ToDoTracker
//
//  Created by Денис on 29.06.2023.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
//    func didSelectedSchedules(_ viewController: ScheduleViewController, selectedDays: [String])
    func addWeekDays(_ weekdays: [Int])
}

final class ScheduleViewController: UIViewController {
    //MARK: -Public Properties
    weak var delegate: ScheduleViewControllerDelegate?
    
    //MARK: -Private properties
    private let weekdayTableView: UITableView = {
        let weekdayTableView =  UITableView()
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
    //---------------------------------------------
    private var calendar = Calendar.current
    private var days = [String]()
    
    private var finalList: [Int] = []
//    private let daysOfWeek = ["Понедельник","Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
//    private let weekdaySymbols = Calendar.current.shortWeekdaySymbols
    //---------------------------------------------
    //MARK: - Initializer
    init(choosedDays: [Int]) {
        super.init(nibName: nil, bundle: nil)
        
        calendar.locale = Locale(identifier: "ru_RU")
        days = calendar.weekdaySymbols
        finalList = choosedDays
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //---------------------------------------------
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPBlack
        createScheduleLayout()
        configDaysArray()
    }
    //---------------------------------------------
    //MARK: -Private Methods
    private func createScheduleLayout() {
        navigationItem.title = "Расписание"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPWhite") ?? UIColor.white]
        navigationItem.hidesBackButton = true
        
        weekdayTableView.dataSource = self
        weekdayTableView.delegate = self
        weekdayTableView.register(SwitchCell.self, forCellReuseIdentifier: SwitchCell.reuseIdentifier)
        weekdayTableView.separatorStyle = .singleLine
        weekdayTableView.separatorColor = .YPWhite
        
        
        [weekdayTableView, okButton].forEach{
            view.addSubview($0)}
        
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
    
    //Формируем список для TableView со Switcher
    private func configDaysArray() {
        let weekdaySymbols = calendar.weekdaySymbols
        var weekdays: [String] = []
        
        for weekdaySymbol in weekdaySymbols {
            weekdays.append(weekdaySymbol.capitalizeFirstLetter())
        }
        //Перекидываем Воскресенье в конец массива
        guard let firstDay = weekdays.first else { return }
        weekdays.append(firstDay)
        weekdays.remove(at: 0)
        days = weekdays
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



//MARK: -UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: -UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.reuseIdentifier, for: indexPath) as! SwitchCell
//        cell.delegate = self
        cell.backgroundColor = .YPBackground
        cell.textLabel?.text = days[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numbersOfRows = tableView.numberOfRows(inSection: 0)
        
        if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == numbersOfRows - 1{
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

//extension ScheduleViewController: SwitchCellDelegate {
//    func switchCellDidToggle(_ cell: SwitchCell, isOn: Bool) {
//        guard let indexPath = weekdayTableView.indexPath(for: cell) else { return }
//        let selectedOption = daysOfWeek[indexPath.row]
//
//        if isOn {
//            //переключатель включен - добавляем название ячейки
//            if !selectedDays.contains(selectedOption) {
//                selectedDays.append(selectedOption)
//            } else {
//                if let index = selectedDays.firstIndex(of: selectedOption) {
//                    selectedDays.remove(at: index)
//                }
//            }
//        }
//    }
//}
