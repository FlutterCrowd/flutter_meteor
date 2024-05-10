//
//  HzFlutterNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//

import UIKit
import Flutter

class HzFlutterNavigator: NSObject, HzRouterDelegate {
    
    public var  methodChannel: FlutterMethodChannel?
    
    init(methodChannel: FlutterMethodChannel? = HzRouter.plugin?.methodChannel) {
        self.methodChannel = methodChannel
    }
    
    typealias Page = String
    
    func pop(arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        methodChannel?.invokeMethod(HzRouterPlugin.hzPopMethod, arguments: arguments, result: { response in
            callBack?(response)
        })
    }
    
    func popUntil(untilPage: Page, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        var arg = Dictionary<String, Any?>.init()
        arg["routeName"] = untilPage
        arg["arguments"] = arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPopUntilMethod, arguments: arg, result: { response in
            callBack?(response)
        })
    }
    
    func popToRoot(arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        methodChannel?.invokeMethod(HzRouterPlugin.hzPopToRootMethod, arguments: arguments, result: { response in
            callBack?(response)
        })
    }
    
    func dismiss(arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        methodChannel?.invokeMethod(HzRouterPlugin.hzPopMethod, arguments: arguments, result: { response in
            callBack?(response)
        })
    }
    
    func present(toPage: String, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        var arg = Dictionary<String, Any?>.init()
        arg["routeName"] = toPage
        arg["arguments"] = arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPushNamedMethod, arguments: arg, result: { response in
            callBack?(response)
        })
    }
    
    func push(toPage: String, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        var arg = Dictionary<String, Any?>.init()
        arg["routeName"] = toPage
        arg["arguments"] = arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPushNamedMethod, arguments: arg, result: { response in
            callBack?(response)
        })
    }
    
    func pushToReplacement(toPage: String, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        var arg = Dictionary<String, Any?>.init()
        arg["routeName"] = toPage
        arg["arguments"] = arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPushReplacementNamedMethod, arguments: arg, result: { response in
            callBack?(response)
        })
    }
    
    func pushToAndRemoveUntil(toPage: String, untilPage: String?, arguments: Dictionary<String, Any?>?, callBack: HzRouterCallBack?) {
        var arg = Dictionary<String, Any?>.init()
        arg["routeName"] = toPage
        arg["arguments"] = arguments
        methodChannel?.invokeMethod(HzRouterPlugin.hzPushNamedAndRemoveUntilMethod, arguments: arg, result: { response in
            callBack?(response)
        })
    }

}
