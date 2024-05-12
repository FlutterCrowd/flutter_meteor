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
    
    
    public func pop(options: HzRouterOptions?) {
        methodChannel?.invokeMethod(HzRouterPlugin.hzPopMethod, arguments: options?.arguments, result: { response in
            options?.callBack?(response)
        })
    }
    
    public func popUntil(untilRouteName: String, options: HzRouterOptions?) {
        var arg = Dictionary<String, Any>.init()
        arg["untilRouteName"] = untilRouteName
        arg["arguments"] = options?.arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPopUntilMethod, arguments: arg, result: { response in
            options?.callBack?(response)
        })
    }
    
    public func popToRoot(options: HzRouterOptions?) {
        print("Pop to root")
        methodChannel?.invokeMethod(HzRouterPlugin.hzPopToRootMethod, arguments: options?.arguments, result: { response in
            options?.callBack?(response)
        })
    }
    
    public func dismiss(options: HzRouterOptions?) {
        methodChannel?.invokeMethod(HzRouterPlugin.hzPopMethod, arguments: options?.arguments, result: { response in
            options?.callBack?(response)
        })
    }
    
    public func present(routeName: String, options: HzRouterOptions?) {
        var arg = Dictionary<String, Any>.init()
        arg["routeName"] = routeName
        arg["arguments"] = options?.arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPushNamedMethod, arguments: arg, result: { response in
            options?.callBack?(response)
        })
    }
    
    public func push(routeName: String, options: HzRouterOptions?) {
        var arg = Dictionary<String, Any>.init()
        arg["routeName"] = routeName
        arg["arguments"] = options?.arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPushNamedMethod, arguments: arg, result: { response in
            options?.callBack?(response)
        })
    }
    
    public func pushToReplacement(routeName: String, options: HzRouterOptions?) {
        var arg = Dictionary<String, Any>.init()
        arg["routeName"] = routeName
        arg["arguments"] = options?.arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPushReplacementNamedMethod, arguments: arg, result: { response in
            options?.callBack?(response)
        })
    }
    
    public func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: HzRouterOptions?) {
        var arg = Dictionary<String, Any>.init()
        arg["routeName"] = routeName
        arg["arguments"] = options?.arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPushNamedAndRemoveUntilMethod, arguments: arg, result: { response in
            options?.callBack?(response)
        })
    }

}
