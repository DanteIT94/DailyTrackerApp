//
//  CustomInfoView.swift
//  ToDoTracker
//
//  Created by Денис on 02.08.2023.
//

import UIKit

final class CustomInfoView: UIView {
    
    // UILabel для отображения числа
    let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .YPBlack
        return label
    }()
    
    // UILabel для отображения описания
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .YPBlack
        return label
    }()
    
    // Инициализатор для создания кастомной вью
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let gradient = UIImage.gradientImage(
            bounds: bounds,
            colors: [
                .red,
                .green,
                .systemBlue
            ])
        
        layer.borderColor = UIColor(patternImage: gradient).cgColor
    }
    
    // Метод для настройки внешнего вида вью и добавления лейблов
    private func commonInit() {
        // Настраиваем внешний вид вью
        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.borderWidth = 2
        
        // Добавляем лейблы на вью
        addSubview(numberLabel)
        addSubview(descriptionLabel)
        
        // Устанавливаем ограничения для лейблов
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    // Метод для установки числа и описания
    func configure(with number: String, description: String) {
        numberLabel.text = number
        descriptionLabel.text = description
    }
}





