import Flutter
import UIKit

public class HzRouterPlugin: NSObject, FlutterPlugin {
    
    static let hzPushNamedMethod: String = "pushNamed";
    static let hzPushReplacementNamedMethod: String = "pushReplacementNamed";
    static let hzPushNamedAndRemoveUntilMethod: String = "pushNamedAndRemoveUntil";
    static let hzPopMethod: String = "pop";
    static let hzPopUntilMethod: String = "popUntil";
    static let hzPopToRootMethod: String = "popToRoot";
    
    public static var  mainEngineMethodChannel: FlutterMethodChannel?
   
    public static var mainMethodCallHandeler: (any HzRouterDelegate)?
    
    public var customNavigator: (any HzCustomRouterDelegate)?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
      
        // 主引擎的MethodChannel
    let methodChannel = FlutterMethodChannel(name: HzEngineManager.HzRouterMethodChannelName, binaryMessenger: registrar.messenger())
    mainEngineMethodChannel = methodChannel
    mainMethodCallHandeler = HzMethodChannelHandler.init(nativeNavigator: HzNativeNavigator.init(), flutterNavigator: HzFlutterNavigator(methodChannel: methodChannel))
    let instance = HzRouterPlugin()
      registrar.addMethodCallDelegate(instance, channel: methodChannel)
      HzRouter.plugin = instance
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var arguments: Dictionary<String, Any> = Dictionary<String, Any>.init() //call.arguments as? Dictionary<String, Any?>
        if (call.arguments is Dictionary<String, Any>) {
            arguments = call.arguments as! Dictionary<String, Any>
        }
        let routeName: String = arguments["routeName"] as? String ?? "/"
        switch call.method {
        case HzRouterPlugin.hzPushNamedMethod:
            HzRouterPlugin.mainMethodCallHandeler?.push(toPage: routeName, arguments: arguments, callBack: { response in
                result(response)
            })
        case HzRouterPlugin.hzPopMethod:
            HzRouterPlugin.mainMethodCallHandeler?.pop(arguments: arguments, callBack: { response in
                result(response)
            })
        case HzRouterPlugin.hzPushReplacementNamedMethod: break
//            HzRouterPlugin.mainMethodCallHandeler?.pushToReplacement(toPage: routeName, arguments: arguments, callBack: { response in
//                result(response)
//            })
        case HzRouterPlugin.hzPushNamedAndRemoveUntilMethod: break
//            HzRouterPlugin.mainMethodCallHandeler?.pushToAndRemoveUntil(toPage: routeName, untilPage: nil, arguments: arguments, callBack: { response in
//                result(response)
//            })
        case HzRouterPlugin.hzPopUntilMethod: break
//            HzRouterPlugin.mainMethodCallHandeler?.popUntil(untilPage: routeName, arguments: arguments, callBack:  { response in
//                result(response)
//            })
        case HzRouterPlugin.hzPopToRootMethod:
            print("Plugin pop to root \(String(describing: HzRouterPlugin.mainEngineMethodChannel))")
            HzRouterPlugin.mainMethodCallHandeler?.popToRoot(arguments: arguments, callBack:  { response in
                result(response)
            })
        default:
          result(FlutterMethodNotImplemented)
        }
    }

}
