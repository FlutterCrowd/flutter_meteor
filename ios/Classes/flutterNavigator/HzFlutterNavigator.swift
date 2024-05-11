//
//  HzFlutterNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//

import UIKit
import Flutter


public class HzFlutterNavigator: NSObject, HzRouterDelegate {
    public var customRouterDelegate: (any HzCustomRouterDelegate)?
    
    public var  methodChannel: FlutterMethodChannel?
    
    public init(methodChannel: FlutterMethodChannel?) {
        self.methodChannel = methodChannel
    }
    
    public typealias Page = String
    
    public func pop(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        methodChannel?.invokeMethod(HzRouterPlugin.hzPopMethod, arguments: arguments, result: { response in
            callBack?(response)
        })
    }
    
    public func popUntil(untilPage: Page, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        var arg = Dictionary<String, Any>.init()
        arg["routeName"] = untilPage
        arg["arguments"] = arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPopUntilMethod, arguments: arg, result: { response in
            callBack?(response)
        })
    }
    
    public func popToRoot(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        print("Pop to root")
        methodChannel?.invokeMethod(HzRouterPlugin.hzPopToRootMethod, arguments: arguments, result: { response in
            callBack?(response)
        })
    }
    
    public func dismissPage(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        methodChannel?.invokeMethod(HzRouterPlugin.hzPopMethod, arguments: arguments, result: { response in
            callBack?(response)
        })
    }
    
    public func present(toPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        var arg = Dictionary<String, Any>.init()
        arg["routeName"] = toPage
        arg["arguments"] = arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPushNamedMethod, arguments: arg, result: { response in
            callBack?(response)
        })
    }
    
    public func push(toPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        var arg = Dictionary<String, Any>.init()
        arg["routeName"] = toPage
        arg["arguments"] = arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPushNamedMethod, arguments: arg, result: { response in
            callBack?(response)
        })
    }
    
    public func pushToReplacement(toPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        var arg = Dictionary<String, Any>.init()
        arg["routeName"] = toPage
        arg["arguments"] = arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPushReplacementNamedMethod, arguments: arg, result: { response in
            callBack?(response)
        })
    }
    
    public func pushToAndRemoveUntil(toPage: String, untilPage: String?, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        var arg = Dictionary<String, Any>.init()
        arg["routeName"] = toPage
        arg["arguments"] = arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPushNamedAndRemoveUntilMethod, arguments: arg, result: { response in
            callBack?(response)
        })
    }

}
