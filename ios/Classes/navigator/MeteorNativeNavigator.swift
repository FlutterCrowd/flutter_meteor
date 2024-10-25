//
//  MeteorNativeNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//

import UIKit

let MeteorNavigatorAnimationDuration: Double = 0.35

//public class MeteorNativeNavigator: NSObject {
//    public static func present(toPage: UIViewController,
//                               animated: Bool = true, 
//                               completion: (() -> Void)? = nil)
//    {
//        guard let topVc = topViewController() else {
//            print("No top view controller found")
//            return
//        }
//        topVc.present(toPage, animated: animated, completion: completion)
//    }
//
//    public static func push(toPage: UIViewController,
//                            animated: Bool = true)
//    {
//        if toPage is UINavigationController {
//            print("=====Error: Cannot push a UINavigationController, please check your router config")
//            return
//        }
//
//        guard let topNavi = topViewController()?.navigationController else {
//            print("No top navigator controller found")
//            return
//        }
//        topNavi.pushViewController(toPage, animated: animated)
//    }
//
//    public static func pop(animated: Bool = true,
//                           completion: ((_ popViewController: UIViewController?) -> Void)? = nil)
//    {
//        guard let topVc = topViewController() else {
//            print("No top view controller found")
//            completion?(nil)
//            return
//        }
//
//        if MeteorNavigatorHelper.isRootViewController(viewController: topVc) {
//            print("Current viewController is rootPage")
//            completion?(nil)
//            return
//        }
//        
//        func recursivePopOrDismiss(viewController: UIViewController?, completion: ((_ popViewController: UIViewController?) -> Void)? = nil) {
//            
//            guard let viewController = viewController else {
//                completion?(viewController)
//                return
//            }
//            if let navigationController = viewController.navigationController {
//                if navigationController.viewControllers.count > 1 {
//                    // 当前导航控制器中的 ViewController 大于 1，执行 pop
//                    navigationController.popViewController(animated: animated)
//                    completion?(viewController)
//                } else {
//                    if viewController == rootViewController() || navigationController == rootViewController() {
//                        completion?(viewController)
//                    } else {
//                        recursivePopOrDismiss(viewController: navigationController, completion: completion)
//                    }
//                }
//            } else if viewController.presentingViewController != nil {
//                // 如果视图控制器是通过 present 呈现的，执行 dismiss 操作
//                resolvePresentOverFullScreenProblem(topVc: viewController, animated: animated) {
//                    completion?(viewController)
//                }
//            } else if let tabBarController = viewController.tabBarController {
//                if viewController == tabBarController.selectedViewController ||
//                    viewController.navigationController == tabBarController.selectedViewController
//                {
//                    recursivePopOrDismiss(viewController: tabBarController)
//                } else {
//                    recursivePopOrDismiss(viewController: tabBarController.selectedViewController)
//                }
//            } else if let parentVc = viewController.parent {
//                guard let curentVc = parentVc.children.last(where: { $0 == viewController }) else {
//                    completion?(viewController)
//                    return
//                }
//                // 通知 ViewControllerA 它即将被移除
//                curentVc.willMove(toParent: nil)
//
//                // 从视图层次结构中移除 ViewControllerA 的视图
//                curentVc.view.removeFromSuperview()
//
//                // 从父视图控制器中移除 ViewControllerA
//                curentVc.removeFromParent()
//                completion?(viewController)
//            } else {
//                print("This view controller cannot be dismissed or popped")
//                completion?(viewController)
//            }
//        }
//        recursivePopOrDismiss(viewController: topVc, completion: completion)
//    }
//
//    public static func dismiss(animated: Bool = true,
//                               completion: (() -> Void)? = nil)
//    {
//        guard let topVc = topViewController() else {
//            print("No top view controller found")
//            completion?()
//            return
//        }
//        if MeteorNavigatorHelper.isRootViewController(viewController: topVc) {
//            print("Current viewController is rootPage")
//            completion?()
//            return
//        }
//        resolvePresentOverFullScreenProblem(topVc: topVc, animated: animated, completion: completion)
//    }
//
//    public static func popUntil(untilPage: UIViewController,
//                                animated: Bool = true,
//                                completion: (() -> Void)? = nil)
//    {
//        guard let topVc = topViewController(), topVc != untilPage else {
//            print("Current viewController is untilPage, no need to popUntil")
//            completion?()
//            return
//        }
//
////        func dismissOrTraverse(currentVc: UIViewController?, completion: (() -> Void)? = nil) {
////            guard let currentVc = currentVc else {
////                completion?()
////                return
////            }
////            if let presentedVc = currentVc.presentedViewController {
////                presentedVc.dismiss(animated: false) {
////                    traversePop(currentVc: topViewController())
////                }
////            } else if currentVc.presentingViewController != nil {
////                currentVc.dismiss(animated: false) {
////                    traversePop(currentVc: topViewController())
////                }
////            } else {
////                traversePop(currentVc: topViewController())
////            }
////        }
////
//        func traversePop(currentVc: UIViewController?) {
//            guard let currentVc = currentVc else {
//                completion?()
//                return
//            }
//
//            if currentVc == untilPage {
//                completion?()
//                return
//            }
//            
//            if MeteorNavigatorHelper.isRootViewController(viewController: currentVc) {
//                print("Current viewController is rootPage, no need to popUntil")
//                completion?()
//                return
//            }
//            
//            pop(animated: false) { popViewController in
//                popViewController?.popCallBack?(nil)
//                traversePop(currentVc: topViewController())
//            }
//
////            if let tabBarVc = currentVc as? UITabBarController ?? currentVc.tabBarController {
////                handleTabBarController(tabBarVc)
////                return
////            }
////
////            if let navigationController = currentVc as? UINavigationController ?? currentVc.navigationController {
////                handleNavigationController(navigationController)
////                return
////            }
////
////            if currentVc.children.contains(untilPage) {
////                completion?()
////                return
////            }
////
////            dismissOrTraverse(currentVc: currentVc)
//        }
////
////        func handleTabBarController(_ tabBarVc: UITabBarController) {
////            if tabBarVc == untilPage {
////                (tabBarVc.selectedViewController as? UINavigationController)?.popToRootViewController(animated: animated)
////                completion?()
////                return
////            }
////
////            if tabBarVc.viewControllers?.contains(untilPage) == true {
////                if tabBarVc.selectedViewController != untilPage {
////                    tabBarVc.selectedViewController = untilPage
////                }
////                completion?()
////                return
////            }
////
////            if let navigationController = untilPage.navigationController,
////               tabBarVc.viewControllers?.contains(navigationController) == true {
////                navigationController.popToViewController(untilPage, animated: animated)
////                completion?()
////                return
////            }
////            traversePop(currentVc: tabBarVc.presentingViewController ?? tabBarVc.navigationController ?? tabBarVc.parent)
////        }
////
////        func handleNavigationController(_ navigationController: UINavigationController) {
////            if navigationController.viewControllers.contains(untilPage) {
////                navigationController.popToViewController(untilPage, animated: animated)
////                completion?()
////            } else if navigationController.presentingViewController != nil {
////                navigationController.dismiss(animated: false) {
////                    traversePop(currentVc: topViewController())
////                }
////            } else if let parent = navigationController.parent {
////                traversePop(currentVc: parent)
////            } else {
////                pop(animated: false) { _ in
////                    traversePop(currentVc: topViewController())
////                }
////            }
////        }
//
//        // 开始执行逻辑
//        if let navigationController = untilPage.navigationController, 
//            topVc.navigationController == navigationController {
//            navigationController.popToViewController(untilPage, animated: animated)
//            completion?()
//        } else {
//            traversePop(currentVc: topVc)
//        }
//    }
//
//
//    public static func popToRoot(animated: Bool = true,
//                                 completion: (() -> Void)? = nil)
//    {
//        guard let rootVC = rootNavigationController()?.viewControllers.first else { return }
//        let topVC = topViewController()
//
//        if topVC == rootVC {
//            completion?()
//            return
//        }
//        if topVC?.navigationController == rootNavigationController() {
//            topVC?.navigationController?.popToRootViewController(animated: animated)
//            completion?()
//            return
//        }
//        if let tabBarVC = rootVC as? UITabBarController {
//            if let selectedNavVC = tabBarVC.selectedViewController as? UINavigationController {
//                if selectedNavVC.topViewController != selectedNavVC.viewControllers.first {
//                    selectedNavVC.popToRootViewController(animated: animated)
//                    popToRoot(animated: animated, completion: completion)
//                    return
//                }
//            } else if let selectedVC = tabBarVC.selectedViewController, selectedVC == topVC {
////                popToRoot(animated: animated)
//                completion?()
//                return
//            }
//        }
//
//        if let presentedVC = rootViewController()?.presentedViewController {
//            presentedVC.dismiss(animated: false) {
//                popToRoot(animated: animated, completion: completion)
//            }
//        } else {
//            rootNavigationController()?.popToRootViewController(animated: animated)
//            completion?()
//        }
//    }
//
//    public static func pushToReplacement(toPage: UIViewController,
//                                         animated: Bool = true)
//    {
//        if toPage is UINavigationController {
//            print("=====Error: Cannot push a UINavigationController, please check your router config")
//            return
//        }
//        let topVc = topViewController()
//
//        if let topVc = topVc,
//           let topNavi = topVc.navigationController,
//           topNavi.viewControllers.count <= 1
//        { // 当只有一个元素时无法pop，可以直接替换
//            if topVc == topVc.tabBarController?.selectedViewController || topNavi == topNavi.tabBarController?.selectedViewController {
//                toPage.hidesBottomBarWhenPushed = false
//            }
//            topNavi.setViewControllers([toPage], animated: animated)
//        } else {
//            pop(animated: false) { _ in
//                push(toPage: toPage, animated: animated)
//            }
//        }
//    }
//
//    public static func pushToAndRemoveUntil(toPage: UIViewController,
//                                            untilPage: UIViewController?,
//                                            animated: Bool = true)
//    {
//        if toPage is UINavigationController {
//            print("=====Error: Cannot push a UINavigationController, please check your router config")
//            return
//        }
//
//        if untilPage == nil {
//            print("untilPage is nil")
//            push(toPage: toPage)
//            return
//        }
//
//        let topVc = topViewController()
//        if topVc != untilPage {
////            if let topView = topVc?.view, animated  {
////                // 这里临时将顶层视图覆盖到要返回的视图，避免闪屏
////                let topSuperView = topView.superview
////                untilPage?.view .addSubview(topView)
////                DispatchQueue.main.asyncAfter(deadline: .now() + MeteorNavigatorAnimationDuration) {
////                    // 在push动画完成后恢复原样
////                    topView.removeFromSuperview()
////                    topSuperView?.addSubview(topView)
////                }
////            }
//            popUntil(untilPage: untilPage!, animated: false) {
//                push(toPage: toPage, animated: animated)
//            }
//        } else {
//            push(toPage: toPage, animated: animated)
//        }
//    }
//
//    public static func pushToAndRemoveUntilRoot(toPage: UIViewController,
//                                                animated: Bool = true)
//    {
//        if toPage is UINavigationController {
//            print("=====Error: Cannot push a UINavigationController, please check your router config")
//            return
//        }
//
//        var rootVc = rootViewController()
////        let topVc = topViewController()
//
//        if let rootNavi = rootVc as? UINavigationController {
//            rootVc = rootNavi.viewControllers.first
//        }
//
////        if let topView = topVc?.view, rootVc != nil {
////            // 这里临时将顶层视图覆盖到要返回的视图，避免闪屏
////            let  topSuperView = topView.superview
////            rootVc?.view .addSubview(topView)
////            DispatchQueue.main.asyncAfter(deadline: .now() + MeteorNavigatorAnimationDuration) {
////                // 在push动画完成后恢复原样
////                topView.removeFromSuperview()
////                topSuperView?.addSubview(topView)
////            }
////        }
//        popToRoot(animated: false) {
//            rootNavigationController()?.pushViewController(toPage, animated: animated)
//        }
//    }
//
//    /// 获取顶部控制器
//    public static func topViewController() -> UIViewController? {
//        return MeteorNavigatorHelper.topViewController()
//    }
//
//    /// 获取根控制器
//    public static func rootViewController() -> UIViewController? {
//        return MeteorNavigatorHelper.rootViewController()
//    }
//
//    /// 获取根控制器
//    public static func rootNavigationController() -> UINavigationController? {
//        return MeteorNavigatorHelper.rootNavigationController()
//    }
//    
//    /// 处理present特殊情况
//    static func resolvePresentOverFullScreenProblem(topVc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
//        if (topVc.modalPresentationStyle == .overFullScreen) {
//            //这里分为两种情况，由于UIModalPresentationOverFullScreen下，生命周期显示会有问题
//            //所以需要手动调用的场景，从而使下面底部的vc调用viewAppear相关逻辑
//            
//            //这里手动beginAppearanceTransition触发页面生命周期
//            var bottomVC = topVc.presentingViewController
//            if let nav = bottomVC as? UINavigationController {
//                bottomVC = nav.topViewController
//            }
//            bottomVC?.beginAppearanceTransition(true, animated: false)
//            
//            topVc.dismiss(animated: animated) {
//                bottomVC?.endAppearanceTransition()
//                completion?()
//            }
//        } else {
//            topVc.dismiss(animated: animated, completion: completion)
//        }
//    }
//}


public class MeteorNativeNavigator: NSObject {
    // MARK: - Present & Push Navigation
    public static func present(toPage: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let topVc = topViewController() else {
            logError("No top view controller found")
            return
        }
        topVc.present(toPage, animated: animated) {
            completion?()
            MeteorNavigatorObserver.didPop(routeName: toPage.routeName ?? String(describing: type(of: toPage)))
        }
    }

    public static func push(toPage: UIViewController, animated: Bool = true) {
        if toPage is UINavigationController {
            logError("Cannot push a UINavigationController, please check your router config")
            return
        }

        guard let topNavi = topViewController()?.navigationController else {
            logError("No top navigation controller found")
            return
        }
        topNavi.pushViewController(toPage, animated: animated)
        MeteorNavigatorObserver.didPop(routeName: toPage.routeName ?? String(describing: type(of: toPage)))
    }

    // MARK: - Pop & Dismiss Navigation
    public static func pop(animated: Bool = true, result: Any? = nil, completion: (() -> Void)? = nil) {
        guard let topVc = topViewController() else {
            logError("No top view controller found")
            completion?()
            return
        }

        if MeteorNavigatorHelper.isRootViewController(viewController: topVc) {
            logError("Current viewController is rootPage")
            completion?()
            return
        }
        
        popOrDismiss(viewController: topVc, animated: animated) { popViewController in
            popViewController?.popCallBack?(result)
            completion?()
            MeteorNavigatorObserver.didPop(routeName: topVc.routeName ?? String(describing: type(of: topVc)))

        }
    }

    public static func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let topVc = topViewController() else {
            logError("No top view controller found")
            completion?()
            return
        }
        if MeteorNavigatorHelper.isRootViewController(viewController: topVc) {
            logError("Current viewController is rootPage")
            completion?()
            return
        }
        resolvePresentOverFullScreenProblem(topVc: topVc, animated: animated, completion: completion)
    }

    // MARK: - Pop Until Specific Page
    public static func popUntil(untilPage: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let topVc = topViewController(), topVc != untilPage else {
            logInfo("Current viewController is untilPage, no need to popUntil")
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
        guard topVC != rootVC else {
            completion?()
            return
        }

        if let navigationController = topVC?.navigationController, navigationController == rootNavigationController() {
            navigationController.popToRootViewController(animated: animated)
            completion?()
        } else if let presentedVC = rootViewController()?.presentedViewController {
            presentedVC.dismiss(animated: false) {
                popToRoot(animated: animated, completion: completion)
            }
        } else {
            rootNavigationController()?.popToRootViewController(animated: animated)
            completion?()
        }
    }

    // MARK: - Push with Replacement
    public static func pushToReplacement(toPage: UIViewController, animated: Bool = true) {
        guard !(toPage is UINavigationController) else {
            logError("Cannot push a UINavigationController, please check your router config")
            return
        }

        if let topVc = topViewController(), let topNavi = topVc.navigationController, topNavi.viewControllers.count <= 1 {
            handleSinglePageReplacement(topVc: topVc, toPage: toPage, animated: animated)
        } else {
            pop(animated: false) {
                push(toPage: toPage, animated: animated)
            }
        }
    }
    
    // MARK: - Push and remove
    public static func pushToAndRemoveUntil(toPage: UIViewController,
                                            untilPage: UIViewController?,
                                            animated: Bool = true)
    {
        if toPage is UINavigationController {
            print("=====Error: Cannot push a UINavigationController, please check your router config")
            return
        }

        if untilPage == nil {
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
    
    public static func pushToAndRemoveUntilRoot(toPage: UIViewController,
                                                animated: Bool = true)
    {
        if toPage is UINavigationController {
            print("=====Error: Cannot push a UINavigationController, please check your router config")
            return
        }

        var rootVc = rootViewController()
        if let rootNavi = rootVc as? UINavigationController {
            rootVc = rootNavi.viewControllers.first
        }

//        if let topView = topVc?.view, rootVc != nil, animated{
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

    // MARK: - Helper Methods
    private static func popOrDismiss(viewController: UIViewController?, animated: Bool, completion: ((_ popViewController: UIViewController?) -> Void)? = nil) {
        guard let viewController = viewController else {
            completion?(nil)
            return
        }

        if let navigationController = viewController.navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: animated)
            completion?(viewController)
        } else if viewController.presentingViewController != nil {
            resolvePresentOverFullScreenProblem(topVc: viewController, animated: animated) {
                completion?(viewController)
            }
        } else if let parent = viewController.parent {
            removeChildViewController(parent: parent, child: viewController, completion: completion)
        } else {
            logError("View controller cannot be dismissed or popped")
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

        pop(animated: false) {
            recursivePopUntil(untilPage: untilPage, animated: animated, completion: completion)
        }
    }

    private static func handleSinglePageReplacement(topVc: UIViewController, toPage: UIViewController, animated: Bool) {
        if topVc == topVc.tabBarController?.selectedViewController || topVc.navigationController == topVc.tabBarController?.selectedViewController {
            toPage.hidesBottomBarWhenPushed = false
        }
        topVc.navigationController?.setViewControllers([toPage], animated: animated)
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

    // MARK: - Logging Helpers
    private static func logError(_ message: String) {
        print("Error: \(message)")
    }

    private static func logInfo(_ message: String) {
        print("Info: \(message)")
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
