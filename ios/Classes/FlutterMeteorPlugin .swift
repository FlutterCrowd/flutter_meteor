import Flutter
import UIKit

public class FlutterMeteorPlugin : NSObject, FlutterPlugin, FlutterMeteorDelegate {
    
    
    public static var flutterRootEngineMethodChannel: FlutterMethodChannel!
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let flutterMethodChannel = FlutterMethodChannel.init(name: FMRouterMethodChannelName, binaryMessenger: registrar.messenger())
        let instance = FlutterMeteorPlugin()
        registrar.addMethodCallDelegate(instance, channel: flutterMethodChannel)
    }
    
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        handleFlutterMethodCall(call, result: result)
    }
    
    public func detachFromEngine(for registrar: any FlutterPluginRegistrar) {
        
    }
    
}
