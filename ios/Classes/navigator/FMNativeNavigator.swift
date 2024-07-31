//
//  HzNativeNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//

import UIKit



public class FMNativeNavigator: NSObject {
        
    static public func present(toPage: UIViewController, animated: Bool = true) {
        guard let topVc = topViewController() else {
            print("No top view controller found")
            return
        }
        topVc.present(toPage, animated: animated)
        
    }
    
    static public func push(toPage: UIViewController, animated: Bool = true) {
        
        guard let topNavi = topViewController()?.navigationController else {
            print("No top navigator controller found")
            return
        }
        topNavi.pushViewController(toPage, animated: animated)
    }
    
    static public func pop(animated: Bool = true) {
        guard let topVc = topViewController() else {
            print("No top view controller found")
            return
        }

        if let navigationController = topVc.navigationController {
            if navigationController.viewControllers.count > 1 {
                // 当前导航控制器中的 ViewController 大于 1，执行 pop
                navigationController.popViewController(animated: animated)
            } else {
                // 当前导航控制器中的 ViewController 小于或等于 1，需要依赖父导航控制器或根导航控制器
                handleParentNavigationControllerPop(for: navigationController, topVc: topVc, animated: animated)
            }
        } else if let presentedVc = topVc.presentedViewController {
            // 如果视图控制器是通过 present 呈现的，执行 dismiss 操作
            presentedVc.dismiss(animated: animated, completion: nil)
        } else if(topVc != rootViewController()) {
            // 没有导航控制器或呈现控制器，可能是根视图控制器
            topVc.dismiss(animated: animated, completion: nil)
        } else {
            print("This view controller cannot be dismissed or popped")
        }
    }
    

    private static func handleParentNavigationControllerPop(for navigationController: UINavigationController, topVc: UIViewController, animated: Bool) {
        if let parentVc = navigationController.parent {
            if let parentNavi = parentVc as? UINavigationController {
                parentNavi.popViewController(animated: animated)
            } else if let parentNavi = parentVc.navigationController {
                parentNavi.popViewController(animated: animated)
            } else if let presentedVc = navigationController.presentedViewController {
                presentedVc.dismiss(animated: animated, completion: nil)
            } else {
                topVc.dismiss(animated: animated)
            }
        } else {
            if let rootNavi = rootNavigationController() {
                if (rootNavi != navigationController) {
                    navigationController.dismiss(animated: animated)
                } else {
                    rootNavi.popViewController(animated: animated)

                }
            } else if let presentedVc = navigationController.presentedViewController {
                presentedVc.dismiss(animated: animated, completion: nil)
            }
        }
    }

    
    
    static public func dismiss(animated: Bool = true) {
        guard let topVc = topViewController() else {
            print("No top view controller found")
            return
        }
        topVc.dismiss(animated: animated, completion: nil)
    }
    
    static public func popUntil(untilPage: UIViewController, animated: Bool = true) {
        let topVc = topViewController()
        if topVc == untilPage {
            print("CurentviewController is self, no need to popUntil")
        } else {

            func traversePop(currrentVc: UIViewController? ){
                if currrentVc == untilPage {
                    return
                }
                if let naviController = currrentVc as? UINavigationController ?? currrentVc?.navigationController {
                    if naviController != untilPage.navigationController {
                        if naviController.presentedViewController != nil {
                            naviController.dismiss(animated: false) {
                                traversePop(currrentVc: topViewController())
                            }
                        } else if let parent =  naviController.parent{
                            traversePop(currrentVc: parent)
                        } else {
                            pop(animated: animated)
                        }
                    } else {
                        untilPage.navigationController?.popToViewController(untilPage, animated: animated)
                    }
                } else {
                    currrentVc?.dismiss(animated: false) {
                        traversePop(currrentVc: topViewController())
                    }
                }
            }
            
            if topVc?.navigationController != untilPage.navigationController { //如果要返回的页面不在当前栈里面
                
                traversePop(currrentVc: topVc)

            } else if let navigationController = untilPage.navigationController {
                navigationController.popToViewController(untilPage, animated: animated)
            } else {
                untilPage.dismiss(animated: animated)
            }

        }
   
    }
    
    
    
    static public func popToRoot(animated: Bool = true) {
        
        if rootViewController()?.presentedViewController == nil {
            rootNavigationController()?.popToRootViewController(animated: animated)
        } else {
            topViewController()?.dismiss(animated: false, completion: {
                popToRoot(animated: animated)
            })
        }
    }
    
    static public func pushToReplacement(toPage: UIViewController, animated: Bool = true) {
        let topVc = topViewController()
        if let navigationController = topVc?.navigationController {
            if (navigationController.viewControllers.count > 0) {
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(toPage, animated: animated)
            } else {
                navigationController.pushViewController(toPage, animated: animated)
            }
        } else {
            topVc?.dismiss(animated: false, completion: {
                topViewController()?.navigationController?.pushViewController(toPage, animated: animated)
            })
        }
    }
    
    static public func pushToAndRemoveUntil(toPage: UIViewController, untilPage: UIViewController?, animated: Bool = true) {
        
        if (untilPage == nil) {
            print("untilPage is nil")
            push(toPage: toPage)
            return
        }

        let topVc = topViewController()
        if topVc != untilPage {
            if let topView = topVc?.view  {
                // 这里临时将顶层视图覆盖到要返回的视图，避免闪屏
                let  topSuperView = topView.superview
                untilPage?.view .addSubview(topView)
                popUntil(untilPage: untilPage!, animated: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    // 在push动画完成后恢复原样
                    topView.removeFromSuperview()
                    topSuperView?.addSubview(topView)
                }
            } else {
                popUntil(untilPage: untilPage!, animated: false)
            }
        }
        push(toPage: toPage, animated: true)
    }
    
    
    static public func pushToAndRemoveUntilRoot(toPage: UIViewController, animated: Bool = true) {
        
        
        var rootVc = rootViewController()
        if let rootNavi = rootVc as? UINavigationController {
            rootVc = rootNavi.viewControllers.first
        }
        let topVc = topViewController()
        if let topView = topVc?.view, rootVc != nil {
            // 这里临时将顶层视图覆盖到要返回的视图，避免闪屏
            let  topSuperView = topView.superview
            rootVc?.view .addSubview(topView)
            popToRoot(animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // 在push动画完成后恢复原样
                topView.removeFromSuperview()
                topSuperView?.addSubview(topView)
            }
        } else {
            popToRoot(animated: false)
        }
        rootNavigationController()?.pushViewController(toPage, animated: animated)
//        push(toPage: toPage, animated: animated)
    }
    
    
    /// 获取顶部控制器
    public static func topViewController() -> UIViewController? {
        return FMRouterManager.topViewController()
    }
    
    /// 获取根控制器
    public static func rootViewController() -> UIViewController? {
        return FMRouterManager.rootViewController()
    }

    /// 获取根控制器
    public static func rootNavigationController() -> UINavigationController? {
        return FMRouterManager.rootNavigationController()
        
    }
}
