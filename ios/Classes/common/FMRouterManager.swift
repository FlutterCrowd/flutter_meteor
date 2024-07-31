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
    
    // 获取当前展示的视图控制器栈
    static func _currentRouteStack(from rootViewController: UIViewController) -> [UIViewController] {
        var vcStack: [UIViewController] = []
        
        // 定义一个闭包，用于添加视图控制器到 vcStack
            let addViewControllerIfNeeded: (UIViewController) -> Void = { viewController in
                if !vcStack.contains(where: { $0 === viewController }) {
                    vcStack.append(viewController)
                }
            }
        
        // 递归查找视图控制器
        func traverse(_ viewController: UIViewController) {
            
            if let navController = viewController as? UINavigationController  {// 如果当前是一个导航控制器啊，且其视图栈不为空
                for childViewController in navController.viewControllers {// 添加所有视图控制器
                    addViewControllerIfNeeded(childViewController)
                }
            
                if let topViewController = navController.topViewController { // 递归找到最上层视图控制器
                    traverse(topViewController)
                }
                         
            } else {
                addViewControllerIfNeeded(viewController)
                if let tabBarVc = viewController as? UITabBarController,
                   let selectedVc = tabBarVc.selectedViewController {  // 如果是UITabBarController，且有选中的VC
                    traverse(selectedVc)
                    
                } else {
                    if !viewController.children.isEmpty { // 普通VC遍历所有子VC
                        for childViewController in viewController.children {
                            addViewControllerIfNeeded(childViewController)
                        }
                        /*
                         WARNING: 这段代码逻辑需要优化
                         注意：这里获取最后一个VC比较简单粗暴。
                         */
                        traverse(viewController.children.last!) // 递归最后一个VC
                    }
                }
            }
            if let presentedViewController = viewController.presentedViewController { // 处理模态出来的视图控制器
                traverse(presentedViewController)
            }
        }

        traverse(rootViewController)
        return vcStack
    }
//    
    
    
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
    
    /// 获取根控制器
    public static func rootNavigationController() -> UINavigationController? {
        let rootVc = self.rootViewController()
        if(rootVc is UINavigationController) {
            return rootVc as? UINavigationController
        }
        return rootVc?.navigationController
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
