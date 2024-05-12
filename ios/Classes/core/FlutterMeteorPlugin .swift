import Flutter
import UIKit

public class FlutterMeteorPlugin : NSObject, FlutterPlugin {

    
    public static func register(with registrar: FlutterPluginRegistrar) {
      
            // 主引擎的MethodChannel
        let methodChannel = FlutterMethodChannel(name: FlutterMeteor.HzRouterMethodChannelName, binaryMessenger: registrar.messenger())
        let instance = FlutterMeteorPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        // 主引擎Method Channel 导航器
        FMNavigator.mainEngineFlutterNaviagtor = FMFlutterNavigator.init(methodChannel: methodChannel)

    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        FMNavigator.handleFlutterMethodCall(call, result: result)
    }
    
}
