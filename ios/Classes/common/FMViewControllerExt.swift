//
//  FMViewControllerExt.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/12.
//

import UIKit

private var AssociatedObjectHandle: UInt8 = 0

extension UIViewController {
    
    public var routeName: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public static let swizzlePresentation: Void = {
        let originalPresent = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.present(_:animated:completion:)))
        let swizzledPresent = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.swizzled_present(_:animated:completion:)))
        method_exchangeImplementations(originalPresent!, swizzledPresent!)
        
        let originalDismiss = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.dismiss(animated:completion:)))
        let swizzledDismiss = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.swizzled_dismiss(animated:completion:)))
        method_exchangeImplementations(originalDismiss!, swizzledDismiss!)
    }()
    
    @objc func swizzled_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        swizzled_present(viewControllerToPresent, animated: flag) {
            completion?()
            FMRouterManager.shared.updateViewControllerStack()
        }
    }
    
    @objc func swizzled_dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        swizzled_dismiss(animated: flag) {
            completion?()
            FMRouterManager.shared.updateViewControllerStack()
        }
    }
}

