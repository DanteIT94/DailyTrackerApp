//
//  TrackersViewController.swift
//  ToDoTracker
//
//  Created by Денис on 21.06.2023.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    //MARK: - Private Properties
    
    private let dateFormmater: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_RU")
        datePicker.calendar = calendar
        datePicker.preferredDatePickerStyle = .compact
        return datePicker
    }()
    
    private let searchTextField: UISearchTextField = {
        let searchTextField = UISearchTextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = "Что хотите найти?"
        return searchTextField
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let imagePlaceholder: UIImageView = {
        let imagePlaceholder = UIImageView()
        imagePlaceholder.translatesAutoresizingMaskIntoConstraints = false
        imagePlaceholder.image = UIImage(named: "Image_placeholder")
        imagePlaceholder.isHidden = false
        return imagePlaceholder
    }()
    
    private let textPlaceholder: UILabel = {
        let textPlaceholder = UILabel()
        textPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        textPlaceholder.text = "Что будем отслеживать?"
        textPlaceholder.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textPlaceholder.textColor = .YPBlack
        textPlaceholder.isHidden = false
        return textPlaceholder
    }()
    
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPWhite
        configNavigationBar()
        configCollectionView()
        createLayout()
        hidePlaceholders()
        print(categories)
        print(visibleCategories)
        print(completedTrackers)
    }
    
    //MARK: - Private Methods
    private func configNavigationBar() {
        let leftButton = UIBarButtonItem(image: UIImage(named: "Plus"), style: .done, target: self, action: #selector(addTrackerButtonTapped))
        
        let rightButton = UIBarButtonItem(customView: datePicker)
        leftButton.tintColor = .YPBlack
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    private func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(TrackerCardViewCell.self, forCellWithReuseIdentifier: "TrackerCardCell")
        
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    private func createLayout() {
        [searchTextField, collectionView, imagePlaceholder, textPlaceholder].forEach{
            view.addSubview($0)}
        
        ///Отступ
        let indend: Double = 16.0
        NSLayoutConstraint.activate([
            //Поле поиска
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: indend),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -indend),
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //Коллекция
            ///НУЖНО БУДЕТ ЕЩЕ РАЗ ПРОВЕРИТЬ!!
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: indend),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -indend),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            //Картинка-заглушка
            imagePlaceholder.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            imagePlaceholder.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            //Текст-заглушка
            textPlaceholder.centerXAnchor.constraint(equalTo: imagePlaceholder.centerXAnchor),
            textPlaceholder.topAnchor.constraint(equalTo: imagePlaceholder.bottomAnchor, constant: 8)
        ])
    }
    
    private func hidePlaceholders() {
        if visibleCategories.count != 0 {
            imagePlaceholder.isHidden = true
            textPlaceholder.isHidden = true
        }
    }
    
    private func configViewModel(for indexPath: IndexPath) -> CellViewModel {
        let tracker = visibleCategories[indexPath.section].trackerArray[indexPath.row]
        let counter = completedTrackers.filter({$0.id == tracker.id}).count
        let trackerIsChecked = completedTrackers.contains(TrackerRecord(id: tracker.id, date: dateFormmater.string(from: currentDate)))
        var checkButtonEnable = true
        let dateComparision = Calendar.current.compare(currentDate, to: Date(), toGranularity: .day)
        if dateComparision.rawValue == 1 {
            checkButtonEnable = false
        }
        return CellViewModel(dayCounter: counter, buttonIsChecked: trackerIsChecked, buttonIsEnable: checkButtonEnable, tracker: tracker, indexPath: indexPath)
    }
    
    //MARK: - @OBJC Methods
    @objc private func addTrackerButtonTapped() {
        let newHabitViewController = NewHabitViewController()
        newHabitViewController.delegate = self
        let NewTrackerTypeViewController = NewTrackerTypeViewController(newHabitViewController: newHabitViewController)
        let modalNavigationController = UINavigationController(rootViewController: NewTrackerTypeViewController)
        navigationController?.present(modalNavigationController, animated: true)
    }
    
    @objc private func datePickerValueChanged () {
        currentDate = datePicker.date
        //Значение дня недели уменьшается на 1,  для приведения его к правильному формату (0-понедельник, 1-вторник и т.д.).
        let dayOfWeek = Calendar.current.component(.weekday, from: currentDate) - 1
        var newCategories: [TrackerCategory] = []
        
        for category in categories {
            var trackers: [Tracker] = []
            for tracker in category.trackerArray {
                if tracker.schedule.contains(where: {$0 == dayOfWeek}) {
                    trackers.append(tracker)
                }
            }
            newCategories.append(TrackerCategory(headerName: category.headerName, trackerArray: trackers))
        }
        
        visibleCategories = newCategories
        hidePlaceholders()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCardCell", for: indexPath) as? TrackerCardViewCell
        cell?.delegate = self
        let viewModel = configViewModel(for: indexPath)
        cell?.configCell(viewModel: viewModel)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? HeaderCollectionReusableView
        headerView?.configHeader(text: visibleCategories[indexPath.section].headerName)
        return headerView ?? UICollectionReusableView()
    }
    
    
}

//MARK: -UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

//MARK: - NewHabitDelegate
extension TrackersViewController: NewHabitViewControllerDelegate {
    func addNewTracker(_ trackerCategory: TrackerCategory) {
        var newCategories: [TrackerCategory] = []
        
        if let categoryIndex = categories.firstIndex(where: { $0.headerName == trackerCategory.headerName }) {
            for (index, category) in categories.enumerated() {
                var trackers = category.trackerArray
                if index == categoryIndex {
                    trackers.append(contentsOf: trackerCategory.trackerArray)
                }
                newCategories.append(TrackerCategory(headerName: category.headerName, trackerArray: trackers))
            }
            print("AAAA")
        } else {
            newCategories = categories
            newCategories.append(trackerCategory)
            print(newCategories)
        }
        categories = newCategories
        datePickerValueChanged()
        //        checkNeedPlaceholder(for: .noTrackers)
        collectionView.reloadData()
    }
}

extension TrackersViewController: TrackerCardViewCellDelegate {
    func dayCheckButtonTapped(viewModel: CellViewModel) {
        print("ok")
    }
    
    
}

