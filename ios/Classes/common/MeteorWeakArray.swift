//
//  WeakArray.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/12.
//

import Foundation

class MeteorWeakObject<T: AnyObject> {
    weak var value: T?

    init(value: T?) {
        self.value = value
    }
}

class MeteorWeakArray<T: AnyObject> {
    private var elements: [MeteorWeakObject<T>] = []

    func add(_ element: T) {
        if(!elements.contains { $0.value === element }) {
            elements.append(MeteorWeakObject(value: element))
        }
    }
    
    func add(contentsOf newElements: [T]) {
        newElements.forEach { add($0) }
    }

    func remove(_ element: T) {
        elements = elements.filter { $0.value !== element }
    }

    var allObjects: [T] {
        elements = elements.filter { $0.value != nil }
        return elements.compactMap { $0.value }
    }
    
    func contains(_ element: T) -> Bool {
        return elements.contains { $0.value === element }
    }
}
