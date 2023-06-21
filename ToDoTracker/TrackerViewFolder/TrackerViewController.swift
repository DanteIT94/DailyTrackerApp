//
//  TrackerViewController.swift
//  ToDoTracker
//
//  Created by Денис on 21.06.2023.
//

import UIKit

final class TrackerViewController: UIViewController {
    //MARK: - Private Properties
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        view.backgroundColor = .YPWhite
        createNavigationBar()
        
//        if let navBar = navigationController?.navigationBar {
//            let leftButton = UIBarButtonItem(image: UIImage(named: "Plus"), style: .done, target: self, action: #selector(addButtonTapped))
//            navBar.topItem?.setLeftBarButton(leftButton, animated: false)
//
//            let rightButton = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(undoButtonTapped))
//            navBar.topItem?.setRightBarButton(rightButton, animated: false)
//
//        }
    }
    
    //MARK: - Private Methods
    private func createNavigationBar() {
        let leftButton = UIBarButtonItem(image: UIImage(named: "Plus"), style: .done, target: self, action: #selector(addButtonTapped))
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .undo, target: self, action: #selector(undoButtonTapped))
        leftButton.tintColor = .YPBlack
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton

        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    @objc func undoButtonTapped() {
        // Действия, выполняемые при нажатии на кнопку "Undo"

    }
    
    @objc func addButtonTapped() {
        // Действия, выполняемые при нажатии на кнопку "+"
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
