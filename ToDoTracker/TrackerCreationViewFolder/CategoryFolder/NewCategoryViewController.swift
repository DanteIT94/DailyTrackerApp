//
//  NewCategoryViewController.swift
//  ToDoTracker
//
//  Created by Денис on 29.06.2023.
//

import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func didAddCategory(category: String)
}

final class NewCategoryViewController: UIViewController {
    
    //MARK: -Private Properties
    private let newCategoryTextField: UITextField = {
        let newCategoryTextField = UITextField()
        newCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        newCategoryTextField.backgroundColor = .YPBackground
        newCategoryTextField.textColor = .YPWhite
        newCategoryTextField.clearButtonMode = .whileEditing
        newCategoryTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: newCategoryTextField.frame.height))
        newCategoryTextField.leftViewMode = .always
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.YPGrey as Any]
        newCategoryTextField.attributedPlaceholder = NSAttributedString(string: "Название категории (не менее 3 символов)", attributes: attributes)
        newCategoryTextField.layer.masksToBounds = true
        newCategoryTextField.layer.cornerRadius = 16
        return newCategoryTextField
    }()
    
    private let readyButton: UIButton = {
        let readyButton = UIButton()
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.setTitle("Готово", for: .normal)
        readyButton.setTitleColor(.YPBlack, for: .normal)
        readyButton.layer.cornerRadius = 16
        readyButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        readyButton.addTarget(nil, action: #selector(readyButtonTapped), for: .touchUpInside)
        return readyButton
    }()
    
    weak var delegate: NewCategoryViewControllerDelegate?
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPBlack
        
        newCategoryTextField.delegate = self
        readyButton.isEnabled = false
        readyButton.backgroundColor = .YPGrey
        
        createNewCategoryLayout()
    }
    
    //MARK: -Private Methods
    private func createNewCategoryLayout() {
        navigationItem.title = "Новая категория"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPWhite") ?? UIColor.white]
        navigationItem.hidesBackButton = true
        
        
        [newCategoryTextField, readyButton].forEach{
            view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            //Новая категория
            newCategoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            newCategoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            newCategoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newCategoryTextField.heightAnchor.constraint(equalToConstant: 75),
            //кнопка "готово"
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    @objc func readyButtonTapped() {
        guard let category = newCategoryTextField.text else { return }
        delegate?.didAddCategory(category: category)
        navigationController?.popViewController(animated: true)
    }
    
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text,
           text.count >= 3 {
            readyButton.isEnabled = true
            readyButton.backgroundColor = .YPWhite
        } else {
            readyButton.isEnabled = false
            readyButton.backgroundColor = .YPGrey
        }
    }
}
