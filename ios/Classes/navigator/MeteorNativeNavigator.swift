//
//  HzNativeNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//

import UIKit



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

        if let navigationController = topVc.navigationController {
            if navigationController.viewControllers.count > 1 {
                // 当前导航控制器中的 ViewController 大于 1，执行 pop
                navigationController.popViewController(animated: animated)
                completion?()
            } else {
                if navigationController == rootNavigationController() {
                    completion?()
                } else {
                    // 当前导航控制器中的 ViewController 小于或等于 1，需要依赖父导航控制器或根导航控制器
                    handleParentNavigationControllerPop(for: navigationController, topVc: topVc, animated: animated, completion: completion)
                }
            }
        } else if let presentedVc = topVc.presentedViewController {
            // 如果视图控制器是通过 present 呈现的，执行 dismiss 操作
            presentedVc.dismiss(animated: animated) {
                completion?()
            }
        } else if(topVc != rootViewController()) {
            // 没有导航控制器或呈现控制器，可能是根视图控制器
            topVc.dismiss(animated: animated, completion: completion)
        } else {
            print("This view controller cannot be dismissed or popped")
            completion?()
        }
    }
    

    private static func handleParentNavigationControllerPop(for navigationController: UINavigationController, 
                                                            topVc: UIViewController, 
                                                            animated: Bool,
                                                            completion: (() -> Void)?
    ) {
        if let parentVc = navigationController.parent {
            if let parentNavi = parentVc as? UINavigationController {
                if parentNavi.viewControllers.count > 1 {
                    parentNavi.popViewController(animated: animated)
                    completion?()
                } else {
                    parentVc.dismiss(animated: animated, completion: completion)
                }
            } else if let presentedVc = navigationController.presentedViewController {
                presentedVc.dismiss(animated: animated, completion: completion)
            } else if let parentNavi = parentVc.navigationController {
                if let presentedVc = parentNavi.presentedViewController {
                    presentedVc.dismiss(animated: animated, completion: completion)
                } else {
                    if parentNavi.viewControllers.count > 1 {
                        parentNavi.popViewController(animated: animated)
                        completion?()
                    } else {
                        if parentNavi == rootNavigationController() {
                            completion?()
                        } else {
                            parentVc.dismiss(animated: animated, completion: completion)
                        }
                    }
                }
            } else {
                topVc.dismiss(animated: animated, completion: completion)
            }
        } else {
            if let rootNavi = rootNavigationController() {
                if (rootNavi != navigationController) {
                    navigationController.dismiss(animated: animated, completion: completion)
                } else {
                    rootNavi.popViewController(animated: animated)
                    completion?()
                }
            } else if let presentedVc = navigationController.presentedViewController {
                presentedVc.dismiss(animated: animated, completion: completion)
            }
        }
    }

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
            print("Curent viewController is self, no need to popUntil")
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
            
            if let tabBarVc = currentVc.tabBarController {
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
                
                if let navigationController = untilPage.navigationController,
                   tabBarVc.viewControllers?.contains(navigationController) == true {
                    navigationController.popToViewController(untilPage, animated: animated)
                    completion?()
                    return
                }
                
                traversePop(currentVc: tabBarVc)
                return
            }
            
            if let presentedVc = currentVc.presentedViewController {
                presentedVc.dismiss(animated: false) {
                    traversePop(currentVc: topViewController())
                }
                return
            }
            
            if let navigationController = currentVc.navigationController {
                if navigationController.viewControllers.contains(untilPage) {
                    navigationController.popToViewController(untilPage, animated: animated)
                    completion?()
                } else {
                    navigationController.dismiss(animated: false) {
                        traversePop(currentVc: topViewController())
                    }
                }
                return
            }
            
            currentVc.dismiss(animated: false) {
                traversePop(currentVc: topViewController())
            }
        }
        
        if topVc.navigationController != untilPage.navigationController {
            traversePop(currentVc: topVc)
        } else if let navigationController = untilPage.navigationController {
            navigationController.popToViewController(untilPage, animated: animated)
            completion?()
        } else {
            untilPage.dismiss(animated: animated, completion: completion)
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

    static public func beforePushToReplacement(completion: (() -> Void)? = nil) {
        pop(animated: false) { //
            completion?()
        }
    }
    
    
    static public func pushToReplacement(toPage: UIViewController, 
                                         animated: Bool = true) {
       
        if toPage is UINavigationController  {
            print("=====Error: Cannot push a UINavigationController, please check your router config")
            return
        }
        if let topVc = topViewController(),
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
    
    static public func beforePushToRemoveUntil(untilPage: UIViewController?,
                                               animated: Bool = true,
                                               completion: (() -> Void)? = nil) {
        
        if (untilPage == nil) {
            print("untilPage is nil")
           completion?()
            return
        }

        let topVc = topViewController()
        if topVc != untilPage {
            if let topView = topVc?.view, animated  {
                // 这里临时将顶层视图覆盖到要返回的视图，避免闪屏
                let topSuperView = topView.superview
                untilPage?.view .addSubview(topView)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    // 在push动画完成后恢复原样
                    topView.removeFromSuperview()
                    topSuperView?.addSubview(topView)
                }
            }
            popUntil(untilPage: untilPage!, animated: false) {
                completion?()
            }
        } else {
            completion?()
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
            if let topView = topVc?.view, animated  {
                // 这里临时将顶层视图覆盖到要返回的视图，避免闪屏
                let topSuperView = topView.superview
                untilPage?.view .addSubview(topView)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    // 在push动画完成后恢复原样
                    topView.removeFromSuperview()
                    topSuperView?.addSubview(topView)
                }
            }
            popUntil(untilPage: untilPage!, animated: false) {
                push(toPage: toPage, animated: animated)
            }
        } else {
            push(toPage: toPage, animated: animated)
        }
    }
    
    static public func beforePushToAndRemoveUntilRoot(animated: Bool = true,
                                                      completion: (() -> Void)? = nil) {
        
        var rootVc = rootViewController()
        let topVc = topViewController()
        
        if let rootNavi = rootVc as? UINavigationController {
            rootVc = rootNavi.viewControllers.first
        }

        if let topView = topVc?.view, 
            rootVc != nil, animated {
            // 这里临时将顶层视图覆盖到要返回的视图，避免闪屏
            let  topSuperView = topView.superview
            rootVc?.view .addSubview(topView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                // 在push动画完成后恢复原样
                topView.removeFromSuperview()
                topSuperView?.addSubview(topView)
            }
        }
        popToRoot(animated: false) {
            completion?()
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

        if let topView = topVc?.view, rootVc != nil {
            // 这里临时将顶层视图覆盖到要返回的视图，避免闪屏
            let  topSuperView = topView.superview
            rootVc?.view .addSubview(topView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                // 在push动画完成后恢复原样
                topView.removeFromSuperview()
                topSuperView?.addSubview(topView)
            }
        }
        popToRoot(animated: false) {
            rootNavigationController()?.pushViewController(toPage, animated: animated)
        }
    }
    
    /// 获取顶部控制器
    public static func topViewController() -> UIViewController? {
        return MeteorRouterHelper.topViewController()
    }
    
    /// 获取根控制器
    public static func rootViewController() -> UIViewController? {
        return MeteorRouterHelper.rootViewController()
    }

    /// 获取根控制器
    public static func rootNavigationController() -> UINavigationController? {
        return MeteorRouterHelper.rootNavigationController()
        
    }
}
