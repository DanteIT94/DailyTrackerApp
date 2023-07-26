//
//  CategoryViewController.swift
//  ToDoTracker
//
//  Created by Денис on 29.06.2023.
//

import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
    func addCategory(_ category: String, index: Int)
}

final class CategoryViewController: UIViewController {
    
    weak var delegate: CategoryViewControllerDelegate?
    
    //MARK: - UILayout - Properties
    private var categoryTableView: UITableView = {
        let categoryTableView = UITableView()
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        categoryTableView.backgroundColor = .YPWhite
        categoryTableView.isScrollEnabled = false
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
        textPlaceholder.textColor = .YPBlack
        textPlaceholder.numberOfLines = 2
        textPlaceholder.isHidden = false
        return textPlaceholder
    }()
    
    private let addCategoryButton: UIButton = {
        let addCategoryButton = UIButton()
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.setTitleColor(.YPWhite, for: .normal)
        addCategoryButton.backgroundColor = .YPBlack
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        addCategoryButton.addTarget(nil, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return addCategoryButton
    }()
    
    
    
    //MARK: -Business - Logic Properties
//    private var categories: [String] = ["Важное"]
//    private var choosedCategoryIndex: Int?
    private var categoryTableViewHeightConstraint: NSLayoutConstraint?
    private var viewModel: CategoryViewModel
    private var trackerCategoryStore: TrackerCategoryStore

    
    //MARK: -Initializers:
    init(trackerCategoryStore: TrackerCategoryStore, viewModel: CategoryViewModel) {
//        self.choosedCategoryIndex = choosedCategoryIndex
        self.trackerCategoryStore = trackerCategoryStore
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
//        self.viewModel.$categories.bind(action: { [weak self] _ in
//            DispatchQueue.main.async {
//                self?.categoryTableView.reloadData()
//            }
//        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .YPWhite
        createCategoryLayout()
        viewModel.fetchAllTrackerCategories()
        updateCategoryTableViewHeight()
        hidePlaceholders()
    }
    
    //MARK: -Private Methods
    //MARK: Работа с MVVM
    //-----------------------------------------------------------------
    private func createCategoryLayout() {
        navigationItem.title = "Категории"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "YPBlack") ?? UIColor.black]
        navigationItem.hidesBackButton = true
        //---------------------------------------
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        categoryTableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        categoryTableView.separatorStyle = .singleLine
        categoryTableView.separatorColor = .YPGrey
        //---------------------------------------
        categoryTableViewHeightConstraint = categoryTableView.heightAnchor.constraint(equalToConstant: CGFloat(viewModel.numberOfCategories * 75))
        categoryTableViewHeightConstraint?.isActive = true
        //---------------------------------------
        [categoryTableView, imagePlaceholder, textPlaceholder, addCategoryButton].forEach{
            view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            categoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
        if viewModel.categories.count != 0 {
            textPlaceholder.isHidden = true
            imagePlaceholder.isHidden = true
        }
    }
    
    private func updateCategoryTableViewHeight() {
        let newHeight = CGFloat(viewModel.numberOfCategories * 75)
        categoryTableViewHeightConstraint?.constant = newHeight
        categoryTableViewHeightConstraint?.isActive = true
    }
    
    //MARK: -@OBJC Methods
    
    @objc private func addCategoryButtonTapped() {
        let newCategoryVC = NewCategoryViewController(trackerCategoryStore: trackerCategoryStore)
        newCategoryVC.delegate = self
        navigationController?.pushViewController(newCategoryVC, animated: true)
    }
    
}

//MARK: -UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categories = viewModel.categories.map { $0.headerName }
        guard let selectedTitle = categories[indexPath.row] else { return }
        delegate?.addCategory(selectedTitle, index: indexPath.row)
        navigationController?.popViewController(animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: -UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCategories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
        cell.backgroundColor = .YPBackgroundDay
        let cellArray = viewModel.categories.map({$0.headerName})
        cell.textLabel?.text = cellArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        
        //MARK: -Отрисовка разграничителя
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 0))
        
        let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section) - 1
        if indexPath.row == lastRowIndex {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        }
        //MARK: -Настройка углов TableView
        if let categoryCell = cell as? CategoryCell {
            if viewModel.numberOfCategories == 1 {
                categoryCell.layer.cornerRadius = 16
                categoryCell.clipsToBounds = true
                categoryCell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            } else if indexPath.row == 0 {
                categoryCell.layer.cornerRadius = 16
                categoryCell.clipsToBounds = true
                categoryCell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else if indexPath.row == numberOfRows - 1 {
                categoryCell.layer.cornerRadius = 16
                categoryCell.clipsToBounds = true
                categoryCell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                categoryCell.layer.cornerRadius = 0
            }
        }
    }
}

extension CategoryViewController: NewCategoryViewControllerDelegate {
    func didAddCategory(category: String) {
        var categories = viewModel.categories.map({$0.headerName})
        categories.append(category)
        viewModel.fetchAllTrackerCategories()
        updateCategoryTableViewHeight()
        categoryTableView.reloadData()
        hidePlaceholders()
    }
}
