import Flutter
import UIKit

public class HzRouterPlugin: NSObject, FlutterPlugin, HzRouterDelegate, HzFlutterRouterDelegate {

    public var  methodChannel: FlutterMethodChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
      
      let methodChannel = FlutterMethodChannel(name: "hz_router_plugin", binaryMessenger: registrar.messenger())
      let instance = HzRouterPlugin.init(methodChannel: methodChannel)
      registrar.addMethodCallDelegate(instance, channel: methodChannel)
      HzRouter.plugin = instance
    }

    public init(methodChannel: FlutterMethodChannel? = nil) {
        self.methodChannel = methodChannel
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "push":
        var res = Dictionary<String, Any>.init()
        res["message"] = "Do not implementated"
            HzRouter.push(viewController: TestViewController.init())
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

}
