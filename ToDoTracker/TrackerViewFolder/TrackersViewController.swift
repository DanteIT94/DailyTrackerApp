//
//  TrackersViewController.swift
//  ToDoTracker
//
//  Created by Денис on 21.06.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    enum PlaceholdersTypes {
        case noTrackers
        case notFoundTrackers
    }
    
    static var selectedDate: Date?
    
    //MARK: - Private Properties
    private let dateFormmater: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    private var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
//        var calendar = Calendar.current
//        calendar.locale = Locale(identifier: "ru_RU")
//        datePicker.calendar = calendar
        datePicker.preferredDatePickerStyle = .compact
        return datePicker
    }()
    
    
    //---------------------------------------------------------------
    //MARK: -Блок поисковой строки
    private let searchStackView: UIStackView = {
        let searchStackView = UIStackView()
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.axis = .horizontal
        searchStackView.spacing = 8
        return searchStackView
    }()
    
    private let searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = NSLocalizedString(
            "searchField", comment: "")
        searchTextField.addTarget(nil, action: #selector(searchTextFieldEditingChanged), for: .editingChanged)
        return searchTextField
    }()
    
    private let cancelSearchButton: UIButton = {
        let cancelSearchButton = UIButton()
        cancelSearchButton.translatesAutoresizingMaskIntoConstraints = false
        cancelSearchButton.setTitle(NSLocalizedString(
            "cancelSearchButton", comment: ""), for: .normal)
        cancelSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelSearchButton.setTitleColor(.YPBlue, for: .normal)
        cancelSearchButton.addTarget(nil, action: #selector(cancelSearchButtonTapped), for: .touchUpInside)
        return cancelSearchButton
    }()
    //----------------------------------------------------------------------
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let imagePlaceholder: UIImageView = {
        let imagePlaceholder = UIImageView()
        imagePlaceholder.translatesAutoresizingMaskIntoConstraints = false
        imagePlaceholder.isHidden = false
        return imagePlaceholder
    }()
    
    private let textPlaceholder: UILabel = {
        let textPlaceholder = UILabel()
        textPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        textPlaceholder.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textPlaceholder.textColor = .YPBlack
        textPlaceholder.isHidden = false
        return textPlaceholder
    }()
    
    //MARK: -Variable
    private var visibleCategories: [TrackerCategory] = []
    private var currentDate: Date = Date()
    private let categoryViewModel: CategoryViewModel
    
    //Для трекеров
    private var insertedIndexesInSearchTextField: [IndexPath] = []
    private var deletedIndexesInSearchTextField: [IndexPath] = []
    //Для Секций
    private var insertedSectionsInSearchTextField: IndexSet = []
    private var deletedSectionsInSearchTextField: IndexSet = []
    
    //Блок корДаты
    private let trackerDataController: TrackerDataControllerProtocol
    private var trackerCategoryStore: TrackerCategoryStore
    
    
    //MARK: -Initializers
    init(trackerDataController: TrackerDataControllerProtocol, trackerCategoryStore: TrackerCategoryStore, categoryViewModel: CategoryViewModel) {
        self.trackerDataController = trackerDataController
        self.trackerCategoryStore = trackerCategoryStore
        self.categoryViewModel = categoryViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPWhite
        configNavigationBar()
        configCollectionView()
        createLayout()
        searchTextField.delegate = self
        trackerDataController.delegate = self
        let choosenDay = Calendar.current.component(.weekday, from: currentDate)-1
        trackerDataController.fetchTrackerCategoriesFor(weekday: choosenDay, animated: false)
        reloadVisibleCategories()
    }
    
    //MARK: - Private Methods
    private func configNavigationBar() {
//        let formattedDate = dateFormmater.string(from: datePicker.date)
        let leftButton = UIBarButtonItem(image: UIImage(named: "Plus"), style: .done, target: self, action: #selector(addTrackerButtonTapped))
        let rightButton = UIBarButtonItem(customView: datePicker)
        leftButton.tintColor = .YPBlack
        

        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
//        navigationItem.rightBarButtonItem?.title = formattedDate
        navigationItem.title = NSLocalizedString("navigTitleMainVC", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    private func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(TrackerCardViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    private func createLayout() {
        [searchStackView, collectionView, imagePlaceholder, textPlaceholder].forEach{
            view.addSubview($0)}
        searchStackView.addArrangedSubview(searchTextField)
        
        ///Отступ
        let indend: Double = 16.0
        NSLayoutConstraint.activate([
            //Поле поиска
            searchStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: indend),
            searchStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -indend),
            searchStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //Коллекция
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: indend),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -indend),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            //Картинка-заглушка
            imagePlaceholder.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            imagePlaceholder.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            //Текст-заглушка
            textPlaceholder.centerXAnchor.constraint(equalTo: imagePlaceholder.centerXAnchor),
            textPlaceholder.topAnchor.constraint(equalTo: imagePlaceholder.bottomAnchor, constant: 8),
            //Кнопка отмена
            cancelSearchButton.widthAnchor.constraint(equalToConstant: 83)
        ])
    }
    
    private func reloadPlaceholders(for type: PlaceholdersTypes) {
        if visibleCategories.isEmpty {
            imagePlaceholder.isHidden = false
            textPlaceholder.isHidden = false
            switch type {
            case .noTrackers:
                imagePlaceholder.image = UIImage(named: "Image_placeholder")
                textPlaceholder.text = NSLocalizedString(
                    "emptyPlaceholderText",
                    comment: "")
            case .notFoundTrackers:
                imagePlaceholder.image = UIImage(named: "NotFound_placeholder")
                textPlaceholder.text = NSLocalizedString(
                    "noTrackersPlaceholderText",
                    comment: "")
            }
        } else {
            imagePlaceholder.isHidden = true
            textPlaceholder.isHidden = true
        }
    }
    
    private func configViewModel(for indexPath: IndexPath) -> CellViewModel {
        let tracker = visibleCategories[indexPath.section].trackerArray[indexPath.row]
        let counter = trackerDataController.fetchRecordsCountForId(tracker.id)
        let trackerIsChecked = trackerDataController.checkTrackerRecordExists(id: tracker.id, date: dateFormmater.string(from: currentDate))
        _ = Calendar.current.compare(currentDate, to: Date(), toGranularity: .day)
        let checkButtonEnable = true
        return CellViewModel(dayCounter: counter, buttonIsChecked: trackerIsChecked, buttonIsEnable: checkButtonEnable, tracker: tracker, indexPath: indexPath)
    }
    
    private func reloadVisibleCategories() {
        currentDate = datePicker.date
        let calendar = Calendar.current
        //Значение дня недели уменьшается на 1 для приведения его к правильному формату (0-понедельник, 1-вторник и т.д.).
        let filterDayOfWeek = calendar.component(.weekday, from: currentDate) - 1
        let filterText = (searchTextField.text ?? "").lowercased()
        
        visibleCategories = trackerDataController.trackerCategories.compactMap { category in
            let trackers = category.trackerArray.filter { tracker in
                let textCondition = filterText.isEmpty ||
                tracker.name.lowercased().contains(filterText)
                let dateCondition = tracker.schedule.contains(where: {$0 == filterDayOfWeek})
                return textCondition && dateCondition
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(
                headerName: category.headerName,
                trackerArray: trackers
            )
        }
        collectionView.reloadData()
        reloadPlaceholders(for: .noTrackers)
    }
    
    //MARK: - @OBJC Methods
    @objc private func addTrackerButtonTapped() {
        let newHabitViewController = NewHabitViewController(trackerCategoryStore: trackerCategoryStore, categoryViewModel: categoryViewModel)
        newHabitViewController.delegate = self
        let newEventViewController = NewEventViewController(trackerCategoryStore: trackerCategoryStore, categoryViewModel: categoryViewModel)
        newEventViewController.delegate = self
        let NewTrackerTypeViewController = NewTrackerTypeViewController(newHabitViewController: newHabitViewController, newEventViewController: newEventViewController)
        let modalNavigationController = UINavigationController(rootViewController: NewTrackerTypeViewController)
        navigationController?.present(modalNavigationController, animated: true)
    }
    
    @objc private func datePickerValueChanged (_ sender: UIDatePicker) {
        TrackersViewController.selectedDate = sender.date
        let weekday = Calendar.current.component(.weekday, from: currentDate)-1
        trackerDataController.fetchTrackerCategoriesFor(weekday: weekday, animated: true)
        reloadVisibleCategories()
    }
    
    @objc private func cancelSearchButtonTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        datePickerValueChanged(datePicker)
        reloadPlaceholders(for: .noTrackers)
        cancelSearchButton.removeFromSuperview()
    }
}

//MARK: -UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
}

//MARK: -UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 167, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(item: 0, section: section)
        if visibleCategories[indexPath.section].trackerArray.count == 0 {
            return CGSizeZero
        }
        let headerView = self.collectionView(
            collectionView,
            viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
            at: indexPath)
        
        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }
}

//MARK: -UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = visibleCategories[section].trackerArray.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrackerCardViewCell
        cell.delegate = self
        let viewModel = configViewModel(for: indexPath)
        cell.configCell(viewModel: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HeaderCollectionReusableView
        headerView?.configHeader(text: visibleCategories[indexPath.section].headerName)
        return headerView ?? UICollectionReusableView()
    }
}

//MARK: -UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchStackView.addArrangedSubview(cancelSearchButton)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc func searchTextFieldEditingChanged() {
        guard let textForSearching = searchTextField.text else { return }
        let weekDay = Calendar.current.component(.weekday, from: currentDate)-1
        trackerDataController.fetchSearchedCategories(textForSearching: textForSearching, weekday: weekDay)
        reloadVisibleCategories()
        reloadPlaceholders(for: .notFoundTrackers)
    }
    
    private func searchText(in categories: [TrackerCategory], textForSearching: String, weekDay: Int) -> [TrackerCategory] {
        var searchedCategories: [TrackerCategory] = []
        
        for category in categories {
            var trackers: [Tracker] = []
            for tracker in category.trackerArray {
                let containsName = tracker.name.contains(textForSearching)
                let containsSchedule = tracker.schedule.contains(weekDay)
                if containsName && containsSchedule {
                    trackers.append(tracker)
                }
            }
            if !trackers.isEmpty {
                searchedCategories.append(TrackerCategory(headerName: category.headerName, trackerArray: trackers))
            }
        }
        return searchedCategories
    }
}

//MARK: -NewHabitViewControllerDelegate
extension TrackersViewController: NewHabitViewControllerDelegate {
    func addNewHabit(_ trackerCategory: TrackerCategory) {
        dismiss(animated: true)
        try? trackerDataController.addTrackerCategoryToCoreData(trackerCategory)
        reloadVisibleCategories()
        print(visibleCategories)
    }
}

//MARK: -NewEventViewControllerDelegate
extension TrackersViewController: NewEventViewControllerDelegate {
    func addNewEvent(_ trackerCategory: TrackerCategory) {
        dismiss(animated: true)
        try? trackerDataController.addTrackerCategoryToCoreData(trackerCategory)
        reloadVisibleCategories()
        print(visibleCategories)
    }
}

//MARK: -TrackerCardViewCellDelegate
extension TrackersViewController: TrackerCardViewCellDelegate {
    func dayCheckButtonTapped(viewModel: CellViewModel) {
        if viewModel.buttonIsChecked {
            trackerDataController.addTrackerRecord(id: viewModel.tracker.id, date: dateFormmater.string(from: currentDate))
        } else {
            trackerDataController.deleteTrackerRecord(id: viewModel.tracker.id, date: dateFormmater.string(from: currentDate))
        }
        collectionView.reloadItems(at: [viewModel.indexPath])
    }
}

extension TrackersViewController: TrackerDataControllerDelegate {
    func updateView(trackerCategories: [TrackerCategory], animated: Bool) {
        visibleCategories = trackerCategories
        if animated == false {
            collectionView.reloadData()
        }
        reloadPlaceholders(for: .notFoundTrackers)
    }
    
    func updateViewWithController(_ update: TrackerCategoryStoreUpdate) {
        let newCategories = trackerDataController.trackerCategories
        visibleCategories = newCategories
        reloadPlaceholders(for: .noTrackers)
    }
    
    
}

