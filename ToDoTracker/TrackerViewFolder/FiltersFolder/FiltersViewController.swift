//
//  FiltersViewController.swift
//  ToDoTracker
//
//  Created by Денис on 05.08.2023.
//
import UIKit

struct CellData {
    let title: String
    let identifier: String
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellDataArray = [
        CellData(title: "Все трекеры", identifier: "allTrackers"),
        CellData(title: "Трекеры на сегодня", identifier: "todayTrackers"),
        CellData(title: "Завершенные", identifier: "completedTrackers"),
        CellData(title: "Незавершенные", identifier: "incompleteTrackers")
    ]
    
    private var customView: UIView = {
       let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FiltersCell.self, forCellReuseIdentifier: FiltersCell.reuseIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Фильтры", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPBlack") ?? UIColor.black]
        
        createLayout()
    }
    
    func createLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
       
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 4 * 75)
        ])
    }
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FiltersCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = cellDataArray[indexPath.row].title
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellIdentifier = cellDataArray[indexPath.row].identifier
        switch cellIdentifier {
        case "allTrackers":
            dismiss(animated: true)
            break
        case "todayTrackers":
            //TODO: - дописать логику
            break
        case "completedTrackers":
            //TODO: - дописать логику
            break
        case "incompleteTrackers":
            //TODO: - дописать логику
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Настройка внешнего вида ячейки
        
        // Вычисляем, является ли ячейка первой или последней
        let isFirstCell = indexPath.row == 0
        let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        
        if isFirstCell && isLastCell {
            // Ячейка одна в секции - закругляем все углы
            cell.contentView.layer.cornerRadius = 16
        } else if isFirstCell {
            // Первая ячейка в секции - закругляем верхние углы
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLastCell {
            // Последняя ячейка в секции - закругляем нижние углы
            cell.contentView.layer.cornerRadius = 16
            cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            // Прочие ячейки - без закругления
            cell.contentView.layer.cornerRadius = 0
            cell.contentView.layer.maskedCorners = []
        }
        cell.backgroundColor = .YPBackgroundDay // Прозрачный фон ячейки
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.textLabel?.textColor = .YPBlack // Цвет текста
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, widthForRowAt indexPath: IndexPath) -> CGFloat {
        let leftPadding: CGFloat = 16
        let rightPadding: CGFloat = 16
        let availableWidth = tableView.bounds.width - leftPadding - rightPadding
        return availableWidth
    }
}
