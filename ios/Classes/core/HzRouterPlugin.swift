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

    
    public static func register(with registrar: FlutterPluginRegistrar) {
      
            // 主引擎的MethodChannel
        let methodChannel = FlutterMethodChannel(name: HzEngineManager.HzRouterMethodChannelName, binaryMessenger: registrar.messenger())
        let instance = HzRouterPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        // 主引擎Method Channel 导航器
        HzNavigator.mainEngineFlutterNaviagtor = HzFlutterNavigator.init(methodChannel: methodChannel)

    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        HzNavigator.handleFlutterMethodCall(call, result: result)
    }
    
}
