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
        habitTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("trackerNameTextField", comment: ""),
            attributes: attributes)
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
    
    //БЛОК Цвета и Эмодзи для Выбора
    private lazy var habitScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .YPWhite
        scrollView.contentSize = contentSize
        //        scrollView.isUserInteractionEnabled = false
        return scrollView
    }()
    
    //Прослойка для ScrollView
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size = contentSize
        return view
    }()
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 200)
    }
    
    private let emojiCollectionView: UICollectionView = {
        let emojiCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
        emojiCollection.isScrollEnabled = false
        emojiCollection.isUserInteractionEnabled = true
        return emojiCollection
    }()
    
    private let emojiData: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😇", "🥶", "🤔","🙌", "🍔", "🥦", "🏓", "🥇", "🎸","🏝", "😪"]
    
    private let colorCollectionView: UICollectionView = {
        let colorCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorCollection.translatesAutoresizingMaskIntoConstraints = false
        colorCollection.isUserInteractionEnabled = true
        colorCollection.isScrollEnabled = false
        return colorCollection
    }()
    
    private let colorData: [UIColor] = {
        var colors: [UIColor] = []
        for i in 1...18 {
            let colorName = "Colorselection\(i)"
            if let color = UIColor(named: colorName) {
                colors.append(color)
            }
        }
        return colors
    }()
    
    
    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle(NSLocalizedString(
            "newTrackerVCCancelButton", comment: ""), for: .normal)
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
        createHabitButton.setTitle(NSLocalizedString(
            "newTrackerVCCreateButton", comment: ""), for: .normal)
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
    private var choosedEmoji: String?
    private var choosedColor: UIColor?
    private var selectedColorCellIndexPath: IndexPath?
    private var selectedEmojiCellIndexPath: IndexPath?
    
    //MARK: -ТЕСТ
    private var trackerCategoryStore: TrackerCategoryStore
    private let categoryViewModel: CategoryViewModel
    init(trackerCategoryStore: TrackerCategoryStore, categoryViewModel:CategoryViewModel) {
        self.trackerCategoryStore = trackerCategoryStore
        self.categoryViewModel = categoryViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        habitTextField.delegate = self
        view.backgroundColor = .YPWhite
        
        configureColorEmojiCollectionView()
        createHabitLayout()
    }
    
    //MARK: - Private Methods
    private func configureColorEmojiCollectionView() {
        colorCollectionView.register(ColorViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        emojiCollectionView.register(EmojiViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
        
        colorCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ColorHeader")
        emojiCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmojiHeader")
    }
    
    private func createHabitLayout() {
        navigationItem.title = NSLocalizedString(
            "newHabitTitle", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPBlack") ?? UIColor.black]
        navigationItem.hidesBackButton = true
        
        habitTableView.dataSource = self
        habitTableView.delegate = self
        habitTableView.register(NewHabitCell.self, forCellReuseIdentifier: NewHabitCell.reuseIdentifier)
        habitTableView.separatorStyle = .singleLine
        habitTableView.separatorColor = .YPGrey
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        
        contentView.addSubview(habitTextField)
        contentView.addSubview(habitTableView)
        contentView.addSubview(emojiCollectionView)
        contentView.addSubview(colorCollectionView)
        contentView.addSubview(cancelButton)
        contentView.addSubview(createHabitButton)
        habitScrollView.addSubview(contentView)
        view.addSubview(habitScrollView)
        
        NSLayoutConstraint.activate([
            // ScrollView
            habitScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            habitScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            habitScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            habitScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // ContentView
            contentView.topAnchor.constraint(equalTo: habitScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: habitScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: habitScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: habitScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: habitScrollView.widthAnchor),
            // TextField
            habitTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            habitTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            habitTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            habitTextField.heightAnchor.constraint(equalToConstant: 75),
            // TableView
            habitTableView.topAnchor.constraint(equalTo: habitTextField.bottomAnchor, constant: 24),
            habitTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            habitTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            habitTableView.heightAnchor.constraint(equalToConstant: 2 * 75),
            // Emoji CollectionView
            emojiCollectionView.topAnchor.constraint(equalTo: habitTableView.bottomAnchor, constant: 16),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 230),
            // Color CollectionView
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 230),
            // Cancel Button
            cancelButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 24),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            // Create Habit Button
            createHabitButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 24),
            createHabitButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createHabitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            createHabitButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createHabitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func checkButtonAccessability() {
        if let text = habitTextField.text,
           !text.isEmpty,
           category != nil,
           choosedDays.isEmpty == false,
           choosedColor != nil,
           choosedEmoji != nil {
            
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
        let color: UIColor = choosedColor ?? .gray
        let emoji: String = choosedEmoji ?? ""
        if let delegate = delegate {
            delegate.addNewHabit(TrackerCategory(headerName: category, trackerArray: [Tracker(id: UUID(), name: text, color: color, emoji: emoji, schedule: choosedDays)]))
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
            let categoryVC = CategoryViewController(trackerCategoryStore: trackerCategoryStore, viewModel: categoryViewModel)
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
            cell.textLabel?.text = NSLocalizedString(
                "chooseCategoryButton", comment: "")
        } else if indexPath.row == 1 {
            cell.textLabel?.text = NSLocalizedString(
                "chooseScheduleButton", comment: "")
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

//MARK: -UICollectionViewDelegate, UICollectionViewDataSource
extension NewHabitViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorCollectionView {
            return colorData.count
        } else if collectionView == emojiCollectionView {
            print(emojiData.count)
            return emojiData.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        if collectionView == colorCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorViewCell
            let color = colorData[indexPath.item]
            if let colorCell = cell as? ColorViewCell {
                colorCell.colorView.backgroundColor = color
            }
        } else if collectionView == emojiCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiViewCell
            let label = UILabel(frame: cell.contentView.bounds)
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 32)
            label.text = emojiData[indexPath.item]
            cell.contentView.addSubview(label)
        } else {
            cell = UICollectionViewCell()
        }
        cell.layer.cornerRadius = 16
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        if collectionView == colorCollectionView {
            // Нажатие на ячейку коллекции цветов
            let selectedColor = colorData[indexPath.item]
            
            if let previousIndexPath = selectedColorCellIndexPath,
               let previousCell = collectionView.cellForItem(at: previousIndexPath) as? ColorViewCell {
                previousCell.layer.borderWidth = 0
            }
            cell.layer.borderColor = selectedColor.withAlphaComponent(0.3).cgColor
            cell.layer.borderWidth = 3
            cell.layer.cornerRadius = 11
            cell.layer.masksToBounds = true
            
            selectedColorCellIndexPath = indexPath
            choosedColor = selectedColor
            
        } else if collectionView == emojiCollectionView {
            // Нажатие на ячейку коллекции эмодзи
            let selectedEmoji = emojiData[indexPath.item]
            
            if let previousIndexPath = selectedEmojiCellIndexPath,
               let previousCell = collectionView.cellForItem(at: previousIndexPath) as? EmojiViewCell {
                previousCell.backgroundColor = UIColor.clear
            }
            
            cell.backgroundColor = .YPLightGrey
            selectedEmojiCellIndexPath = indexPath
            
            choosedEmoji = selectedEmoji
        }
    }
    
}

//MARK: -UICollectionViewDelegateFlowLayout
extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 51, height: 51)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if collectionView == colorCollectionView {
                // Заголовок для коллекции цветов
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ColorHeader", for: indexPath)
                let titleLabel = UILabel()
                titleLabel.text = NSLocalizedString(
                    "colorCollectionTitle", comment: "")
                titleLabel.textColor = .YPBlack
                titleLabel.font = .boldSystemFont(ofSize: 19)
                titleLabel.textAlignment = .left
                titleLabel.frame = headerView.bounds
                headerView.addSubview(titleLabel)
                return headerView
            } else if collectionView == emojiCollectionView {
                // Заголовок для коллекции эмодзи
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "EmojiHeader", for: indexPath)
                let titleLabel = UILabel()
                titleLabel.text = NSLocalizedString(
                    "emojieCollectionTitle", comment: "")
                titleLabel.textColor = .YPBlack
                titleLabel.font = .boldSystemFont(ofSize: 19)
                titleLabel.textAlignment = .left
                titleLabel.frame = headerView.bounds
                headerView.addSubview(titleLabel)
                return headerView
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

//MARK: -CategoryViewControllerDelegate
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
//MARK: -ScheduleViewControllerDelegate
//Доп текст на ячейке "Расписание"
extension NewHabitViewController: ScheduleViewControllerDelegate {
    func addWeekDays(_ weekdays: [Int]) {
        choosedDays = weekdays
        var daysView = ""
        
        if weekdays.count == 7 {
            daysView = NSLocalizedString(
                "everyDayText", comment: "")
        } else {
//            for index in choosedDays {
//                var calendar = Calendar.current
//                calendar.locale = Locale(identifier: "ru_RU")
//                let day = calendar.shortWeekdaySymbols[index]
//                daysView.append(day)
//                daysView.append(", ")
//            }
            
            daysView = weekdays
                .map {Calendar.current.shortWeekdaySymbols[$0]}
                .joined(separator: ", ")
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
        let alertController = UIAlertController(
            title: NSLocalizedString(
                "habitAlertTitle", comment: ""),
            message: NSLocalizedString(
                "habitAlertText", comment: ""),
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

