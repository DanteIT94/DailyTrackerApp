//
//  StatisticViewController.swift
//  ToDoTracker
//
//  Created by Денис on 21.06.2023.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    //MARK: - Private lazy Properties
    private lazy var statisticTitle: UILabel = {
       let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = NSLocalizedString("statisticTitle", comment: "")
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return title
    }()
    
    private lazy var placeholderText: UILabel = {
       let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.isHidden = true
        text.text = "Анализировать пока нечего"
        text.textAlignment = .center
        text.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return text
    }()
    
    private lazy var placeholderImage: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isHidden = true
        image.image = UIImage(named: "Statistic_placeholder")
        return image
    }()
    
    private lazy var customInfoViewVStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12 // Расстояние между CustomInfoView
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    //MARK: - Other Properties
    let localizationKeysForDetailTitle = [
        "bestStreak",
        "perfectDays",
        "doneTrackers",
        "averageValue"]
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configStatisticLayout()
        configureCustomInfoViews()
    }
    
    //MARK: - Private Methods
    private func configStatisticLayout() {
        view.backgroundColor = .YPWhite
        
        [statisticTitle, placeholderImage, placeholderText, customInfoViewVStack].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            statisticTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 43),
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            placeholderImage.widthAnchor.constraint(equalTo: placeholderImage.heightAnchor),
            //-------------------------------------------
            placeholderText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            placeholderText.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            customInfoViewVStack.topAnchor.constraint(equalTo: statisticTitle.bottomAnchor, constant: 77),
            customInfoViewVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            customInfoViewVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
    }
    
    private func configureCustomInfoViews() {
        // Создаем массив данных с использованием интерполяции строк
            let bestStreak = calculateLongestPerfectDayStreak()
            let perfectDays = calculateNumberOfPerfectDays()
            let completedTrackers = totalCompletedTrackers()
            let averageCompletedTrackers = averageCompletedTrackers()
            
            let data: [String] = [
                "\(bestStreak)",
                "\(perfectDays)",
                "\(completedTrackers)",
                "\(averageCompletedTrackers)"
            ]
        
        // Добавляем и настраиваем 4 CustomInfoView в стеке
        for (index, title) in localizationKeysForDetailTitle.enumerated() {
            let customInfoView = CustomInfoView()
            customInfoView.translatesAutoresizingMaskIntoConstraints = false
            customInfoViewVStack.addArrangedSubview(customInfoView)
            customInfoView.leadingAnchor.constraint(equalTo: customInfoViewVStack.leadingAnchor).isActive = true
            customInfoView.trailingAnchor.constraint(equalTo: customInfoViewVStack.trailingAnchor).isActive = true
            customInfoView.heightAnchor.constraint(equalToConstant: 90).isActive = true
            
            // Находим данные по названию из массива данных
            guard let dataForTitle = data[safe: index] else { return }
            
            // Здесь вы можете настраивать содержимое каждого CustomInfoView в зависимости от типа ячейки
            customInfoView.descriptionLabel.text = NSLocalizedString(title, comment: "")
            customInfoView.numberLabel.text = dataForTitle
        }
    }
    
    //MARK:  -
    
    //MARK: - функции по работе с данными для лэйблов View
    private func calculateLongestPerfectDayStreak() -> String {
        
        return "0"
    }
    
    private func calculateNumberOfPerfectDays() -> String {
        
        return "0"
    }
    
    private func totalCompletedTrackers() -> String {
        
        return "0"
    }
    
    private func averageCompletedTrackers() -> String {
        
        return "0"
    }
    
}

