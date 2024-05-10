import Flutter
import UIKit

public class HzRouterPlugin: NSObject, FlutterPlugin {
    
    static let hzPushNamedMethod: String = "pushNamed";
    static let hzPushReplacementNamedMethod: String = "pushReplacementNamed";
    static let hzPushNamedAndRemoveUntilMethod: String = "pushNamedAndRemoveUntil";
    static let hzPopMethod: String = "pop";
    static let hzPopUntilMethod: String = "popUntil";
    static let hzPopToRootMethod: String = "popToRoot";

    public var  methodChannel: FlutterMethodChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
      
        // 主引擎的MethodChannel
    let methodChannel = FlutterMethodChannel(name: HzEngineManager.HzRouterMethodChannelName, binaryMessenger: registrar.messenger())
    let instance = HzRouterPlugin.init(methodChannel: methodChannel)
      registrar.addMethodCallDelegate(instance, channel: methodChannel)
      HzRouter.plugin = instance
    }

    public init(methodChannel: FlutterMethodChannel? = nil) {
        self.methodChannel = methodChannel
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
    switch call.method {
    case HzRouterPlugin.hzPushNamedMethod:
        var arguments: Dictionary<String, Any> = Dictionary<String, Any>.init() //call.arguments as? Dictionary<String, Any?>
        if (call.arguments is Dictionary<String, Any>) {
            arguments = call.arguments as! Dictionary<String, Any>
        }
        let withNewEngine: Bool = arguments["withNewEngine"] as? Bool ?? false
        let routeName: String? = arguments["routeName"] as? String
//            let entrypointArgs: Dictionary<String, Any?>? = arguments["arguments"]
        if(withNewEngine) {
            let flutterVc = HzEngineManager.createFlutterVC(entryPoint: "childEntry", entrypointArgs: arguments, initialRoute: routeName) { method, arguments, flutterVc in
            }
            HzRouter.topViewController()?.navigationController?.pushViewController(flutterVc, animated: true)
            result(true)
        } else {
            result(false)
        }
   
    case HzRouterPlugin.hzPopMethod:
        result(Dictionary<String, Any>.init())
    case HzRouterPlugin.hzPushReplacementNamedMethod:
        result(Dictionary<String, Any>.init())
    case HzRouterPlugin.hzPushNamedAndRemoveUntilMethod:
        var res = Dictionary<String, Any>.init()
        result(res)
    case HzRouterPlugin.hzPopUntilMethod:
        result(Dictionary<String, Any>.init())
    case HzRouterPlugin.hzPopToRootMethod:
        result(Dictionary<String, Any>.init())
    default:
      result(FlutterMethodNotImplemented)
    }
    }

}
