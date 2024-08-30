//
//  HzNativeNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//

import UIKit


let MeteorNavigatorAnimationDuration: Double  = 0.35;

public class MeteorNativeNavigator: NSObject {
        
    static public func present(toPage: UIViewController, 
                               animated: Bool = true) {
        guard let topVc = topViewController() else {
            print("No top view controller found")
            return
        }
        topVc.present(toPage, animated: animated) {
        }
        
    }
    
    static public func push(toPage: UIViewController, 
                            animated: Bool = true) {
        
        if toPage is UINavigationController  {
            print("=====Error: Cannot push a UINavigationController, please check your router config")
            return
        }
        
        guard let topNavi = topViewController()?.navigationController else {
            print("No top navigator controller found")
            return
        }
        topNavi.pushViewController(toPage, animated: animated)
    }
    

    static public func pop(animated: Bool = true, 
                           completion: (() -> Void)? = nil) {
        
        guard let topVc = topViewController() else {
            print("No top view controller found")
            completion?()
            return
        }
        
        func recursivePopOrDismiss(viewController: UIViewController?, completion: (() -> Void)? = nil) {
            guard let viewController = viewController else {
                completion?()
                return
            }
            if let navigationController = viewController.navigationController {
                if navigationController.viewControllers.count > 1 {
                    // 当前导航控制器中的 ViewController 大于 1，执行 pop
                    navigationController.popViewController(animated: animated)
                    completion?()
                } else {
                    if viewController == rootViewController() || navigationController == rootViewController() {
                        completion?()
                    } else {
                        recursivePopOrDismiss(viewController: navigationController, completion: completion)
                    }
                }
            } else if viewController.presentingViewController != nil {
                // 如果视图控制器是通过 present 呈现的，执行 dismiss 操作
                viewController.dismiss(animated: animated) {
                    completion?()
                }
            } else if let tabBarController = viewController.tabBarController {
                if viewController == tabBarController.selectedViewController ||
                    viewController.navigationController == tabBarController.selectedViewController {
                    recursivePopOrDismiss(viewController: tabBarController)
                } else {
                    recursivePopOrDismiss(viewController: tabBarController.selectedViewController)
                }
            } else if let parentVc = viewController.parent {
                
                guard let curentVc = parentVc.children.last(where: { $0 == viewController }) else {
                    completion?()
                        return
                    }
                // 通知 ViewControllerA 它即将被移除
                curentVc.willMove(toParent: nil)
                
                // 从视图层次结构中移除 ViewControllerA 的视图
                curentVc.view.removeFromSuperview()
                
                // 从父视图控制器中移除 ViewControllerA
                curentVc.removeFromParent()
                completion?()
               
            } else {
                print("This view controller cannot be dismissed or popped")
                completion?()
            }

        }

        recursivePopOrDismiss(viewController: topVc, completion: completion)
    }
    

//    private static func handleParentNavigationControllerPop(for navigationController: UINavigationController, 
//                                                            topVc: UIViewController, 
//                                                            animated: Bool,
//                                                            completion: (() -> Void)?
//    ) {
//        if let parentVc = navigationController.parent {
//            if let parentNavi = parentVc as? UINavigationController {
//                if parentNavi.viewControllers.count > 1 {
//                    parentNavi.popViewController(animated: animated)
//                    completion?()
//                } else {
//                    parentVc.dismiss(animated: animated, completion: completion)
//                }
//            } else if let presentedVc = navigationController.presentedViewController {
//                presentedVc.dismiss(animated: animated, completion: completion)
//            } else if let parentNavi = parentVc.navigationController {
//                if let presentedVc = parentNavi.presentedViewController {
//                    presentedVc.dismiss(animated: animated, completion: completion)
//                } else {
//                    if parentNavi.viewControllers.count > 1 {
//                        parentNavi.popViewController(animated: animated)
//                        completion?()
//                    } else {
//                        if parentNavi == rootNavigationController() {
//                            completion?()
//                        } else {
//                            parentVc.dismiss(animated: animated, completion: completion)
//                        }
//                    }
//                }
//            } else {
//                topVc.dismiss(animated: animated, completion: completion)
//            }
//        } else {
//            if let rootNavi = rootNavigationController() {
//                if (rootNavi != navigationController) {
//                    navigationController.dismiss(animated: animated, completion: completion)
//                } else {
//                    rootNavi.popViewController(animated: animated)
//                    completion?()
//                }
//            } else if let presentedVc = navigationController.presentedViewController {
//                presentedVc.dismiss(animated: animated, completion: completion)
//            }
//        }
//    }

    static public func dismiss(animated: Bool = true, 
                               completion: (() -> Void)? = nil) {
        guard let topVc = topViewController() else {
            print("No top view controller found")
            completion?()
            return
        }
        topVc.dismiss(animated: animated, completion: completion)
    }
    
    static public func popUntil(untilPage: UIViewController, 
                                animated: Bool = true,
                                completion: (() -> Void)? = nil) {
        guard let topVc = topViewController(), topVc != untilPage else {
            print("Curent viewController is untilPage, no need to popUntil")
            completion?()
            return
        }
        
        func traversePop(currentVc: UIViewController?) {
            guard let currentVc = currentVc else {
                completion?()
                return
            }
            
            if currentVc == untilPage {
                completion?()
                return
            }
            
            if let tabBarVc = currentVc as? UITabBarController ?? currentVc.tabBarController {
                if tabBarVc == untilPage {
                    (tabBarVc.selectedViewController as? UINavigationController)?.popToRootViewController(animated: animated)
                    completion?()
                    return
                }
                
                if tabBarVc.viewControllers?.contains(untilPage) == true {
                    if tabBarVc.selectedViewController != untilPage {
                        tabBarVc.selectedViewController = untilPage
                    }
                    completion?()
                    return
                }
                //untilPage的navigationController是tabBar子ViewController则
                if let navigationController = untilPage.navigationController,
                   tabBarVc.viewControllers?.contains(navigationController) == true {
                    navigationController.popToViewController(untilPage, animated: animated)
                    completion?()
                    return
                }
                traversePop(currentVc: tabBarVc)
                return
            }
            
            if let navigationController = currentVc.navigationController {
                if navigationController.viewControllers.contains(untilPage) {
                    navigationController.popToViewController(untilPage, animated: animated)
                    completion?()
                } else if navigationController.presentingViewController != nil {
                    navigationController.dismiss(animated: false) {
                        traversePop(currentVc: topViewController())
                    }
                } else if let parent = navigationController.parent {
                    traversePop(currentVc: parent)
                } else {
                    pop(animated: false) {
                        traversePop(currentVc: topViewController())
                    }
                }
                return
            }
            
            if currentVc.children.contains(untilPage) {
                completion?()
                return
            }
            
            if let presentedVc = currentVc.presentedViewController {
                presentedVc.dismiss(animated: false) {
                    traversePop(currentVc: topViewController())
                }
                return
            }

            if currentVc.presentingViewController != nil {
                currentVc.dismiss(animated: false) {
                    traversePop(currentVc: topViewController())
                }
                return
            }
            
            pop(animated: false) {
                traversePop(currentVc: topViewController())
            }
        }
        
        if let navigationController = untilPage.navigationController,  topVc.navigationController == navigationController {
            navigationController.popToViewController(untilPage, animated: animated)
            completion?()
        } else {
            traversePop(currentVc: topVc)
        }
    }

    
    static public func popToRoot(animated: Bool = true,  
                                 completion: (() -> Void)? = nil) {
        
        guard let rootVC = rootNavigationController()?.viewControllers.first else { return }
        let topVC = topViewController()
        
        if topVC == rootVC {
            completion?()
            return
        }
        if topVC?.navigationController == rootNavigationController() {
            topVC?.navigationController?.popToRootViewController(animated: animated)
            completion?()
            return
        }
        if let tabBarVC = rootVC as? UITabBarController {
            if let selectedNavVC = tabBarVC.selectedViewController as? UINavigationController {
                if selectedNavVC.topViewController != selectedNavVC.viewControllers.first {
                    selectedNavVC.popToRootViewController(animated: animated)
                    popToRoot(animated: animated, completion: completion)
                    return
                }
            } else if let selectedVC = tabBarVC.selectedViewController, selectedVC == topVC {
//                popToRoot(animated: animated)
                completion?()
                return
            }
        }
        
        if let presentedVC = rootViewController()?.presentedViewController {
            presentedVC.dismiss(animated: false) {
                popToRoot(animated: animated, completion: completion)
            }
        } else {
            rootNavigationController()?.popToRootViewController(animated: animated)
            completion?()
        }
    }
    
    static public func pushToReplacement(toPage: UIViewController, 
                                         animated: Bool = true) {
       
        if toPage is UINavigationController  {
            print("=====Error: Cannot push a UINavigationController, please check your router config")
            return
        }
        let topVc = topViewController()
        
        if let topVc = topVc,
           let topNavi = topVc.navigationController,
            topNavi.viewControllers.count <= 1  { // 当只有一个元素时无法pop，可以直接替换
            if topVc == topVc.tabBarController?.selectedViewController || topNavi == topNavi.tabBarController?.selectedViewController {
                toPage.hidesBottomBarWhenPushed = false
            }
            topNavi.setViewControllers([toPage], animated: animated)
        } else {
            pop(animated: false) { //
                push(toPage: toPage, animated: animated)
            }
        }
    }
    
    static public func pushToAndRemoveUntil(toPage: UIViewController, 
                                            untilPage: UIViewController?,
                                            animated: Bool = true) {
        
        if toPage is UINavigationController  {
            print("=====Error: Cannot push a UINavigationController, please check your router config")
            return
        }
        
        if (untilPage == nil) {
            print("untilPage is nil")
            push(toPage: toPage)
            return
        }

        let topVc = topViewController()
        if topVc != untilPage {
//            if let topView = topVc?.view, animated  {
//                // 这里临时将顶层视图覆盖到要返回的视图，避免闪屏
//                let topSuperView = topView.superview
//                untilPage?.view .addSubview(topView)
//                DispatchQueue.main.asyncAfter(deadline: .now() + MeteorNavigatorAnimationDuration) {
//                    // 在push动画完成后恢复原样
//                    topView.removeFromSuperview()
//                    topSuperView?.addSubview(topView)
//                }
//            }
            popUntil(untilPage: untilPage!, animated: false) {
                push(toPage: toPage, animated: animated)
            }
        } else {
            push(toPage: toPage, animated: animated)
        }
    }

    static public func pushToAndRemoveUntilRoot(toPage: UIViewController, 
                                                animated: Bool = true) {
        
        if toPage is UINavigationController  {
            print("=====Error: Cannot push a UINavigationController, please check your router config")
            return
        }
        
        var rootVc = rootViewController()
        let topVc = topViewController()
        
        if let rootNavi = rootVc as? UINavigationController {
            rootVc = rootNavi.viewControllers.first
        }

//        if let topView = topVc?.view, rootVc != nil {
//            // 这里临时将顶层视图覆盖到要返回的视图，避免闪屏
//            let  topSuperView = topView.superview
//            rootVc?.view .addSubview(topView)
//            DispatchQueue.main.asyncAfter(deadline: .now() + MeteorNavigatorAnimationDuration) {
//                // 在push动画完成后恢复原样
//                topView.removeFromSuperview()
//                topSuperView?.addSubview(topView)
//            }
//        }
        popToRoot(animated: false) {
            rootNavigationController()?.pushViewController(toPage, animated: animated)
        }
    }
    
    /// 获取顶部控制器
    public static func topViewController() -> UIViewController? {
        return MeteorNavigatorHelper.topViewController()
    }
    
    /// 获取根控制器
    public static func rootViewController() -> UIViewController? {
        return MeteorNavigatorHelper.rootViewController()
    }

    /// 获取根控制器
    public static func rootNavigationController() -> UINavigationController? {
        return MeteorNavigatorHelper.rootNavigationController()
        
    }
}
