//
//  TrackerCardViewCell.swift
//  ToDoTracker
//
//  Created by Денис on 22.06.2023.
//

import UIKit

final class TrackerCardViewCell: UICollectionViewCell {
    
    //MARK: -Private Properties
    private let cardBackgroundView: UIView = {
        let cardBackgroundView = UIView()
        cardBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        return cardBackgroundView
    }()
    
    private let emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()
    
    private let taskLabel: UILabel = {
        let taskLabel = UILabel()
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        return taskLabel
    }()
    
    private let dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        return dayLabel
    }()
    
    private let dayCheckButton: UIButton = {
        let dayCheckButton = UIButton()
        dayCheckButton.translatesAutoresizingMaskIntoConstraints = false
        return dayCheckButton
    }()
    
    //MARK: - Initilizers
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCustomCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    private func createCustomCell() {
        contentView.addSubview(cardBackgroundView)
        [emojiLabel, taskLabel].forEach {
            contentView.addSubview($0)
        }
        contentView.addSubview(dayCheckButton)
        contentView.addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            //Цветная подложка
            cardBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardBackgroundView.heightAnchor.constraint(equalToConstant: 90),
            //Эмодзи
            emojiLabel.topAnchor.constraint(equalTo: cardBackgroundView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            //Лэйбл задачи
            taskLabel.bottomAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: -12),
            taskLabel.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 12),
            taskLabel.trailingAnchor.constraint(equalTo: cardBackgroundView.trailingAnchor, constant: -12),
            //Кнопка подтверждения
            dayCheckButton.topAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: 8),
            dayCheckButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            dayCheckButton.heightAnchor.constraint(equalToConstant: 34),
            dayCheckButton.widthAnchor.constraint(equalToConstant: 34),
            //Лэйбл количества дней
            dayLabel.centerYAnchor.constraint(equalTo: dayCheckButton.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
}
