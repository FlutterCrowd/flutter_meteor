//
//  FMRouterManager.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/29.
//

import UIKit

public class FMRouterManager: NSObject {
    
    public static var viewControllerStack: [UIViewController] {
        get{
            return currentRouteStack()
        }
    }
    
    // 获取当前应用中的所有视图控制器
   static func currentRouteStack() -> [UIViewController] {
        guard let rootViewController = self.rootViewController() else {
            return []
        }
        return _currentRouteStack(from: rootViewController)
    }
    
    
//    // 递归遍历视图控制器层次结构
//    private static func _currentRouteStack(from rootViewController: UIViewController) -> [UIViewController] {
//        var currentRouteStack: [UIViewController] = []
//        
//        if let navigationController = rootViewController as? UINavigationController {
//            for viewController in navigationController.viewControllers {
//                currentRouteStack.append(contentsOf: _currentRouteStack(from: viewController))
//            }
//        } else {
//            if !currentRouteStack.contains(rootViewController) {
//                currentRouteStack.append(rootViewController)
//            }
//            if let tabBarController = rootViewController as? UITabBarController {
//                if let seletedVc = tabBarController.selectedViewController {
//                    currentRouteStack.append(contentsOf: _currentRouteStack(from: seletedVc))
//                } else {
//                    for viewController in tabBarController.viewControllers ?? [] {
//                        currentRouteStack.append(contentsOf: _currentRouteStack(from: viewController))
//                    }
//                }
//            } else {
//                for childViewController in rootViewController.children {
//                    currentRouteStack.append(contentsOf: _currentRouteStack(from: childViewController))
//                }
//            }
//        }
//        if let presentedViewController = rootViewController.presentedViewController {
//            currentRouteStack.append(contentsOf: _currentRouteStack(from: presentedViewController))
//        }
//        return currentRouteStack
//    }
//    
    static func _currentRouteStack(from rootViewController: UIViewController) -> [UIViewController] {
        var allViewControllers: [UIViewController] = []
        func traverse(_ viewController: UIViewController) {
            if let naviVc = viewController as? UINavigationController  {
                if !naviVc.viewControllers.isEmpty  {
                    for childViewController in naviVc.viewControllers {
                        if !allViewControllers.contains(childViewController) {
                            allViewControllers.append(childViewController)
                        }
                    }
                    traverse(naviVc.viewControllers.last!)
                } else {
                    if let presentedViewController = viewController.presentedViewController {
                        traverse(presentedViewController)
                    }
                }
         
            } else if let tabBarVc = viewController as? UITabBarController {
                if !allViewControllers.contains(viewController) {
                    allViewControllers.append(viewController)
                }

                if let selectedVc = tabBarVc.selectedViewController {
                    traverse(selectedVc)
                } else if !tabBarVc.children.isEmpty {
                    for childViewController in viewController.children {
                        if !allViewControllers.contains(childViewController) {
                            allViewControllers.append(childViewController)
                        }
                    }
                    traverse(tabBarVc.children.last!)
                } else {
                    if let presentedViewController = viewController.presentedViewController {
                        traverse(presentedViewController)
                    }
                }
            } else {
                if !allViewControllers.contains(viewController) {
                    allViewControllers.append(viewController)
                }
                
                if !viewController.children.isEmpty {
                    for childViewController in viewController.children {
                        if !allViewControllers.contains(childViewController) {
                            allViewControllers.append(childViewController)
                        }
                    }
                    traverse(viewController.children.last!)
                } else {
                    if let presentedViewController = viewController.presentedViewController {
                        traverse(presentedViewController)
                    }
                }
            }
        }

        traverse(rootViewController)
        return allViewControllers
    }
    
    /// 获取顶部控制器
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
    
    /// 获取顶部控制器 无要求
    public static func topViewController() -> UIViewController? {
        let vc = rootViewController()
        return getTopVC(withCurrentVC: vc)
    }
    
    public static func getTopVC(withCurrentVC VC: UIViewController?) -> UIViewController? {
        guard let currentVC = VC else {
            return nil
        }
        
        if let presentedVC = currentVC.presentedViewController {
            // Modal出来的控制器
            return getTopVC(withCurrentVC: presentedVC)
        } else if let tabVC = currentVC as? UITabBarController {
            // tabBar 的根控制器
            if let selectedVC = tabVC.selectedViewController {
                return getTopVC(withCurrentVC: selectedVC)
            }
            return tabVC
        } else if let navVC = currentVC as? UINavigationController {
            // 控制器是导航控制器
            return getTopVC(withCurrentVC: navVC.visibleViewController)
        } else {
            // 返回顶层控制器
            return currentVC
        }
    }
    
    // 获取当前应用中的所有视图控制器
   static func allViewControllers() -> [UIViewController] {
        guard let rootViewController = self.rootViewController() else {
            return []
        }
        return allViewControllers(from: rootViewController)
    }

    // 递归遍历视图控制器层次结构
    private static func allViewControllers(from rootViewController: UIViewController) -> [UIViewController] {
        var viewControllers = [rootViewController]
        
        if let presentedViewController = rootViewController.presentedViewController {
            viewControllers.append(contentsOf: allViewControllers(from: presentedViewController))
        }
        
        if let navigationController = rootViewController as? UINavigationController {
            for viewController in navigationController.viewControllers {
                viewControllers.append(contentsOf: allViewControllers(from: viewController))
            }
        } else if let tabBarController = rootViewController as? UITabBarController {
            for viewController in tabBarController.viewControllers ?? [] {
                viewControllers.append(contentsOf: allViewControllers(from: viewController))
            }
        } else {
            for childViewController in rootViewController.children {
                viewControllers.append(contentsOf: allViewControllers(from: childViewController))
            }
        }
        
        return viewControllers
    }
    
}
