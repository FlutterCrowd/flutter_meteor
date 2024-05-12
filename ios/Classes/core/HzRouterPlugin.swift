import Flutter
import UIKit

public class HzRouterPlugin: NSObject, FlutterPlugin, HzRouterDelegate {
    
    static let hzPushNamedMethod: String = "pushNamed";
    static let hzPushReplacementNamedMethod: String = "pushReplacementNamed";
    static let hzPushNamedAndRemoveUntilMethod: String = "pushNamedAndRemoveUntil";
    static let hzPopMethod: String = "pop";
    static let hzPopUntilMethod: String = "popUntil";
    static let hzPopToRootMethod: String = "popToRoot";
    static let hzDismissMethod: String = "dismiss";
            
    public static var  mainEngineMethodChannel: FlutterMethodChannel?
    
    // 自定义路由代理
    lazy public var customRouterDelegate: (any HzCustomRouterDelegate)? = {
        return HzRouter.customRouterDelegate
      }()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
      
            // 主引擎的MethodChannel
        let methodChannel = FlutterMethodChannel(name: HzEngineManager.HzRouterMethodChannelName, binaryMessenger: registrar.messenger())
        HzRouter.mainFlutterEngineNavigator = HzFlutterNavigator.init(methodChannel: methodChannel)
        let instance = HzRouterPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.handleFlutterMethodCall(call, result: result)
    }
    
}
