//
//  ScheduleViewController.swift
//  ToDoTracker
//
//  Created by Денис on 29.06.2023.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectedSchedules(_ viewController: ScheduleViewController, selectedDays: [String])
}

final class ScheduleViewController: UIViewController {
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
    
    private let daysOfWeek = ["Понедельник","Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
//    private let weekdaySymbols = Calendar.current.shortWeekdaySymbols
    private var selectedDays: [String] = []
    weak var delegate: ScheduleViewControllerDelegate?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPBlack
        createScheduleLayout()
    }
    
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
    
    @objc func okButtonTapped() {
//        let calendar = Calendar.current
//        let weekdaySymbols = calendar.shortWeekdaySymbols
//
//        let shortSelectedDays = selectedDays.compactMap { day in
//            return weekdaySymbols.firstIndex(of: day)
//        }.compactMap { index in
//            return weekdaySymbols[index]
//        }
        
        delegate?.didSelectedSchedules(self, selectedDays: selectedDays)
        navigationController?.popViewController(animated: true)
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
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.reuseIdentifier, for: indexPath) as! SwitchCell
        cell.delegate = self
        cell.backgroundColor = .YPBackground
        cell.textLabel?.text = daysOfWeek[indexPath.row]
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

extension ScheduleViewController: SwitchCellDelegate {
    func switchCellDidToggle(_ cell: SwitchCell, isOn: Bool) {
        guard let indexPath = weekdayTableView.indexPath(for: cell) else { return }
        let selectedOption = daysOfWeek[indexPath.row]
        
        if isOn {
            //переключатель включен - добавляем название ячейки
            if !selectedDays.contains(selectedOption) {
                selectedDays.append(selectedOption)
            } else {
                if let index = selectedDays.firstIndex(of: selectedOption) {
                    selectedDays.remove(at: index)
                }
            }
        }
    }
}
