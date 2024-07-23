//
//  HzNativeNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//

import UIKit

public class FMNativeNavigator: NSObject {
    
    static public func present(toPage: UIViewController) {
        topViewController()?.present(toPage, animated: true)
    }
    
    static public func push(toPage: UIViewController) {
        topViewController()?.navigationController?.pushViewController(toPage, animated: true)
    }
    
    static public func pop() {
        dismissOrPop(animated: false)
    }
    
    static public func dismiss() {
        dismissOrPop(animated: true)
    }
    
    static public func popUntil(untilPage: UIViewController) {
        topViewController()?.navigationController?.popToViewController(untilPage, animated: true)
    }
    
    static public func popToRoot() {
        
        if FMRouterManager.rootViewController()?.presentedViewController == nil {
            topViewController()?.navigationController?.popToRootViewController(animated: true)
        } else {
            topViewController()?.dismiss(animated: false, completion: {
                popToRoot()
            })
        }
    }
    
    static public func pushToReplacement(toPage: UIViewController) {
                
        let naviVc: UINavigationController? =  topViewController()?.navigationController
        naviVc?.pushViewController(toPage, animated: true)
        let count: Int = naviVc?.viewControllers.count ?? 0
        if (count >= 2) {
            naviVc?.viewControllers.remove(at: count - 2)
        }
    }
    
    static public func pushToAndRemoveUntil(toPage: UIViewController, untilPage: UIViewController?) {
        let naviVc: UINavigationController? =  topViewController()?.navigationController
        naviVc?.pushViewController(toPage, animated: true)
        let count: Int = naviVc?.viewControllers.count ?? 0
        if (count >= 2) {
            naviVc?.viewControllers.removeSubrange(Range<Int>(NSRange.init(location: 0, length: count - 1))!)
        }
    }
    
    static func dismissOrPop(animated: Bool) {
        let viewController = topViewController()
        if let navigationController = viewController?.navigationController {
            if navigationController.viewControllers.first != viewController {
                // 如果视图控制器不是导航堆栈中的根视图控制器，则执行 pop 操作
                navigationController.popViewController(animated: animated)
            } else {
                // 如果是根视图控制器，则执行 dismiss 操作
                viewController?.dismiss(animated: animated, completion: nil)
            }
        } else if viewController?.presentingViewController != nil {
            // 如果视图控制器是通过 present 呈现的，则执行 dismiss 操作
            viewController?.dismiss(animated: animated, completion: nil)
        } else {
            // 没有导航控制器或呈现控制器，可能是根视图控制器
            print("This view controller cannot be dismissed or popped")
        }
    }
    
    /// 获取顶部控制器 无要求
    public static func topViewController() -> UIViewController? {
        return FMRouterManager.topViewController()
    }

}
