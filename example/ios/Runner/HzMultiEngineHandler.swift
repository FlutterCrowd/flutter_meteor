//
//  HzMultiEngineHandler.swift
//  Runner
//
//  Created by itbox_djx on 2024/5/8.
//

import Foundation
import hz_router

public class MultiEngineHandler: NSObject, FlutterPlugin, HzRouterDelegate, HzFlutterRouterDelegate {

    public var methodChannel: FlutterMethodChannel?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = HzRouterPlugin()
      instance.methodChannel = FlutterMethodChannel(name: "cn.itbox.driver/home", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: instance.methodChannel!)
      HzRouter.plugin = instance
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "push":
        var res = Dictionary<String, Any>.init()
        res["message"] = "Do not implementated"
        result(res)
    case "pop":
        pop()
        result(Dictionary<String, Any>.init())
    case "popToRoot":
        popToRoot()
        flutterPopToRoot()
        result(Dictionary<String, Any>.init())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    public func flutterPop() {
        methodChannel?.invokeMethod("pop", arguments: nil)
    }
    
    public func flutterPopUntilName(routerName: String?) {
        var arguments = Dictionary<String, Any?>.init()
        arguments["routerName"] = routerName
        methodChannel?.invokeMethod("pop", arguments: arguments)
    }
    
    public func flutterPopToRoot() {
        methodChannel?.invokeMethod("popToRoot", arguments: nil)
    }
    
}
