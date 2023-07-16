//
//  ColorEmojiViewCell.swift
//  ToDoTracker
//
//  Created by Денис on 15.07.2023.
//

import UIKit

class ColorViewCell: UICollectionViewCell {
    // Добавьте элементы интерфейса пользователя для отображения цвета
     let colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 8
        colorView.layer.masksToBounds = true
        colorView.translatesAutoresizingMaskIntoConstraints = false
        return colorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
                    colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    colorView.widthAnchor.constraint(equalToConstant: 40),
                    colorView.heightAnchor.constraint(equalToConstant: 40)
                ])
        // Настройте внешний вид ячейки
        backgroundColor = .clear
        
        // Добавьте и настройте элементы интерфейса пользователя внутри ячейки
        // Например, создайте UIView для отображения цвета и добавьте его на contentView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ColorHeaderView: UICollectionReusableView {
    // Добавьте элементы интерфейса пользователя для отображения заголовка цветов
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Настройте внешний вид заголовка
        backgroundColor = .blue
        
        // Добавьте и настройте элементы интерфейса пользователя внутри заголовка
        // Например, создайте UILabel для отображения текста "Цвет" и добавьте его на contentView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
