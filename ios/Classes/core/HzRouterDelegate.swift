//
//  HzRouterDelegate.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/8.
//

import Foundation

public typealias HzRouterCallBack = (_ response: Any?) -> Void

public protocol HzRouterDelegate<Page> {
    
    // 声明一个关联类型 Page
    // 在iOS中Page是UIViewController，在跟flutter路由这个Page就是String，路由名称
    associatedtype Page
    
    func present(toPage: Page, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);
    
    func push(toPage: Page, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);
     
    func pop(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);
    
    func popUntil(untilPage: Page, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);
     
    func popToRoot(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);
     
    func dismissPage(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);
    
    /// push 到指定页面并替换当前页面
    ///
    /// @parma toPage 要跳转的页面，
    func pushToReplacement(toPage: Page, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);

    /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
    ///
    /// @parma toPage 要跳转的页面，
    /// @parma untilPage 移除截止页面，默认根页面，
    func pushToAndRemoveUntil(toPage: Page, untilPage: Page?, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?);
}

