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
        let collectionView = UICollectionView()
        
        return collectionView
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
        
        //ТУТ НУЖНО ПОСТАВИТЬ ПикерView
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
        [searchTextField].forEach{
            view.addSubview($0)
        ///Отступ
            let indend: Double = 16.0
            NSLayoutConstraint.activate([
            //Поле поиска
                searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: indend),
                searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -indend),
                searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            ])
        }
    }
}

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
