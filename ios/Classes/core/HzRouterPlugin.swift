import Flutter
import UIKit

public class HzRouterPlugin: NSObject, FlutterPlugin {
    
    static let hzPushNamedMethod: String = "pushNamed";
    static let hzPushReplacementNamedMethod: String = "pushReplacementNamed";
    static let hzPushNamedAndRemoveUntilMethod: String = "pushNamedAndRemoveUntil";
    static let hzPopMethod: String = "pop";
    static let hzPopUntilMethod: String = "popUntil";
    static let hzPopToRootMethod: String = "popToRoot";
    static let hzDismissMethod: String = "dismiss";
    
    public static var  mainEngineMethodChannel: FlutterMethodChannel?
   
//    public static var mainMethodCallHandeler: HzMethodChannelHandler?
    
    public var customNavigator: (any HzCustomRouterDelegate)?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
      
        // 主引擎的MethodChannel
    let methodChannel = FlutterMethodChannel(name: HzEngineManager.HzRouterMethodChannelName, binaryMessenger: registrar.messenger())
    mainEngineMethodChannel = methodChannel
    HzNavigator.routerDelegate = HzMethodChannelHandler.init()
    let instance = HzRouterPlugin()
      registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var arguments: Dictionary<String, Any> = Dictionary<String, Any>.init() //call.arguments as? Dictionary<String, Any?>
        if (call.arguments is Dictionary<String, Any>) {
            arguments = call.arguments as! Dictionary<String, Any>
        }
        let routeName: String = arguments["routeName"] as? String ?? "/"
        switch call.method {
        case HzRouterPlugin.hzPushNamedMethod:
            HzNavigator.push(routeName: routeName, arguments: arguments, callBack: { response in
                result(response)
            })
            break
        case HzRouterPlugin.hzPopMethod:
            HzNavigator.pop(arguments: arguments, callBack: { response in
                result(response)
            })
            break
        case HzRouterPlugin.hzPushReplacementNamedMethod:
            HzNavigator.pushToReplacement(routeName: routeName, arguments: arguments) { response in
                result(response)
            }
            break
        case HzRouterPlugin.hzPushNamedAndRemoveUntilMethod:
            HzNavigator.pushToAndRemoveUntil(routeName: routeName, untilRouteName: nil, arguments: arguments) { response in
                result(response)
            }
            break
        case HzRouterPlugin.hzPopUntilMethod: 
            HzNavigator.popUntil(untilRouteName: routeName, arguments: arguments) { response in
                result(response)
            }
            break
        case HzRouterPlugin.hzPopToRootMethod:
            HzNavigator.popToRoot(arguments: arguments, callBack:  { response in
                result(response)
            })
        case HzRouterPlugin.hzDismissMethod:
            HzNavigator.dismiss(arguments: arguments) { response in
                result(response)
            }
        default:
          result(FlutterMethodNotImplemented)
        }
    }

}
