//
//  HzNativeNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//

import UIKit

public class HzNativeNavigator: NSObject {
    
    static public func present(toPage: UIViewController) {
        topViewController()?.present(toPage, animated: true)
    }
    
    static public func push(toPage: UIViewController) {
        topViewController()?.navigationController?.pushViewController(toPage, animated: true)
    }
    
    static public func pop() {
        topViewController()?.navigationController?.popViewController(animated: true)
    }
    
    static public func popUntil(untilPage: UIViewController) {
        topViewController()?.navigationController?.popToViewController(untilPage, animated: true)
    }
    
    static public func popToRoot() {
        topViewController()?.navigationController?.popToRootViewController(animated: true)
    }
    
    static public func dismiss() {
        topViewController()?.dismiss(animated: true)
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

    /// 获取顶部控制器 无要求
    static public func topViewController() -> UIViewController? {
        return HzRouter.topViewController()
    }
    
}
