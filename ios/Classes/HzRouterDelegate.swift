//
//  HzRouterDelegate.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/8.
//

import Foundation

public protocol HzRouterDelegate {
    func present(viewController: UIViewController);
    
    func push(viewController: UIViewController);
     
    func pop();
     
    func popToRoot();
     
    func dismiss();
}


public extension HzRouterDelegate {
    func present(viewController: UIViewController) {
        topViewController()?.present(viewController, animated: true, completion: nil)
    }
    
    func push(viewController: UIViewController) {
        topViewController()?.navigationController?.pushViewController(viewController, animated: true)
        
    }
     
    func pop() {
        topViewController()?.navigationController?.popViewController(animated: true)
     }
    
    func pop(toPage: Any?) {
        if (toPage is UIViewController) {
            topViewController()?.navigationController?.popToViewController(toPage as! UIViewController, animated: true)
        } else {
            topViewController()?.navigationController?.popViewController(animated: true)
        }
     }
     
     func popToRoot() {
         topViewController()?.navigationController?.popToRootViewController(animated: true)
     }
     
     func dismiss() {
         topViewController()?.dismiss(animated: true)
     }
    
    /// 获取顶部控制器 无要求
    func topViewController() -> UIViewController? {
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
        return getTopVC(withCurrentVC: vc)
    }
    
    func getTopVC(withCurrentVC VC:UIViewController?) -> UIViewController? {
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

