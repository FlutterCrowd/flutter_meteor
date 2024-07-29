//
//  FMViewControllerExt.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/12.
//
//  此扩展用于hook ViewController的 present 和 dismmiss方法，便于监听路由变化

import UIKit
import ObjectiveC


extension UIViewController {
    
    public static let swizzlePresentation: Void = {
        // Ensure original and swizzled methods exist
        guard let originalPresent = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.present(_:animated:completion:))),
              let swizzledPresent = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.swizzled_present(_:animated:completion:))),
              let originalDismiss = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.dismiss(animated:completion:))),
              let swizzledDismiss = class_getInstanceMethod(UIViewController.self, #selector(UIViewController.swizzled_dismiss(animated:completion:))) else {
            print("Swizzling failed: methods not found")
            return
        }
        
        // Perform method swizzling
        method_exchangeImplementations(originalPresent, swizzledPresent)
        method_exchangeImplementations(originalDismiss, swizzledDismiss)
        
        print("Method swizzling completed successfully")
    }()
    
    @objc func swizzled_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        // Call the original present method
        swizzled_present(viewControllerToPresent, animated: flag) {
            completion?()
            FMNavigatorObserver.shared.updateViewControllerStack()
            print("swizzled_present: \(viewControllerToPresent)")
        }
    }
    
    @objc func swizzled_dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        // Call the original dismiss method
        swizzled_dismiss(animated: flag) {
            completion?()
            FMNavigatorObserver.shared.updateViewControllerStack()
            print("swizzled_dismiss: \(self)")
        }
    }
}

// Ensure swizzling happens once
extension UIViewController {
    public static let fmInitializeSwizzling: Void = {
        UIViewController.swizzlePresentation
    }()
}

