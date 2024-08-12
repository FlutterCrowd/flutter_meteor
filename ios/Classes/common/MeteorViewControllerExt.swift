//
//  UIViewControllerExtension.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/29.
//

import Foundation

private var FMAssociatedObjectHandle: UInt8 = 0

extension UIViewController {
    
    public var routeName: String? {
        get {
            let name: String = objc_getAssociatedObject(self, &FMAssociatedObjectHandle) as? String ?? self.title ?? "\(type(of: self))"
            return name
        }
        set {
            objc_setAssociatedObject(self, &FMAssociatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
