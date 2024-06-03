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
        dismissOrPop(animated: true)
//        if rootViewController()?.presentedViewController == nil {
//            topViewController()?.navigationController?.popViewController(animated: true)
//        } else {
//            topViewController()?.dismiss(animated: false, completion: nil)
//        }
    }
    
    static public func dismiss() {
        dismissOrPop(animated: true)
//        topViewController()?.dismiss(animated: true)
    }
    
    static public func popUntil(untilPage: UIViewController) {
        topViewController()?.navigationController?.popToViewController(untilPage, animated: true)
    }
    
    static public func popToRoot() {
        
        if rootViewController()?.presentedViewController == nil {
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
    
    /// 获取顶部控制器 无要求
    public static func rootViewController() -> UIViewController? {
        var window = UIApplication.shared.keyWindow
        // 是否为当前显示的window
        if ((window?.windowLevel.rawValue) != 0) {
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel.rawValue == 0{
                    window = windowTemp
                    break
                }
            }
        }

        let vc = window?.rootViewController
        return vc
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
        let vc = rootViewController()
        return getTopVC(withCurrentVC: vc)
    }
    
    public static func getTopVC(withCurrentVC VC:UIViewController?) -> UIViewController? {
        if VC == nil {
            return nil
        }
        if let presentVC = VC?.presentedViewController {
            //modal出来的 控制器
            return getTopVC(withCurrentVC: presentVC)
        }else if let tabVC = VC as? UITabBarController {
            // tabBar 的跟控制器
            if let selectVC = tabVC.selectedViewController {
                return getTopVC(withCurrentVC: selectVC)
            }
            return nil
        } else if let naiVC = VC as? UINavigationController {
            // 控制器是 nav
            return getTopVC(withCurrentVC:naiVC.visibleViewController)
        } else {
            // 返回顶控制器
            return VC
        }
    }
    
    
}
