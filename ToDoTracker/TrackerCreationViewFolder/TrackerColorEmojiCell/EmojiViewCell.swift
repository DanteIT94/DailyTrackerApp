//
//  EmojiViewCell.swift
//  ToDoTracker
//
//  Created by Денис on 15.07.2023.
//

import UIKit

class EmojiViewCell: UICollectionViewCell {
    
    // Добавьте элементы интерфейса пользователя для отображения эмодзи
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Настройте внешний вид ячейки
        backgroundColor = .clear
        
        // Добавьте и настройте элементы интерфейса пользователя внутри ячейки
        // Например, создайте UILabel для отображения эмодзи и добавьте его на contentView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EmojiHeaderView: UICollectionReusableView {
    // Добавьте элементы интерфейса пользователя для отображения заголовка эмодзи
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Настройте внешний вид заголовка
        backgroundColor = .lightGray
        
        // Добавьте и настройте элементы интерфейса пользователя внутри заголовка
        // Например, создайте UILabel для отображения текста "Emoji" и добавьте его на contentView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

