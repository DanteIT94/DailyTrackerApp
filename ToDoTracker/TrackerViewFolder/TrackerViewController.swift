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
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        view.backgroundColor = .YPWhite
        createNavigationBar()
        createLayout()
    }
    
    //MARK: - Private Methods
    private func createNavigationBar() {
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
                collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
                collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: indend),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -indend),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                //Картинка-заглушка
                imagePlaceholder.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
                imagePlaceholder.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
//                imagePlaceholder.heightAnchor.constraint(equalToConstant: 80),
//                imagePlaceholder.widthAnchor.constraint(equalToConstant: 80),
                //Текст-заглушка
                textPlaceholder.centerXAnchor.constraint(equalTo: imagePlaceholder.centerXAnchor),
                textPlaceholder.topAnchor.constraint(equalTo: imagePlaceholder.bottomAnchor, constant: 8)
            ])
        }
    }
//
//    private func createPlaceholder() {
//        [imagePlaceholder, textPlaceholder].forEach {
//            view.addSubview($0)
//        }
//        //Отступ
//        let indend: Double = 16.0
//        NSLayoutConstraint.activate([
//            //Картинка-заглушка
//            imagePlaceholder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            imagePlaceholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            imagePlaceholder.heightAnchor.constraint(equalToConstant: 80),
//            imagePlaceholder.widthAnchor.constraint(equalToConstant: 80),
//            //Текст-заглушка
//            textPlaceholder.
//        ])
//    }


//MARK: -UICollectionViewDelegate
extension TrackerViewController: UICollectionViewDelegate {
    
}

//MARK: -UICollectionViewDelegateFlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    
}

//MARK: -UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        
        return cell
    }
    
    
}

//MARK: -UITextFieldDelegate
extension TrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
}
