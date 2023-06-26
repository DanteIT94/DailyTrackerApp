//
//  TrackerViewController.swift
//  ToDoTracker
//
//  Created by Денис on 21.06.2023.
//

import UIKit

final class TrackerViewController: UIViewController {
    //MARK: - Private Properties
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
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
        //        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TrackerCardViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(<#T##viewClass: AnyClass?##AnyClass?#>, forSupplementaryViewOfKind: <#T##String#>, withReuseIdentifier: <#T##String#>)
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
    private var completedTrackersIDs: Set<TrackerRecord> = []
    private var currentDate: Date
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        view.backgroundColor = .YPWhite
        configNavigationBar()
//        configCollectionView()
        createLayout()
        hidePlaceholders()
        
    }
    
    //MARK: - Private Methods
    private func configNavigationBar() {
        let leftButton = UIBarButtonItem(image: UIImage(named: "Plus"), style: .done, target: self, action: #selector(addButtonTapped))
        
        let rightButton = UIBarButtonItem(customView: datePicker)
        leftButton.tintColor = .YPBlack
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func addButtonTapped() {
        // Действия, выполняемые при нажатии на кнопку "+"
    }
    
//    private func configCollectionView() {
//        collectionView.dataSource = self
//        collectionView.delegate = self
//
//        collectionView.register(TrackerCardViewCell.self, forCellWithReuseIdentifier: "cell")
//    }
    
    private func createLayout() {
        [searchTextField, collectionView, imagePlaceholder, textPlaceholder].forEach{
            view.addSubview($0)}
        
        collectionView.dataSource = self
        collectionView.delegate = self
        ///Отступ
        let indend: Double = 16.0
        NSLayoutConstraint.activate([
            //Поле поиска
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: indend),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -indend),
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //Коллекция
            ///НУЖНО БУДЕТ ЕЩЕ РАЗ ПРОВЕРИТЬ!!
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
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
        imagePlaceholder.isHidden = true
        textPlaceholder.isHidden = true
    }
    
}

//MARK: -UICollectionViewDelegate
extension TrackerViewController: UICollectionViewDelegate {
    
}

//MARK: -UICollectionViewDelegateFlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 167, height: 148)
    }
}

//MARK: -UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCardViewCell
        cell?.configCell()
        return cell ?? UICollectionViewCell()
    }
    
    
}

//MARK: -UITextFieldDelegate
extension TrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
}
