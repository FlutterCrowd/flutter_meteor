//
//  HzMethodChannelHandler.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//

import UIKit

class HzMethodChannelHandler: NSObject, HzRouterDelegate {
    
//    typealias Page = String
    
    var customRouterDelegate : (any HzCustomRouterDelegate)?
    // Native 导航器
    private var nativeNavigator: HzNativeNavigator
//    lazy var flutterNavigator: HzFlutterNavigator = {
//        let instance = HzFlutterNavigator.init(methodChannel: HzRouterPlugin.mainEngineMethodChannel)
//           // ... 可能的额外设置 ...
//           return instance
//       }()
    private var flutterNavigator: HzFlutterNavigator
    init(customRouterDelegate: (any HzCustomRouterDelegate)? = nil, nativeNavigator: HzNativeNavigator, flutterNavigator: HzFlutterNavigator) {
        self.customRouterDelegate = customRouterDelegate
        self.nativeNavigator = nativeNavigator
        self.flutterNavigator = flutterNavigator
    }
    func present(toPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
    }
    
    func push(toPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        let withNewEngine: Bool = arguments?["withNewEngine"] as? Bool ?? false
        var entrypointArgs: Dictionary<String, Any> = (arguments?["arguments"] as? Dictionary<String, Any> ) ?? Dictionary<String, Any>.init()
        
        if(withNewEngine) {
            entrypointArgs["initialRoute"] = "multi_engin"
            entrypointArgs["arguments"] = "1"
            let flutterVc = HzFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: entrypointArgs, initialRoute: toPage, nibName: nil, bundle:nil)
            nativeNavigator.push(toPage: flutterVc, arguments: entrypointArgs, callBack: callBack)
        } else {
            let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[toPage]
            let vc: UIViewController? = vcBuilder?(arguments)
            if (vc != nil) {
                nativeNavigator.push(toPage: vc!, arguments: entrypointArgs, callBack: callBack)
            }else if (self.customRouterDelegate != nil ){
                self.customRouterDelegate?.pushToNative(routeName: toPage, arguments: arguments, callBack: callBack)
            } else {
                callBack?(false)
            }

        }
    }
    
    func popUntil(untilPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[untilPage]
        if (vcBuilder != nil && self.customRouterDelegate != nil) {
            self.customRouterDelegate?.popNativeUntil(untilRouteName: untilPage, arguments: arguments, callBack: callBack)
        } else {
            self.flutterNavigator.popUntil(untilPage: untilPage, arguments: arguments, callBack: callBack)
        }
    }
    
    func pushToReplacement(toPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        
        let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[toPage]
        let vc: UIViewController? = vcBuilder?(arguments)
        if (vc != nil) {
            self.nativeNavigator.pushToReplacement(toPage: vc!, arguments: arguments, callBack: callBack)
        } else {
            self.flutterNavigator.pushToReplacement(toPage: toPage, arguments: arguments, callBack: callBack)
        }
    }
    
    func pop(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        HzRouter.topViewController()?.navigationController?.popViewController(animated: true)
    }
    
    func popToRoot(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        self.nativeNavigator.popToRoot(arguments: arguments, callBack: nil)
        self.flutterNavigator.popToRoot(arguments: arguments, callBack: callBack)
    }
    
    public func dismissPage(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        nativeNavigator.dismissPage(arguments: arguments, callBack: callBack)
    }
    
    public func pushToAndRemoveUntil(toPage: String, untilPage: String?, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[toPage]
        let vc: UIViewController? = vcBuilder?(arguments)
        if (vc != nil) {
            self.nativeNavigator.pushToAndRemoveUntil(toPage: vc!, untilPage: nil, arguments: arguments, callBack: callBack)
        } else {
            self.flutterNavigator.pushToAndRemoveUntil(toPage: toPage, untilPage: untilPage, arguments: arguments, callBack: callBack)
        }
    }
    /******************** HzRouterDelegate  end****************************/
    
}

