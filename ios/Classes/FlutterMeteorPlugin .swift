import Flutter
import UIKit

public class FlutterMeteorPlugin : NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
      
            // 主引擎的MethodChannel
        let methodChannel = FMMethodChannel.createMehodChannel(registrar.messenger())
        FMMethodChannel.flutterRootEngineMethodChannel = methodChannel
        //FlutterMethodChannel(name: FMMethodChannel.HzRouterMethodChannelName, binaryMessenger: registrar.messenger())
        let instance = FlutterMeteorPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        // 主引擎Method Channel
//        FMNavigator.mainEngineFlutterNaviagtor = FMFlutterNavigator.init(methodChannel: methodChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        FMMethodChannel.handleFlutterMethodCall(call, result: result)
    }
    
}
