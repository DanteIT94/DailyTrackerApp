//
//  CategoryViewController.swift
//  ToDoTracker
//
//  Created by Денис on 29.06.2023.
//

import UIKit

final class CategoryViewController: UIViewController {
    //MARK: - Private Properties
    
    private var categoryTableView: UITableView = {
       let categoryTableView = UITableView()
        
        return categoryTableView
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
        textPlaceholder.text = """
                                Привычки и события можно
                                объединить по смыслу
                                """
        textPlaceholder.textAlignment = .center
        textPlaceholder.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textPlaceholder.textColor = .YPWhite
        textPlaceholder.numberOfLines = 2
        textPlaceholder.isHidden = false
        return textPlaceholder
    }()
    
    private let addCategoryButton: UIButton = {
        let addCategoryButton = UIButton()
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.setTitleColor(.YPBlack, for: .normal)
        addCategoryButton.backgroundColor = .YPWhite
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        addCategoryButton.addTarget(nil, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return addCategoryButton
    }()
    
    
    
    //MARK: -LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPBlack
        createCategoryLayout()
    }
    
    
    //MARK: -Private Methods
    private func createCategoryLayout() {
        navigationItem.title = "Категории"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPWhite") ?? UIColor.white]
        navigationItem.hidesBackButton = true
        
        
        [categoryTableView, imagePlaceholder, textPlaceholder, addCategoryButton].forEach{
            view.addSubview($0)}
        
        ///Отступ
        NSLayoutConstraint.activate([
            //Картинка-заглушка
            imagePlaceholder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imagePlaceholder.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //Текст-заглушка
            textPlaceholder.centerXAnchor.constraint(equalTo: imagePlaceholder.centerXAnchor),
            textPlaceholder.topAnchor.constraint(equalTo: imagePlaceholder.bottomAnchor, constant: 8),
            //Кнопка создания новой категории
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    private func hidePlaceholders() {
        textPlaceholder.isHidden = true
        imagePlaceholder.isHidden = true
    }
    
    //MARK: -@OBJC Methods
    
    @objc func addCategoryButtonTapped() {
        let newCategoryVC = NewCategoryViewController()
        navigationController?.pushViewController(newCategoryVC, animated: true)
    }

}
