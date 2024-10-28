//
//  MeteorNativeNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//

import UIKit
import Flutter

public class MeteorNativeNavigator: NSObject {
    
    // MARK: - Present & Push Navigation
    public static func present(toPage: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let topVc = topViewController() else {
            MeteorLog.error("No top view controller found")
            return
        }
        topVc.present(toPage, animated: animated) {
            completion?()
            if !(topVc is FlutterViewController) {
                MeteorNavigatorObserver.didPush(routeName: toPage.routeName!, fromRouteName: topVc.routeName!)
            }
        }
    }

    public static func push(toPage: UIViewController, animated: Bool = true) {
        if toPage is UINavigationController {
            MeteorLog.error("Cannot push a UINavigationController, please check your router config")
            return
        }
        guard let topVc = topViewController() else {
            MeteorLog.error("No top controller found")
            return
        }

        guard let topNavi = topVc.navigationController else {
            MeteorLog.error("No top navigation controller found")
            return
        }
        topNavi.pushViewController(toPage, animated: animated) {
            if !(topVc is FlutterViewController) {
                MeteorNavigatorObserver.didPush(routeName: toPage.routeName!, fromRouteName: topVc.routeName!)
            }

        }
    }

    // MARK: - Pop & Dismiss Navigation
    public static func pop(animated: Bool = true, result: Any? = nil, completion: (() -> Void)? = nil) {
        guard let topVc = topViewController() else {
            MeteorLog.error("No top view controller found")
            completion?()
            return
        }

        if MeteorNavigatorHelper.isRootViewController(viewController: topVc) {
            MeteorLog.info("Current viewController is rootPage")
            completion?()
            return
        }
        
        popOrDismiss(viewController: topVc, animated: animated) { popViewController in
            popViewController?.popCallBack?(result)
            completion?()
            MeteorNavigatorObserver.didPop(routeName:topVc.routeName!, fromRouteName: nil)
        }
    }

    public static func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let topVc = topViewController() else {
            MeteorLog.error("No top view controller found")
            completion?()
            return
        }
        if MeteorNavigatorHelper.isRootViewController(viewController: topVc) {
            MeteorLog.info("Current viewController is rootPage")
            completion?()
            return
        }
        resolvePresentOverFullScreenProblem(topVc: topVc, animated: animated) {
            completion?()
            MeteorNavigatorObserver.didPop(routeName:topVc.routeName!, fromRouteName: nil)
        }
    }

    // MARK: - Pop Until Specific Page
    public static func popUntil(untilPage: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let topVc = topViewController(), topVc != untilPage else {
            MeteorLog.info("Current viewController is untilPage, no need to popUntil")
            completion?()
            return
        }
        recursivePopUntil(untilPage: untilPage, animated: animated, completion: completion)
    }

   // MARK: - Pop to Root
    public static func popToRoot(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let rootVC = rootNavigationController()?.viewControllers.first else {
            completion?()
            return
        }
        let topVC = topViewController()
        
        // 判断是否已经在根视图控制器
        if topVC == rootVC {
            completion?()
            return
        }
        
        // 如果 topVC 在根导航控制器中，则 pop 到根视图控制器
        if let navigationController = topVC?.navigationController,
           navigationController == rootNavigationController() {
            navigationController.popToRootViewController(animated: animated) {
                completion?()
            }
            return
        }
        
        // 如果根视图控制器是 UITabBarController
        if let tabBarVC = rootVC as? UITabBarController {
            // 如果选中的视图控制器为顶层视图控制器
            if tabBarVC.selectedViewController == topVC {
                completion?()
                return
            }
            // 如果选中的导航控制器等于topVC，pop
            if let selectedNavVC = tabBarVC.selectedViewController as? UINavigationController,
               selectedNavVC.viewControllers.contains(topVC!) {
                if topVC == selectedNavVC.viewControllers.first {
                    completion?()
                    return
                } else {
                    selectedNavVC.popToRootViewController(animated: animated) {
                        completion?()
                        return
                    }
                }
                return
            }
        }
        
        // 如果有模态视图控制器被展示，先 dismiss 再调用 popToRoot
        if let presentedVC = rootViewController()?.presentedViewController {
            presentedVC.dismiss(animated: false) {
                popToRoot(animated: animated, completion: completion)
            }
        } else {
            popOrDismiss(viewController: topVC, animated: false) { _ in
                popToRoot(animated: animated, completion: completion)
            }
        }
    }

    // MARK: - Push with Replacement
    public static func pushToReplacement(toPage: UIViewController, animated: Bool = true) {
        guard !(toPage is UINavigationController) else {
            MeteorLog.error("Cannot push a UINavigationController, please check your router config")
            return
        }
        
        guard let topVc = topViewController() else {
            MeteorLog.error("No topVc, please check your router config")
            return
        }

        if let topNavi = topVc.navigationController,
            topNavi.viewControllers.count <= 1 {
            handleSinglePageReplacement(topVc: topVc, toPage: toPage, animated: animated) {
                MeteorNavigatorObserver.didRplace(routeName:topVc.routeName!, fromRouteName: toPage.routeName!)
            }
        } else {
            pop(animated: false) {
                push(toPage: toPage, animated: animated)
                MeteorNavigatorObserver.didRplace(routeName:topVc.routeName!, fromRouteName: toPage.routeName!)
            }
        }
    }
    
    // MARK: - Push and remove
    public static func pushToAndRemoveUntil(toPage: UIViewController,
                                            untilPage: UIViewController?,
                                            animated: Bool = true)
    {
        if toPage is UINavigationController {
            MeteorLog.error("Cannot push a UINavigationController, please check your router config")
            return
        }

        if untilPage == nil {
            MeteorLog.warning("untilPage is nil")
            push(toPage: toPage)
            return
        }

        let topVc = topViewController()
        if topVc != untilPage {
            popUntil(untilPage: untilPage!, animated: false) {
                push(toPage: toPage, animated: animated)
            }
        } else {
            push(toPage: toPage, animated: animated)
        }
    }
    
    public static func pushToAndRemoveUntilRoot(toPage: UIViewController,
                                                animated: Bool = true,
                                                completion: (() -> Void)? = nil)
    {
        if toPage is UINavigationController {
            MeteorLog.error("Cannot push a UINavigationController, please check your router config")
            return
        }

        var rootVc = rootViewController()
        if let rootNavi = rootVc as? UINavigationController {
            rootVc = rootNavi.viewControllers.first
        }
        popToRoot(animated: false) {
            rootNavigationController()?.pushViewController(toPage, animated: animated, completion: {
                completion?()
            })
        }
    }

    // MARK: - Helper Methods
    private static func popOrDismiss(viewController: UIViewController?,
                                     animated: Bool,
                                     completion: ((_ popViewController: UIViewController?) -> Void)? = nil) {
        guard let viewController = viewController else {
            completion?(nil)
            return
        }
        
        if MeteorNavigatorHelper.isRootViewController(viewController: viewController) {
            MeteorLog.warning("Current viewController is rootPage")
            completion?(viewController)
            return
        }

        // 优先处理 navigationController 的 pop 操作
        if let navigationController = viewController.navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: animated) {
                    completion?(viewController)
                }
            } else {
                // 当 navigationController 只有一个页面时，尝试 popOrDismiss navigationController 本身
                popOrDismiss(viewController: navigationController, animated: animated, completion: completion)
            }
            return
        }
        
        // 如果是被模态呈现的视图控制器，执行 dismiss 操作
        if viewController.presentingViewController != nil {
            resolvePresentOverFullScreenProblem(topVc: viewController, animated: animated) {
                completion?(viewController)
            }
            return
        }
        
        // 处理在 tabBarController 中的情况
        if let tabBarVc = viewController.tabBarController, 
            let tabBarControllers = tabBarVc.viewControllers {
            if tabBarControllers.contains(viewController) {
                popOrDismiss(viewController: tabBarVc, animated: animated, completion: completion)
            } else if let navi = viewController.navigationController, 
                        tabBarControllers.contains(navi) {
                if navi.viewControllers.count > 1 {
                    navi.popViewController(animated: animated) {
                        completion?(viewController)
                    }
                } else {
                    popOrDismiss(viewController: tabBarVc, animated: animated, completion: completion)
                }
            }
            return
        }

        // 如果是 child view controller，则移除子控制器
        if let parent = viewController.parent {
            removeChildViewController(parent: parent, child: viewController, completion: completion)
        } else {
            // 无法 pop 或 dismiss 时记录错误
            MeteorLog.warning("View controller cannot be dismissed or popped")
            completion?(viewController)
        }
    }


    private static func recursivePopUntil(untilPage: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard let topVc = topViewController() else {
            completion?()
            return
        }

        if topVc == untilPage || MeteorNavigatorHelper.isRootViewController(viewController: topVc) {
            completion?()
            return
        }
        
        if let topNavi = topVc.navigationController,
           topNavi.viewControllers.contains(untilPage) {
            topNavi.popToViewController(untilPage, animated: animated, completion: {
                completion?()
            })
            return
        }
      
        pop(animated: false) {
            recursivePopUntil(untilPage: untilPage, animated: animated, completion: completion)
        }
    }

    private static func handleSinglePageReplacement(topVc: UIViewController, 
                                                    toPage: UIViewController,
                                                    animated: Bool,
                                                    completion: (() -> Void)?) {
        if topVc == topVc.tabBarController?.selectedViewController || topVc.navigationController == topVc.tabBarController?.selectedViewController {
            toPage.hidesBottomBarWhenPushed = false
        }
        topVc.navigationController?.setViewControllers([toPage], animated: animated){
            completion?()
        }
    }

    private static func removeChildViewController(parent: UIViewController, child: UIViewController, completion: ((_ popViewController: UIViewController?) -> Void)?) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
        completion?(child)
    }
    
    /// 处理present特殊情况
    static func resolvePresentOverFullScreenProblem(topVc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        if (topVc.modalPresentationStyle == .overFullScreen) {
            //这里分为两种情况，由于UIModalPresentationOverFullScreen下，生命周期显示会有问题
            //所以需要手动调用的场景，从而使下面底部的vc调用viewAppear相关逻辑
            
            //这里手动beginAppearanceTransition触发页面生命周期
            var bottomVC = topVc.presentingViewController
            if let nav = bottomVC as? UINavigationController {
                bottomVC = nav.topViewController
            }
            bottomVC?.beginAppearanceTransition(true, animated: false)
            
            topVc.dismiss(animated: animated) {
                bottomVC?.endAppearanceTransition()
                completion?()
            }
        } else {
            topVc.dismiss(animated: animated, completion: completion)
        }
    }

    // MARK: - View Controller Access
    public static func topViewController() -> UIViewController? {
        return MeteorNavigatorHelper.topViewController()
    }

    public static func rootViewController() -> UIViewController? {
        return MeteorNavigatorHelper.rootViewController()
    }

    public static func rootNavigationController() -> UINavigationController? {
        return MeteorNavigatorHelper.rootNavigationController()
    }
}
