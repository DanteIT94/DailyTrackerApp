//
//  TrackerCardViewCell.swift
//  ToDoTracker
//
//  Created by Денис on 22.06.2023.
//

import UIKit

final class TrackerCardViewCell: UICollectionViewCell {
    
    //MARK: -Private Properties
    //✅
    private let cardBackgroundView: UIView = {
        let cardBackgroundView = UIView()
        cardBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        cardBackgroundView.layer.masksToBounds = true
        cardBackgroundView.layer.cornerRadius = 16
        return cardBackgroundView
    }()
    
    //✅🚫
    private let emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        emojiLabel.layer.cornerRadius = 68
        emojiLabel.layer.masksToBounds = true
        return emojiLabel
    }()
    
    //✅
    private let taskLabel: UILabel = {
        let taskLabel = UILabel()
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.font = UIFont.systemFont(ofSize: 12)
        taskLabel.textColor = .YPWhite
        return taskLabel
    }()
    //✅
    private let dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.font = UIFont.systemFont(ofSize: 12)
        dayLabel.textColor = .YPWhite
        return dayLabel
    }()
    //✅🚫
    private let dayCheckButton: UIButton = {
        let dayCheckButton = UIButton()
        dayCheckButton.translatesAutoresizingMaskIntoConstraints = false
        dayCheckButton.setTitle("", for: .normal)
        dayCheckButton.setImage(UIImage(named: "Plus"), for: .normal)
        dayCheckButton.tintColor = .colorSection5
        dayCheckButton.imageView?.contentMode = .scaleAspectFill
        dayCheckButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        dayCheckButton.addTarget(nil, action: #selector(dayCheckButtonTapped), for: .touchUpInside)
        return dayCheckButton
    }()
    //Bool-ключ для отметки (возможно временно)
    private var isChecked: Bool = false
    
    //MARK: - Initilizers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createCustomCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Public Methods
    func configCell() {
        taskLabel.text = "Полить цветы"
        emojiLabel.text = "😪"
        dayLabel.text = "1 день"
        cardBackgroundView.backgroundColor = .colorSection5
        
        createCustomCell()
    }
    
    //MARK: - Private Methods
    //✅🚫
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
    
    @objc
    private func dayCheckButtonTapped() {
        if isChecked {
            dayCheckButton.setImage(UIImage(named: "Plus"), for: .normal)
            dayCheckButton.layer.opacity = 1.0
            isChecked = false
        } else {
            dayCheckButton.setImage(UIImage(named: "checkmark.circle.fill"), for: .normal)
            dayCheckButton.layer.opacity = 0.3
            isChecked = true
        }
    }
}
