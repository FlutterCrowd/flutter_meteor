//
//  HzNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//


import Foundation

public class HzNavigator: NSObject {
  
    public static var routerDelegate:  HzMethodChannelHandler?

    public static func setCustomDelegate (customDelegate: any HzCustomRouterDelegate) {
        self.routerDelegate?.myCustomRouterDelegate = customDelegate
    }
        
    public static func present(routeName: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        self.routerDelegate?.present(routeName: routeName, arguments: arguments, callBack: callBack)
    }
    
    public static func push(routeName:  String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        self.routerDelegate?.push(toPage: routeName, arguments: arguments, callBack: callBack)
    }
     
    public static func pop(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        self.routerDelegate?.pop(arguments: arguments, callBack: callBack)
    }
    
    public static func popUntil(untilRouteName:  String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        self.routerDelegate?.popUntil(untilPage: untilRouteName, arguments: arguments, callBack: callBack)
    }
     
    public static func popToRoot(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        self.routerDelegate?.popToRoot(arguments: arguments, callBack: callBack)
    }
     
    public static func dismiss(arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        self.routerDelegate?.dismiss(arguments: arguments, callBack: callBack)
    }
    
    /// push 到指定页面并替换当前页面
    ///
    /// @parma toPage 要跳转的页面，
    public static func pushToReplacement(routeName:  String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        self.routerDelegate?.pushToReplacement(toPage: routeName, arguments: arguments, callBack: callBack)
    }

    /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
    ///
    /// @parma toPage 要跳转的页面，
    /// @parma untilPage 移除截止页面，默认根页面，
    public static func pushToAndRemoveUntil(routeName:  String, untilRouteName: String?, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        self.routerDelegate?.pushToAndRemoveUntil(toPage: routeName, untilPage: untilRouteName, arguments: arguments, callBack: callBack)
    }

}
