//
//  HzNativeNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//

import UIKit

class HzNativeNavigator: NSObject, HzRouterDelegate {
    
    typealias Page = UIViewController

    func present(toPage: UIViewController, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        topViewController()?.present(toPage, animated: true)
    }
    
    func push(toPage: UIViewController, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        topViewController()?.navigationController?.pushViewController(toPage, animated: true)
    }
    
    func pop(arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        topViewController()?.navigationController?.popViewController(animated: true)
    }
    
    func popUntil(untilPage: UIViewController, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        topViewController()?.navigationController?.popToViewController(untilPage, animated: true)
    }
    
    func popToRoot(arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        topViewController()?.navigationController?.popToRootViewController(animated: true)
    }
    
    func dismiss(arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        topViewController()?.dismiss(animated: true)
    }
    
    func pushToReplacement(toPage: UIViewController, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
                
        let naviVc: UINavigationController? =  topViewController()?.navigationController
        naviVc?.pushViewController(toPage, animated: true)
        let count: Int = naviVc?.viewControllers.count ?? 0
        if (count >= 2) {
            naviVc?.viewControllers.remove(at: count - 2)
        }
    }
    
    func pushToAndRemoveUntil(toPage: UIViewController, untilPage: UIViewController?, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        let naviVc: UINavigationController? =  topViewController()?.navigationController
        naviVc?.pushViewController(toPage, animated: true)
        let count: Int = naviVc?.viewControllers.count ?? 0
        if (count >= 2) {
            naviVc?.viewControllers.removeSubrange(Range<Int>(NSRange.init(location: 0, length: count - 1))!)
        }
    }

    /// 获取顶部控制器 无要求
    func topViewController() -> UIViewController? {
        return HzRouter.topViewController()
    }
    
}
