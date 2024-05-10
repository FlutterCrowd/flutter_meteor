//
//  HzNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//


import Foundation

public class HzNavigator: NSObject {
  
    private static let nativeNavigator: HzNativeNavigator = HzNativeNavigator.init()
    // 主引擎的MethodChannel
    private static let flutterNavigator: HzFlutterNavigator = HzFlutterNavigator.init(methodChannel: HzRouter.plugin?.methodChannel)
    public static func present(toPage: Any, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        if (toPage is UIViewController) {
            nativeNavigator.present(toPage: toPage as! UIViewController, arguments: arguments, callBack: callBack)
        } else {
            flutterNavigator.present(toPage: toPage as! String, arguments: arguments, callBack: callBack)
        }
    }
    
    public static func push(toPage:  Any, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        if (toPage is UIViewController) {
            nativeNavigator.push(toPage: toPage as! UIViewController, arguments: arguments, callBack: callBack)
        } else {
            flutterNavigator.push(toPage: toPage as! String, arguments: arguments, callBack: callBack)
        }
    }
     
    public static func pop(arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        nativeNavigator.pop(arguments: arguments, callBack: callBack)
    }
    
    public static func popUntil(untilPage:  Any, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        if (untilPage is UIViewController) {
            nativeNavigator.popUntil(untilPage: untilPage as! UIViewController, arguments: arguments, callBack: callBack)
        } else {
            flutterNavigator.popUntil(untilPage: untilPage as! String, arguments: arguments, callBack: callBack)
        }
    }
     
    public static func popToRoot(arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        nativeNavigator.popToRoot(arguments: arguments, callBack: callBack)
        flutterNavigator.popToRoot(arguments: arguments, callBack: callBack)
    }
     
    public static func dismiss(arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        
    }
    
    /// push 到指定页面并替换当前页面
    ///
    /// @parma toPage 要跳转的页面，
    public static func pushToReplacement(toPage:  Any, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        if (toPage is UIViewController) {
            nativeNavigator.pushToReplacement(toPage: toPage as! UIViewController, arguments: arguments, callBack: callBack)
        } else {
            flutterNavigator.pushToReplacement(toPage: toPage as! String, arguments: arguments, callBack: callBack)
        }
    }

    /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
    ///
    /// @parma toPage 要跳转的页面，
    /// @parma untilPage 移除截止页面，默认根页面，
    public static func pushToAndRemoveUntil(toPage:  Any, untilPage: Any?, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        if (toPage is UIViewController ) {
            nativeNavigator.pushToAndRemoveUntil(toPage: toPage as! UIViewController, untilPage: untilPage as? UIViewController, arguments: arguments, callBack: callBack)
        } else {
            flutterNavigator.pushToAndRemoveUntil(toPage: toPage as! String, untilPage: untilPage as? String, arguments: arguments, callBack: callBack)
        }
        
    }

}
