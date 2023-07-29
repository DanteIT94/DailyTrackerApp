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
        eventTextField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("trackerNameTextField", comment: ""),
            attributes: attributes)
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
    
    //БЛОК Цвета и Эмодзи для Выбора
    private lazy var habitScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = .YPWhite
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    ///Прослойка для ScrollView
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
    //---------------------------------------------------------
    
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
    
    private let createEventButton: UIButton = {
        let createEventButton = UIButton()
        createEventButton.translatesAutoresizingMaskIntoConstraints = false
        createEventButton.setTitle(NSLocalizedString(
            "newTrackerVCCreateButton", comment: ""), for: .normal)
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
    private var choosedColor: UIColor?
    private var choosedEmoji: String?
    private var selectedColorCellIndexPath: IndexPath?
    private var selectedEmojiCellIndexPath: IndexPath?
    
    private var trackerCategoryStore: TrackerCategoryStore
    private let categoryViewModel: CategoryViewModel
    init(trackerCategoryStore: TrackerCategoryStore, categoryViewModel: CategoryViewModel) {
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
        eventTextField.delegate = self
        view.backgroundColor = .YPWhite
        
        configureColorEmojiCollectionView()
        createEventLayout()
    }
    
    //MARK: - Private Methods
    private func configureColorEmojiCollectionView() {
        colorCollectionView.register(ColorViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        emojiCollectionView.register(EmojiViewCell.self, forCellWithReuseIdentifier: "EmojiCell")
        
        colorCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ColorHeader")
        emojiCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmojiHeader")
    }
    
    private func createEventLayout() {
        navigationItem.title = NSLocalizedString(
            "newEventTitle", comment: "")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPBlack") ?? UIColor.black]
        navigationItem.hidesBackButton = true
        
        eventTableView.dataSource = self
        eventTableView.delegate = self
        eventTableView.register(NewEventCell.self, forCellReuseIdentifier: NewEventCell.reuseIdentifier)
        eventTableView.separatorStyle = .singleLine
        eventTableView.separatorColor = .YPGrey
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        
        contentView.addSubview(eventTextField)
        contentView.addSubview(eventTableView)
        contentView.addSubview(emojiCollectionView)
        contentView.addSubview(colorCollectionView)
        contentView.addSubview(cancelButton)
        contentView.addSubview(createEventButton)
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
            eventTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            eventTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            eventTextField.heightAnchor.constraint(equalToConstant: 75),
            // TableView
            eventTableView.topAnchor.constraint(equalTo: eventTextField.bottomAnchor, constant: 24),
            eventTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            eventTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            eventTableView.heightAnchor.constraint(equalToConstant: 75),
            // Emoji CollectionView
            emojiCollectionView.topAnchor.constraint(equalTo: eventTableView.bottomAnchor, constant: 16),
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
            createEventButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 24),
            createEventButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createEventButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            createEventButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func checkButtonAccessability() {
        if  let text = eventTextField.text,
            !text.isEmpty,
            category != nil,
            choosedColor != nil,
            choosedEmoji != nil {
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
        let color: UIColor = choosedColor ?? .gray
        let emoji: String = choosedEmoji ?? ""
        if let delegate = delegate {
            delegate.addNewEvent(TrackerCategory(headerName: category, trackerArray: [Tracker(id: UUID(), name: text, color: color, emoji: emoji, schedule: choosedDays)]))
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
            let categoryVC = CategoryViewController(trackerCategoryStore: trackerCategoryStore, viewModel: categoryViewModel)
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
            cell.textLabel?.text = NSLocalizedString(
                "chooseCategoryButton", comment: "")
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

//MARK: -UICollectionViewDelegate, UICollectionViewDataSource
extension NewEventViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorCollectionView {
            return colorData.count
        } else if collectionView == emojiCollectionView {
            return emojiData.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        
        if collectionView == colorCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorViewCell
            let color = colorData[indexPath.item]
            if let colorCell = cell as? ColorViewCell {
                colorCell.colorView.backgroundColor = color
            }
        } else if collectionView == emojiCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as? EmojiViewCell ?? UICollectionViewCell()
            let label = UILabel(frame: cell.contentView.bounds)
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 32)
            label.text = emojiData[indexPath.item]
            cell.contentView.addSubview(label)
        } else {
            cell = UICollectionViewCell()
        }
        cell.layer.cornerRadius = 16
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
extension NewEventViewController: UICollectionViewDelegateFlowLayout {
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
        /// Закрывает клавиатуру при нажатии на свободную область
        textField.resignFirstResponder()
    }
    
    private func showReminderAlert() {
        let alertController = UIAlertController(
            title: NSLocalizedString(
                "eventAlertTitle", comment: ""),
            message: NSLocalizedString(
                "eventAlertText", comment: ""),
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
