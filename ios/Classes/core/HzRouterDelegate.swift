//
//  HzRouterDelegate.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/8.
//

import Foundation


public typealias HzRouterCallBack = (_ response: Any?) -> Void

public struct HzRouterOptions {
    var withNewEngine: Bool = false
    var newEngineOpaque: Bool = false
    var arguments: Dictionary<String, Any>?
    var callBack: HzRouterCallBack?
    init(arguments: Dictionary<String, Any>? = nil, callBack: HzRouterCallBack? = nil) {
        self.arguments = arguments
        self.callBack = callBack
    }
}

public protocol HzRouterDelegate {
    
    var customRouterDelegate: (any HzCustomRouterDelegate)? { get }
    // 声明一个关联类型 Page
    // 在iOS中Page是UIViewController，在跟flutter路由这个Page就是String，路由名称
//    associatedtype Page
    
    func present(routeName: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);
    
    func push(toPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);
     
    func pop(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);
    
    func popUntil(untilPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);
     
    func popToRoot(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);
     
    func dismiss(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);
    
    /// push 到指定页面并替换当前页面
    ///
    /// @parma toPage 要跳转的页面，
    func pushToReplacement(toPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);

    /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
    ///
    /// @parma toPage 要跳转的页面，
    /// @parma untilPage 移除截止页面，默认根页面，
    func pushToAndRemoveUntil(toPage: String, untilPage: String?, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);
    
}

// 自定义路由方法，客户端通过实现HzCustomRouterDelegate自定义跳转
public protocol HzCustomRouterDelegate {
    func pushToNative(routeName: String, arguments :Dictionary<String, Any>?, callBack: HzRouterCallBack?)
    func popNativeUntil(untilRouteName: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?)
}
