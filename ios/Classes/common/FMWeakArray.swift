//
//  WeakArray.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/12.
//

import Foundation

class Weak<T: AnyObject> {
    weak var value: T?

    init(value: T?) {
        self.value = value
    }
}

class WeakArray<T: AnyObject> {
    private var elements: [Weak<T>] = []

    func add(_ element: T) {
        elements.append(Weak(value: element))
    }

    func remove(_ element: T) {
        elements = elements.filter { $0.value !== element }
    }

    var allObjects: [T] {
        elements = elements.filter { $0.value != nil }
        return elements.compactMap { $0.value }
    }
}
