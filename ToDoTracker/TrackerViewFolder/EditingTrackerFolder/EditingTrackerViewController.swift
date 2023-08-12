//
//  EditingTrackerViewController.swift
//  ToDoTracker
//
//  Created by Денис on 03.08.2023.
//

import UIKit

protocol EditingTrackerViewControllerDelegate: AnyObject {
    func updateTracker(tracker: Tracker)
}

final class EditingTrackerViewController: UIViewController {
    
    weak var delegate: EditingTrackerViewControllerDelegate?
    
    
    //MARK: -Computered Properties
    private let editingTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .YPBackgroundDay
        textField.textColor = .YPBlack
        textField.clearButtonMode = .whileEditing
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.YPGrey as Any]
        textField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("trackerNameTextField", comment: ""),
            attributes: attributes)
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 16
        return textField
    }()
    
    private let daysTitle: UILabel = {
        let daysTitle = UILabel()
        daysTitle.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        daysTitle.textAlignment = .center
        daysTitle.translatesAutoresizingMaskIntoConstraints = false
        return daysTitle
    }()
    
    private let editingTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .YPWhite
        return tableView
    }()
    
    //БЛОК Цвета и Эмодзи для Выбора
    private lazy var editingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .YPWhite
        scrollView.contentSize = contentSize
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
        print("Loaded colors: \(colors)")
        return colors
    }()
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter
    }()
    
    lazy var daysOfWeek: [String] = {
        let calendar = Calendar.current
        let firstDayIndex = calendar.firstWeekday - 1 // Учитываем, что индексация начинается с 0
        var days = formatter.shortStandaloneWeekdaySymbols ?? []

        let beforeFirstDay = days.prefix(upTo: firstDayIndex)
        let afterFirstDay = days.suffix(from: firstDayIndex)
        days = Array(afterFirstDay) + Array(beforeFirstDay)
        return days
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
    
    private let editTrackerButton: UIButton = {
        let editTrackerButton = UIButton()
        editTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        editTrackerButton.setTitle(NSLocalizedString(
            "saveButton", comment: ""), for: .normal)
        editTrackerButton.setTitleColor(.YPWhite, for: .normal)
        editTrackerButton.backgroundColor = .YPGrey
        editTrackerButton.layer.cornerRadius = 16
        editTrackerButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        editTrackerButton.isEnabled = false
        editTrackerButton.addTarget(nil, action: #selector(saveUpdateButtonTapped), for: .touchUpInside)
        return editTrackerButton
    }()
    //MARK: - Other Properties
    var updatedTracker: Tracker?
//    private var trackerName: String?
    private var category: String?
    private var choosedDays: [Int] = []
    private var choosedCategoryIndex: Int?
    private var choosedEmoji: String?
    private var choosedColor: UIColor?
    private var isTrackerEvent: Bool?
    private var isTrackerPinned: Bool?
    private var selectedColorCellIndexPath: IndexPath?
    private var selectedEmojiCellIndexPath: IndexPath?
    var colorIndex: Int? {
        return colorData.firstIndex(where: { $0.hexString() == self.choosedColor?.hexString() })
       }
    
    //MARK: -INIT
    private var trackerStore: TrackerStore
    private var trackerRecordStore: TrackerRecordStore
    private var trackerCategoryStore: TrackerCategoryStore
    private let categoryViewModel: CategoryViewModel
    private var trackerID: UUID
    
    init(trackerStore: TrackerStore, trackerRecordStore: TrackerRecordStore, trackerCategoryStore: TrackerCategoryStore, categoryViewModel: CategoryViewModel, trackerID: UUID) {
        self.trackerStore = trackerStore
        self.trackerRecordStore = trackerRecordStore
        self.categoryViewModel = categoryViewModel
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerID = trackerID
        super.init(nibName: nil, bundle: nil)
        fetchTracker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -LifeCycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        editingTextField.delegate = self
        view.backgroundColor = .YPWhite
        configureColorEmojiCollectionView()
        createEditingLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectInitialEmojiAndColor()
    }
    
    private func fetchTracker() {
        do {
            let tracker = try trackerStore.readTracker(by: trackerID)
            editingTextField.text = tracker.name
            category = tracker.category
            choosedEmoji = tracker.emoji
            choosedColor = tracker.color
            choosedDays = tracker.schedule
            isTrackerEvent = tracker.isEvent
            isTrackerPinned = tracker.isPinned
            print(tracker)
        } catch {
            print("Error")
        }
    }
    
    private func selectInitialEmojiAndColor() {
        // Выберите элементы в коллекциях, используя значения choosedEmoji и choosedColor
        if let choosedEmoji = choosedEmoji,
           let index = emojiData.firstIndex(of: choosedEmoji) {
            let indexPath = IndexPath(item: index, section: 0)
            emojiCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            collectionView(emojiCollectionView, didSelectItemAt: indexPath)
        }
        
        if let choosedColor = choosedColor,
           let index = colorData.firstIndex(where: { $0.hexString() == choosedColor.hexString() }) {
            print("Choosed color: \(choosedColor)")
            print("Index: \(index)")
            let indexPath = IndexPath(item: index, section: 0)
            colorCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            collectionView(colorCollectionView, didSelectItemAt: indexPath)
        } else {
            print("Choosed color is nil or not found in colorData.")
        }
    }
    
    //MARK: - Private Methods
    private func configureColorEmojiCollectionView() {
        colorCollectionView.register(ColorViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        emojiCollectionView.register(EmojiViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
        
        colorCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ColorHeader")
        emojiCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmojiHeader")
    }
    
    private func createEditingLayout() {
        navigationItem.title = NSLocalizedString(
            "editingTitle", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPBlack") ?? UIColor.black]
        navigationItem.hidesBackButton = true
        
        editingTableView.dataSource = self
        editingTableView.delegate = self
        editingTableView.register(EditingTrackerCell.self, forCellReuseIdentifier: EditingTrackerCell.reuseIdentifier)
        editingTableView.separatorStyle = .singleLine
        editingTableView.separatorColor = .YPGrey
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        
        self.daysTitle.text = getDaysForTitle()
        
        contentView.addSubview(editingTextField)
        contentView.addSubview(daysTitle)
        contentView.addSubview(editingTableView)
        contentView.addSubview(emojiCollectionView)
        contentView.addSubview(colorCollectionView)
        contentView.addSubview(cancelButton)
        contentView.addSubview(editTrackerButton)
        editingScrollView.addSubview(contentView)
        view.addSubview(editingScrollView)
        
        var tableViewSize: CGFloat?
        if isTrackerEvent == true {
            tableViewSize = 75
        } else {
            tableViewSize = 2 * 75
        }
        
        NSLayoutConstraint.activate([
            // ScrollView
            editingScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            editingScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editingScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editingScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // ContentView
            contentView.topAnchor.constraint(equalTo: editingScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: editingScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: editingScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: editingScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: editingScrollView.widthAnchor),
            //DaysTitle
            daysTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            daysTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            daysTitle.heightAnchor.constraint(equalToConstant: 38),
            // TextField
            editingTextField.topAnchor.constraint(equalTo: daysTitle.bottomAnchor, constant: 40),
            editingTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            editingTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            editingTextField.heightAnchor.constraint(equalToConstant: 75),
            // TableView
            editingTableView.topAnchor.constraint(equalTo: editingTextField.bottomAnchor, constant: 24),
            editingTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            editingTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            editingTableView.heightAnchor.constraint(equalToConstant: tableViewSize!),
            // Emoji CollectionView
            emojiCollectionView.topAnchor.constraint(equalTo: editingTableView.bottomAnchor, constant: 16),
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
            editTrackerButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 24),
            editTrackerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            editTrackerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            editTrackerButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            editTrackerButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func daysDeclension(for counter: Int) -> String {
        let formatString: String = NSLocalizedString("numberOfDays", comment: "")
        let resultString: String = String.localizedStringWithFormat(formatString, counter)
        return resultString
    }
    
    private func getDaysForTitle() -> String {
        let counter = trackerRecordStore.fetchTrackerRecordCount(id: trackerID)
        let daysDeclension = daysDeclension(for: counter)
        return "\(counter) \(daysDeclension)"
    }
    
    private func getSelectedDaysString(from choosedDays: [Int]) -> String {
        var selectedDays: [String] = []
        for index in choosedDays {
            if let dayName = daysOfWeek[safe: index] {
                selectedDays.append(dayName)
            }
        }
        return selectedDays.joined(separator: ", ")
    }
    
    private func checkButtonAccessability() {
        if let text = editingTextField.text,
           !text.isEmpty,
           category != nil,
           choosedDays.isEmpty == false,
           choosedColor != nil,
           choosedEmoji != nil {
            
            editTrackerButton.isEnabled = true
            editTrackerButton.backgroundColor = .YPBlack
            editTrackerButton.setTitleColor(.YPWhite, for: .normal)
            
        } else {
            editTrackerButton.isEnabled = false
            editTrackerButton.backgroundColor = .YPGrey
        }
    }
    
    
    //MARK: -OBJC Methods
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func saveUpdateButtonTapped() {
        let text: String = editingTextField.text ?? ""
        let category: String = category ?? ""
        let color: UIColor = choosedColor ?? .gray
        let emoji: String = choosedEmoji ?? ""
        let isEvent: Bool = isTrackerEvent ?? false
        let isPinned: Bool = isTrackerPinned ?? false
        let schedule: [Int] = choosedDays
        if let delegate = delegate {
            delegate.updateTracker(tracker: Tracker(id: trackerID, name: text, color: color, emoji: emoji, schedule: schedule, isEvent: isEvent, isPinned: isPinned, category: category))

        }
        dismiss(animated: true)
    }
}

//MARK: -UITableViewDelegate
extension EditingTrackerViewController: UITableViewDelegate {
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
extension EditingTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isTrackerEvent == true {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditingTrackerCell.reuseIdentifier, for: indexPath) as! EditingTrackerCell
        cell.backgroundColor = .YPBackgroundDay
        
//        ВОТ ТУТ НУЖНО СДелАТЬ пРОВерку
        if indexPath.row == 0 {
            cell.textLabel?.text = NSLocalizedString(
                "chooseCategoryButton", comment: "")
            cell.detailTextLabel?.text = category
        } else if indexPath.row == 1 {
            cell.textLabel?.text = NSLocalizedString(
                "chooseScheduleButton", comment: "")
            let daysDescription = getSelectedDaysString(from: choosedDays)
            if choosedDays.count == 7 {
                
            } else {
                cell.detailTextLabel?.text = daysDescription
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        
        if numberOfRows == 1 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if indexPath.row == 0 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == numberOfRows - 1 {
            cell.layer.cornerRadius = 16
            cell.clipsToBounds = true
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            cell.layer.cornerRadius = 0
            cell.clipsToBounds = false
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
extension EditingTrackerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
extension EditingTrackerViewController: UICollectionViewDelegateFlowLayout {
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
extension EditingTrackerViewController: CategoryViewControllerDelegate {
    func addCategory(_ category: String, index: Int) {
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = editingTableView.cellForRow(at: indexPath) as? EditingTrackerCell {
            cell.detailTextLabel?.text = category
        }
        self.category = category
        choosedCategoryIndex = index
        checkButtonAccessability()
    }
}
//MARK: -ScheduleViewControllerDelegate
//Доп текст на ячейке "Расписание"
extension EditingTrackerViewController: ScheduleViewControllerDelegate {
    func addWeekDays(_ weekdays: [Int]) {
        choosedDays = weekdays
        var daysView = ""
        
        if weekdays.count == 7 {
            daysView = NSLocalizedString(
                "everyDayText", comment: "")
        } else {
            for index in choosedDays {
                var calendar = Calendar.current
                calendar.locale = Locale(identifier: "ru_RU")
                let day = calendar.shortWeekdaySymbols[index]
                daysView.append(day)
                daysView.append(", ")
            }
            
            daysView = weekdays
                .map {Calendar.current.shortWeekdaySymbols[$0]}
                .joined(separator: ", ")
        }
        let indexPath = IndexPath(row: 1, section: 0)
        if let cell = editingTableView.cellForRow(at: indexPath) as? EditingTrackerCell {
            cell.detailTextLabel?.text = daysView
        }
        checkButtonAccessability()
    }
}

//MARK: - UITextFieldDelegate
extension EditingTrackerViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if category == nil || choosedDays.isEmpty {
            showReminderAlert()
            textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkButtonAccessability()
        editingTextField.resignFirstResponder()
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

