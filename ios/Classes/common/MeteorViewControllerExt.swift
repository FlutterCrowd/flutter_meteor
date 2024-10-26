//
//  MeteorViewControllerExt.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/29.
//

import Foundation

private var FMAssociatedRouteNameHandle: UInt8 = 0

private var FMAssociatedPopCallBackHandle: UInt8 = 0

public typealias FlutterMeteorPopCallBack = (_ response: Any?) -> Void

public extension UIViewController {
    // 页面路由名称
    @objc var routeName: String? {
        get {
            return objc_getAssociatedObject(self, &FMAssociatedRouteNameHandle) as? String
                        ?? String(describing: type(of: self))
        }
        set {
            objc_setAssociatedObject(self, &FMAssociatedRouteNameHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // 当页面pop或者dismiss时会调用这个回调
    @objc var popCallBack: FlutterMeteorPopCallBack? {
        get {
            return objc_getAssociatedObject(self, &FMAssociatedPopCallBackHandle) as? FlutterMeteorPopCallBack
        }
        set {
            objc_setAssociatedObject(self, &FMAssociatedPopCallBackHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UINavigationController {
    
    func popToRootViewController(animated: Bool?, 
                                 completion: @escaping () -> Void) {
        if viewControllers.first == topViewController {
            completion()
            return
        }
        guard let animated = animated, animated else {
            popToRootViewController(animated: false)
            completion()
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToRootViewController(animated: true)
        CATransaction.commit()
    }

    func pushViewController(_ viewController: UIViewController, 
                            animated: Bool?,
                            completion: @escaping () -> Void) {
        guard let animated = animated, animated else {
            pushViewController(viewController, animated: false)
            completion()
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    func popToViewController(_ viewController: UIViewController, 
                             animated: Bool?,
                             completion: @escaping () -> Void) {
        if topViewController == viewController {
            completion()
            return
        }
        guard let animated = animated, animated else {
            popToViewController(viewController, animated: false)
            completion()
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    func popViewController(animated: Bool?, 
                           completion: @escaping () -> Void) {
        guard topViewController != nil else {
            completion()
            return
        }
        guard let animated = animated, animated else {
            popViewController(animated: false)
            completion()
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: true)
        CATransaction.commit()
    }
    
    func setViewControllers(_ viewControllers: [UIViewController], 
                            animated: Bool?,
                            completion: @escaping () -> Void) {
        guard topViewController != nil else {
            completion()
            return
        }
        guard let animated = animated, animated else {
            setViewControllers(viewControllers, animated: false)
            completion()
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        setViewControllers(viewControllers, animated: animated)
        CATransaction.commit()
    }

}

