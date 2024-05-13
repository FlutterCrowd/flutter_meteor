//
//  HzFlutterNavigator.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/10.
//

import UIKit
import Flutter


public class FMFlutterNavigator: NSObject, FlutterMeteorDelegate {

    
    public var  methodChannel: FlutterMethodChannel?
    
    public init(methodChannel: FlutterMethodChannel?) {
        self.methodChannel = methodChannel
    }
    
    
    public func pop(options: FMMeteorOptions?) {
        methodChannel?.invokeMethod(FMMethodChannel.fmPopMethod, arguments: options?.arguments, result: { response in
            options?.callBack?(response)
        })
    }
    
    public func popUntil(untilRouteName: String, options: FMMeteorOptions?) {
        var arg = Dictionary<String, Any>.init()
        arg["untilRouteName"] = untilRouteName
        arg["arguments"] = options?.arguments
        methodChannel?.invokeMethod(FMMethodChannel.fmPopUntilMethod, arguments: arg, result: { response in
            options?.callBack?(response)
        })
    }
    
    public func popToRoot(options: FMMeteorOptions?) {
        print("Pop to root")
        methodChannel?.invokeMethod(FMMethodChannel.fmPopToRootMethod, arguments: options?.arguments, result: { response in
            options?.callBack?(response)
        })
    }
    
    public func dismiss(options: FMMeteorOptions?) {
        methodChannel?.invokeMethod(FMMethodChannel.fmPopMethod, arguments: options?.arguments, result: { response in
            options?.callBack?(response)
        })
    }
    
    public func present(routeName: String, options: FMMeteorOptions?) {
        var arg = Dictionary<String, Any>.init()
        arg["routeName"] = routeName
        arg["arguments"] = options?.arguments
        methodChannel?.invokeMethod(FMMethodChannel.fmPushNamedMethod, arguments: arg, result: { response in
            options?.callBack?(response)
        })
    }
    
    public func push(routeName: String, options: FMMeteorOptions?) {
        var arg = Dictionary<String, Any>.init()
        arg["routeName"] = routeName
        arg["arguments"] = options?.arguments
        methodChannel?.invokeMethod(FMMethodChannel.fmPushNamedMethod, arguments: arg, result: { response in
            options?.callBack?(response)
        })
    }
    
    public func pushToReplacement(routeName: String, options: FMMeteorOptions?) {
        var arg = Dictionary<String, Any>.init()
        arg["routeName"] = routeName
        arg["arguments"] = options?.arguments
        methodChannel?.invokeMethod(FMMethodChannel.fmPushReplacementNamedMethod, arguments: arg, result: { response in
            options?.callBack?(response)
        })
    }
    
    public func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: FMMeteorOptions?) {
        var arg = Dictionary<String, Any>.init()
        arg["routeName"] = routeName
        arg["arguments"] = options?.arguments
        methodChannel?.invokeMethod(FMMethodChannel.fmPushNamedAndRemoveUntilMethod, arguments: arg, result: { response in
            options?.callBack?(response)
        })
    }

}
