//
//  HzNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/12.
//

import Foundation
import Flutter


public typealias MeteorNavigatorSearchBlock = (_ viewController: UIViewController?) -> Void

public class MeteorNavigator {
    
    public static func viewController(routeName: String?, arguments: Dictionary<String, Any>?) -> UIViewController? {
        return  MeteorRouterManager.getViewController(routeName: routeName, arguments: arguments)
    }
    
    /* push新页面
     *
     * @param routeName 页面路由名称
     * @param options MeteorPushOptions
     */
    public static func push(routeName: String, options: MeteorPushOptions? = nil) {
#if DEBUG
        print("MeteorNavigator push to routeName: \(routeName), opptions: \(options?.toJson() ?? ["":nil])")
#endif
        if let toPage = viewController(routeName: routeName, arguments: options?.arguments) {
           MeteorNativeNavigator.push(toPage: toPage, animated: options?.animated ?? true)
           options?.callBack?(nil)
        } else if(options?.withNewEngine ?? false) {
           let flutterVc = createFlutterVc(routeName: routeName, options: options)
           MeteorNativeNavigator.push(toPage: flutterVc, animated: options?.animated ?? true)
           options?.callBack?(nil)
        } else if(FlutterMeteor.customRouterDelegate != nil) {
           FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
        } else {
           options?.callBack?(nil)
        }
    }
    
    /* present新页面
     *
     * @param routeName 页面路由名称
     * @param options MeteorPushOptions
     */
    public static func present(routeName: String, options: MeteorPushOptions? = nil) {
       
#if DEBUG
        print("MeteorNavigator present to routeName: \(routeName), opptions: \(options?.toJson() ?? ["":nil])")
#endif
        func setNoOpaque(vc: UIViewController) {
            vc.view.backgroundColor = UIColor.clear
            vc.modalPresentationStyle = .overFullScreen
            vc.view.isOpaque = false
        }
        
        if let vc = viewController(routeName: routeName, arguments: options?.arguments) {
            if options?.isOpaque == false {
                setNoOpaque(vc: vc)
                if let navi = vc as? UINavigationController {
                    if let visibleVc = navi.visibleViewController {
                        setNoOpaque(vc: visibleVc)
                    }
                    MeteorNativeNavigator.present(toPage: navi, animated: options?.animated ?? true)
                } else {
                    let navi = UINavigationController.init(rootViewController: vc)
                    navi.navigationBar.isHidden = true
                    setNoOpaque(vc: navi)
                    MeteorNativeNavigator.present(toPage: navi, animated: options?.animated ?? true)
                }
            } else {
                let navi = UINavigationController.init(rootViewController: vc)
                navi.navigationBar.isHidden = true
                MeteorNativeNavigator.present(toPage: navi, animated: options?.animated ?? true)
            }
           options?.callBack?(nil)
        } else if(options?.withNewEngine ?? false) {
            let flutterVc = createFlutterVc(routeName: routeName, options: options)
            let navi = UINavigationController.init(rootViewController: flutterVc)
            navi.navigationBar.isHidden = true
            if options?.isOpaque == false {
               setNoOpaque(vc: navi)
               MeteorNativeNavigator.present(toPage: navi, animated: options?.animated ?? true)
            } else {
               MeteorNativeNavigator.present(toPage: navi, animated: options?.animated ?? true)
            }
            options?.callBack?(nil)
        } else if(FlutterMeteor.customRouterDelegate != nil) {
            FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
        } else {
            options?.callBack?(nil)
        }
   }
    
    /* 打开新页面并且移除导航栈到指定页面
     *
     * @param untilRouteName 指定移除截止页面
     * @param routeName 页面路由名称
     * @param options MeteorPushOptions
     */
    public static func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: MeteorPushOptions? = nil) {
#if DEBUG
        print("MeteorNavigator pushToAndRemoveUntil to routeName: \(routeName), removeUntilRouteName: \(untilRouteName ?? "nil"),opptions: \(options?.toJson() ?? ["":nil])")
#endif
        if  untilRouteName != nil {
            searchRoute(routeName: untilRouteName!) { viewController in
                _realPushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName!, untilPage: viewController, options: options)
            }
        } else {
            _realPushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, untilPage: nil, options: options)
            print("No valid untilRouteName")
        }
    }
    
    
    public static func _realPushToAndRemoveUntil(
        routeName: String,
        untilRouteName: String?,
        untilPage: UIViewController?,
        options: MeteorPushOptions? = nil
    ) {
            
            func doPushToAndRemoveUntil(flutterVc: FlutterViewController,
                                        toPage: UIViewController,
                                        untilRouteName: String?,
                                        options: MeteorPushOptions?) {
                flutterVc.flutterRouteNameStack { routeStack in
                    if let routeStack = routeStack, routeStack.count > 1 {
                        MeteorNativeNavigator.push(toPage: toPage, animated: options?.animated ?? true)
                        flutterVc.flutterPopUntil(untilRouteName: untilRouteName, options: nil)
                    } else {
                        MeteorNativeNavigator.pushToAndRemoveUntil(toPage: toPage, untilPage: untilPage, animated: options?.animated ?? true)
                    }
                    options?.callBack?(nil)
                }
            }
            
            if let toPage = viewController(routeName: routeName, arguments: options?.arguments) {
                if let flutterVc =  untilPage as? FlutterViewController {
                    doPushToAndRemoveUntil(flutterVc: flutterVc, toPage: toPage, untilRouteName: untilRouteName, options: options)
                } else {
                    MeteorNativeNavigator.pushToAndRemoveUntil(toPage: toPage, untilPage: untilPage, animated: options?.animated ?? true)
                    options?.callBack?(nil)
                }
            } else if(options?.withNewEngine ?? false) {
                let newEngineVc = createFlutterVc(routeName: routeName, options: options)
                if let flutterVc =  untilPage as? FlutterViewController {
                    doPushToAndRemoveUntil(flutterVc: flutterVc, toPage: newEngineVc, untilRouteName: untilRouteName, options: options)
                } else {
                    MeteorNativeNavigator.pushToAndRemoveUntil(toPage: newEngineVc, untilPage: untilPage, animated: options?.animated ?? true)
                    options?.callBack?(nil)
                }
                
            } else if(FlutterMeteor.customRouterDelegate != nil) {
                FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
            } else {
                let currentVc = MeteorRouterHelper.topViewController()
                if let flutterVc = currentVc as? FlutterViewController {
                    flutterVc.flutterPushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
                } else {
                    options?.callBack?(nil)
                }
            }
    }
    
    /* 打开新页面并且移除导航栈到根页面
     *
     * @param routeName 页面路由名称
     * @param options MeteorPushOptions
     */
    public static func pushNamedAndRemoveUntilRoot(routeName: String, options: MeteorPushOptions? = nil) {
#if DEBUG
        print("MeteorNavigator pushNamedAndRemoveUntilRoot to routeName: \(routeName), opptions: \(options?.toJson() ?? ["":nil])")
#endif
        func flutterPopRoot(){
            let rootVc = MeteorRouterHelper.rootViewController()
            if let flutterVc = rootVc as? FlutterViewController {
                flutterVc.flutterPopToRoot()
            } else if let naviVc = rootVc as? UINavigationController,
                        let flutterVc = naviVc.viewControllers.first as? FlutterViewController {
                flutterVc.flutterPopToRoot()
            }
        }
        
        if let toPage = viewController(routeName: routeName, arguments: options?.arguments)  {
            MeteorNativeNavigator.pushToAndRemoveUntilRoot(toPage: toPage, animated: options?.animated ?? true)
            flutterPopRoot()
            options?.callBack?(nil)
        } else if(options?.withNewEngine ?? false) {
            let flutterVc = createFlutterVc(routeName: routeName, options: options)
            MeteorNativeNavigator.pushToAndRemoveUntilRoot(toPage: flutterVc, animated: options?.animated ?? true)
            flutterPopRoot()
            options?.callBack?(nil)
        } else {
            if let flutterVc = MeteorRouterHelper.topViewController() as? FlutterViewController {
                flutterVc.flutterPushNamedAndRemoveUntilRoot(routeName: routeName, options: options)
            }
        }
    }

    /* 打开新页面并且替换当前栈顶页面
     *
     * @param routeName 页面路由名称
     * @param options MeteorPushOptions
     */
    public static func pushToReplacement(routeName: String, options: MeteorPushOptions? = nil) {
#if DEBUG
        print("MeteorNavigator pushToReplacement to routeName: \(routeName), opptions: \(options?.toJson() ?? ["":nil])")
#endif
        
        func pushToReplaceWithFLutterVC(flutterVc: FlutterViewController,
                                        topPage: UIViewController,
                                        options: MeteorPushOptions?) {
            
            flutterVc.flutterRouteNameStack() { response in
                if let routeStack = response,
                     routeStack.count > 1 { // 如果当前flutter页面大于一个，则调用flutter的pop
                    MeteorNativeNavigator.push(toPage: topPage, animated: options?.animated ?? true)
                    flutterVc.flutterPop()
                } else {
                    MeteorNativeNavigator.pushToReplacement(toPage: topPage, animated: options?.animated ?? true)
                }
                options?.callBack?(nil)
            }
        }
        
       if let toVc = viewController(routeName: routeName, arguments: options?.arguments) {
           if let flutterVc = MeteorRouterHelper.topViewController() as? FlutterViewController {
               pushToReplaceWithFLutterVC(flutterVc: flutterVc, topPage: toVc, options: options)
           } else {
               MeteorNativeNavigator.pushToReplacement(toPage: toVc, animated: options?.animated ?? true)
               options?.callBack?(nil)
           }
       } else if (options?.withNewEngine ?? false) {
           let newEngineVc = createFlutterVc(routeName: routeName, options: options)
           if let flutterVc = MeteorRouterHelper.topViewController() as? FlutterViewController {
               pushToReplaceWithFLutterVC(flutterVc: flutterVc, topPage: newEngineVc, options: options)
           } else {
               MeteorNativeNavigator.pushToReplacement(toPage: newEngineVc, animated: options?.animated ?? true)
               options?.callBack?(nil)
           }
           
       } else if (FlutterMeteor.customRouterDelegate != nil) {
           FlutterMeteor.customRouterDelegate?.push(routeName: routeName, options: options)
       } else {
           let currentVc = MeteorRouterHelper.topViewController()
           if let flutterVc = currentVc as? FlutterViewController {
               flutterVc.flutterPushToReplacement(routeName: routeName, options: options)
           } else {
               options?.callBack?(nil)
           }
       }
   }
   
    public static func pop(options: MeteorPopOptions? = nil) {
#if DEBUG
        print("MeteorNavigator pop")
#endif
        MeteorNativeNavigator.pop()
        options?.callBack?(nil)
   }
    
    /* 出栈到指定页面
     *
     * @param untilRouteName 截止页面
     * @param options MeteorPushOptions
     */
    public static func popUntil(untilRouteName: String?, options: MeteorPopOptions? = nil) {
#if DEBUG
        print("MeteorNavigator popUntil: \(untilRouteName ?? "nil"), opptions: \(options?.toJson() ?? ["":nil])")
#endif
        if untilRouteName != nil {
            searchRoute(routeName: untilRouteName!) { viewController in
                _popUntil(untilRouteName: untilRouteName!, untilPage: viewController, options: options)
            }
        } else {
            print("No valid untilRouteName")
        }
   
    }
    
    private static func _popUntil(untilRouteName: String, untilPage: UIViewController?, options: MeteorPopOptions?) {
        // 1、先查询untilRouteName所在的viewController
        if (untilPage != nil) {
            MeteorNativeNavigator.popUntil(untilPage: untilPage!, animated: options?.animated ?? true)
            if let flutterVc = untilPage as? FlutterViewController {
                // 3、如果是FlutterViewController则通过Channel通道在flutter端popUntil
                flutterVc.flutterPopUntil(untilRouteName: untilRouteName, options: options)
            }
        } else { //如果untilPage不存在则返回上一页
            print("pop until 查无此路由：\(untilRouteName)")
        }
    }
   
    /* 出栈到根页面
     *
     * @param options MeteorPushOptions
     */
    public static func popToRoot(options: MeteorPopOptions? = nil) {
#if DEBUG
        print("MeteorNavigator popToRoot, opptions: \(options?.toJson() ?? ["":nil])")
#endif
        let rootVc = MeteorRouterHelper.rootViewController()
        if let flutterVc = rootVc as? FlutterViewController {
            flutterVc.flutterPopToRoot(options: options)
        } else if let naviVc = rootVc as? UINavigationController {
            if let flutterVc = naviVc.viewControllers.first as? FlutterViewController {
                flutterVc.flutterPopToRoot(options: options)
            }
        } else {
            print("ViewController is not a FlutterViewController")
        }
        MeteorNativeNavigator.popToRoot(animated: options?.animated ?? true)
        options?.callBack?(nil)


    }
   
    public static func dismiss(options: MeteorPopOptions? = nil) {
#if DEBUG
        print("MeteorNavigator dismiss, opptions: \(options?.toJson() ?? ["":nil])")
#endif
        MeteorNativeNavigator.dismiss(animated: options?.animated ?? true)
        options?.callBack?(nil)
    }
    
    
    private static func createFlutterVc(routeName: String, options: MeteorPushOptions?) -> MeteorFlutterViewController {
        let isOpaque: Bool = options?.isOpaque ?? true
        
        let engineGroupOptions = MeteorEngineGroupOptions.init(
            entrypoint: "childEntry",
            initialRoute: routeName,
            entrypointArgs: options?.arguments)
        
        let flutterVc = MeteorFlutterViewController.init(options: engineGroupOptions) { response in
            options?.callBack?(nil)
        }
        flutterVc.routeName = routeName
        flutterVc.isViewOpaque = isOpaque
        flutterVc.modalPresentationStyle = .overFullScreen
        if(!isOpaque) {
            flutterVc.view.backgroundColor = UIColor.clear
        }
        return flutterVc
    }
}



extension MeteorNavigator {
    
    /*------------------------router method start--------------------------*/
    public static func searchRoute(routeName: String, result: @escaping MeteorNavigatorSearchBlock) {
    
        let vcStack = MeteorRouterHelper.viewControllerStack.reversed() // 反转数组，从顶层向下层搜索
        let serialQueue = MeteorSerialTaskQueue(label: "cn.itbox.serialTaskQueue.routeSearch")

        func callBack(viewController: UIViewController?){
            DispatchQueue.main.async {
                result(viewController)
            }
        }
        
        func search(in stack: [UIViewController], index: Int) {
            
            guard index < stack.count else {
                // 搜索完成，调用结果回调
                callBack(viewController: nil)
                return
            }

            let vc = stack[index]
            let continueSearch = {
                search(in: stack, index: index + 1)
            }
            
            serialQueue.addTask { finish in
                if let flutterVc = vc as? FlutterViewController {
                    flutterVc.flutterRouteExists(routeName: routeName, result: { exists in
                        defer {
                            finish()
                        }
                        if exists {
                            // 找到匹配的路由，调用结果回调
                            callBack(viewController: vc)
                        } else {
                            // 继续搜索下一个
                            continueSearch()
                        }
                    })
                } else {
                    defer {
                        finish()
                    }
                    if routeName == vc.routeName {
                       // 找到匹配的路由，调用结果回调
                        callBack(viewController: vc)
                   } else {
                       // 继续搜索下一个
                       continueSearch()
                   }
                }
            }
        }

        // 从第一个元素开始搜索
        search(in: Array(vcStack), index: 0)
    }
    
    /* 检查导航栈中是否有对应的页面
     *
     * @param routeName 页面路由名称
     * @param result 检查结果回调
     */
    public static func routeExists(routeName:String, result: @escaping ((Bool) -> Void)) {
        searchRoute(routeName: routeName) { viewController in
            let exists = viewController != nil// 没有对应的ViewCOntroller则可以认为没有这个路由
            result(exists)
        }
    }
    
    /* 检查页面是否是导航栈的根页面
     *
     * @param routeName 页面路由名称
     * @param result 检查结果回调
     */
    public static func isRoot(routeName:String, result: @escaping ((Bool) -> Void)) {
        rootRouteName { rootName in
            if(rootName == routeName) {
                result(true)
            } else {
                result(false)
            }
        }
    }
    
    /* 获取导航栈的根页面
     *
     * @param result 结果回调
     */
    public static func rootRouteName(result: @escaping ((String?) -> Void)) {
        
        let rootVc = MeteorRouterHelper.rootViewController()
        if let flutterVc = rootVc as? FlutterViewController {
            flutterVc.flutterRootRouteName { response in
                result(response)
            }
        } else if let naviVc = rootVc as? UINavigationController {
            let vc = naviVc.viewControllers.first
            if let flutterVc = vc as? FlutterViewController {
                flutterVc.flutterRootRouteName { response in
                    result(response)
                }
            } else {
                result(rootVc?.routeName)
            }
        } else {
            result(rootVc?.routeName)

        }
    }
    
    /* 获取导航栈的栈顶页面
     *
     * @param result 结果回调
     */
    public static func topRouteName(result: @escaping ((String?) -> Void)) {
        
        let topVc = MeteorRouterHelper.topViewController()
        if let flutterVc = topVc as? FlutterViewController {
            flutterVc.flutterTopRouteName{ response in
                result(response)
            }
        } else {
            result(topVc?.routeName)
        }
    }
    
    /* 获取导航栈
     *
     * @param result 结果回调
     */
    public static func routeNameStack(result: @escaping (([String]?) -> Void)) {
        
        let vcStack = MeteorRouterHelper.viewControllerStack
        let dispatchGroup = DispatchGroup() // DispatchGroup 用于管理并发任务
        var routeStack = [String]()
        var vcMap = [UIViewController: [String]]()
//        print("原生开始调用routeNameStack")
        vcStack.forEach { vc in
            dispatchGroup.enter()
            if let flutterVc = vc as? FlutterViewController {
                flutterVc.flutterRouteNameStack { routeStack in
                    defer {
                        dispatchGroup.leave()
                    }
                    if routeStack?.isEmpty ?? true {
                        vcMap[vc] = [vc.routeName ?? "\(type(of: vc))"]
                    } else {
                        vcMap[vc] = routeStack
                    }
                }
            } else {
                defer {
                    dispatchGroup.leave()
                }
                vcMap[vc] = [vc.routeName ?? "\(type(of: vc))"]
            }
        }

        dispatchGroup.notify(queue: .main) {
            vcStack.forEach { vc in
                routeStack.append(contentsOf: vcMap[vc] ?? [vc.routeName ?? "\(type(of: vc))"])
            }
            result(routeStack)
//            print("原生结束调用routeNameStack")
        }
    }
    
    /* 判断当前导航栈栈顶是原生还是Flutter
     *
     * @param result 结果回调, true-表示原生， false-表示flutter
     */
    public static func topRouteIsNative(result: @escaping ((Bool) -> Void)) {
        let vc = MeteorRouterHelper.topViewController()
        let topVc = MeteorRouterHelper.getTopVC(withCurrentVC: vc)
        if topVc is FlutterViewController {
            result(false)
        } else {
            result(true)
        }
    }
    /*------------------------router method end--------------------------*/

}
 



