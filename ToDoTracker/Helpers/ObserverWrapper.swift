//
//  ObserverWrapper.swift
//  ToDoTracker
//
//  Created by Денис on 25.07.2023.
//

import Foundation

@propertyWrapper
final class Observable<Value> {
    private var onChange: ((Value) -> Void)? = nil
    /// вызываем функцию после изменения обёрнутого значения
    var wrappedValue: Value {
        didSet {
            onChange?(wrappedValue)
        }
    }
    /// возвращает экземпляр самого проперти враппера
    var projectedValue: Observable<Value> {
        return self
    }
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    /// функция для добавления функции для вызова на изменение
    func bind(action: @escaping (Value) -> Void) {
        self.onChange = action
    }
}
