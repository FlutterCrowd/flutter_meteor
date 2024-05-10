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
    
    private static let nativeNavigator: any HzRouterDelegate = HzNativeNavigator.init()
//    // 主引擎的MethodChannel
//    private static let flutterNavigator: HzFlutterNavigator = HzFlutterNavigator.init(methodChannel: HzRouter.plugin?.methodChannel)

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
        var arguments: Dictionary<String, Any> = Dictionary<String, Any>.init() //call.arguments as? Dictionary<String, Any?>
        if (call.arguments is Dictionary<String, Any>) {
            arguments = call.arguments as! Dictionary<String, Any>
        }
        switch call.method {
        case HzRouterPlugin.hzPushNamedMethod:
         
            let withNewEngine: Bool = arguments["withNewEngine"] as? Bool ?? false
            let routeName: String? = arguments["routeName"] as? String
    //            let entrypointArgs: Dictionary<String, Any?>? = arguments["arguments"]
//            if(withNewEngine) {
//                let flutterVc = HzEngineManager.createFlutterVC(entryPoint: "childEntry", entrypointArgs: arguments, initialRoute: routeName) { method, arguments, flutterVc in
//                }
//                HzRouterPlugin.nativeNavigator.push(toPage: flutterVc, arguments: arguments, callBack: nil)
//                result(true)
//            } else {
//                HzRouterPlugin.nativeNavigator.push(toPage: TestViewController.init(), arguments: arguments, callBack: nil)
//                result(false)
//            }
       
        case HzRouterPlugin.hzPopMethod:
            HzRouterPlugin.nativeNavigator.pop(arguments: arguments, callBack: nil)
            result(true)
        case HzRouterPlugin.hzPushReplacementNamedMethod:

            result(true)
        case HzRouterPlugin.hzPushNamedAndRemoveUntilMethod:
    
            result(true)
        case HzRouterPlugin.hzPopUntilMethod:
            
            result(true)
        case HzRouterPlugin.hzPopToRootMethod:
            HzRouterPlugin.nativeNavigator.popToRoot(arguments: arguments, callBack: nil)
            result(true)
        default:
          result(FlutterMethodNotImplemented)
        }
    }

}
