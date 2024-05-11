//
//  HzMethodChannelHandler.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//

import UIKit

public class HzMethodChannelHandler: NSObject, HzRouterDelegate {
    
    public var myCustomRouterDelegate : (any HzCustomRouterDelegate)?
    
    public var customRouterDelegate: (any HzCustomRouterDelegate)? {
        get {
            return myCustomRouterDelegate
        }
        set {
            myCustomRouterDelegate = newValue
        }
    }
    
    private var _flutterNavigator: HzFlutterNavigator?
         
    public var flutterNavigator: HzFlutterNavigator {
        get {
            return _flutterNavigator ?? HzFlutterNavigator.init(methodChannel: HzRouterPlugin.mainEngineMethodChannel)
        }
        set {
            _flutterNavigator = newValue
        }
    }
    

    public func present(toPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        HzNativeNavigator.pop(arguments: arguments, callBack: callBack)
    }
    
    public func push(toPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        let withNewEngine: Bool = arguments?["withNewEngine"] as? Bool ?? false
        var entrypointArgs: Dictionary<String, Any> = (arguments?["arguments"] as? Dictionary<String, Any> ) ?? Dictionary<String, Any>.init()
        if(withNewEngine) {
            entrypointArgs["initialRoute"] = "multi_engin"
            entrypointArgs["arguments"] = "1"
            let flutterVc = HzFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: entrypointArgs, initialRoute: toPage, nibName: nil, bundle:nil)
            HzNativeNavigator.push(toPage: flutterVc, arguments: entrypointArgs, callBack: callBack)
        } else {
            let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[toPage]
            let vc: UIViewController? = vcBuilder?(arguments)
            if (vc != nil) {
                HzNativeNavigator.push(toPage: vc!, arguments: entrypointArgs, callBack: callBack)
            }else if (self.customRouterDelegate != nil ){
                self.customRouterDelegate?.pushToNative(routeName: toPage, arguments: arguments, callBack: callBack)
            } else {
                callBack?(false)
            }

        }
    }
    
    public func popUntil(untilPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[untilPage]
        if (vcBuilder != nil || self.customRouterDelegate != nil) {
            self.customRouterDelegate?.popNativeUntil(untilRouteName: untilPage, arguments: arguments, callBack: callBack)
        } else {
            self.flutterNavigator.popUntil(untilPage: untilPage, arguments: arguments, callBack: callBack)
        }
    }
    
    public func pushToReplacement(toPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        
        let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[toPage]
        let vc: UIViewController? = vcBuilder?(arguments)
        if (vc != nil) {
            HzNativeNavigator.pushToReplacement(toPage: vc!, arguments: arguments, callBack: callBack)
        } else {
            self.flutterNavigator.pushToReplacement(toPage: toPage, arguments: arguments, callBack: callBack)
        }
    }
    
    public func pop(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        HzNativeNavigator.pop(arguments: arguments, callBack: callBack)
    }
    
    public func popToRoot(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        HzNativeNavigator.popToRoot(arguments: arguments, callBack: nil)
        self.flutterNavigator.popToRoot(arguments: arguments, callBack: callBack)
    }
    
    public func dismissPage(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        HzNativeNavigator.dismissPage(arguments: arguments, callBack: callBack)
    }
    
    public func pushToAndRemoveUntil(toPage: String, untilPage: String?, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[toPage]
        let untileVcBuilder: HzRouterBuilder? = HzRouter.routerDict[toPage]
        let vc: UIViewController? = vcBuilder?(arguments)
        let untilVc: UIViewController? = untileVcBuilder?(arguments)
        if (vc != nil) {
            HzNativeNavigator.pushToAndRemoveUntil(toPage: vc!, untilPage: untilVc, arguments: arguments, callBack: callBack)
        } else {
            self.flutterNavigator.pushToAndRemoveUntil(toPage: toPage, untilPage: untilPage, arguments: arguments, callBack: callBack)
        }
    }
    /******************** HzRouterDelegate  end****************************/
    
}

