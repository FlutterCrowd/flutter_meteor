import Flutter
import UIKit

public class FlutterMeteorPlugin : NSObject, FlutterPlugin, FlutterMeteorDelegate {
    
    private var _flutterNavigator: (any FlutterMeteorDelegate)?
    
    public var flutterNavigator: any FlutterMeteorDelegate {
        get {
            return _flutterNavigator ?? FMFlutterNavigator(methodChannel: FlutterMeteor.flutterRootEngineMethodChannel)
        }
        
        set {
            _flutterNavigator = newValue
        }
    }
    
    
    public static var flutterRootEngineMethodChannel: FlutterMethodChannel!
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {

//        if (FlutterMeteor.flutterRootEngineMethodChannel == nil) {
//            let flutterMethodChannel = FlutterMethodChannel.init(name: FMRouterMethodChannelName, binaryMessenger: registrar.messenger())
//            if (FlutterMeteor.flutterRootEngineMethodChannel == nil) {
//                FlutterMeteor.flutterRootEngineMethodChannel = flutterMethodChannel
//            }
//            
//            let instance = FlutterMeteorPlugin()
//            instance.flutterNavigator = FlutterMeteor.flutterNavigator
//            if (FlutterMeteor.mainEnginRouterDelegate == nil) {
//                FlutterMeteor.mainEnginRouterDelegate = instance
//                
//            }
//            registrar.addMethodCallDelegate(instance, channel: flutterMethodChannel)
//        } else {
//            let flutterMethodChannel = FlutterMethodChannel.init(name: FMRouterMethodChannelName, binaryMessenger: registrar.messenger())
//            let instance = FlutterMeteorPlugin()
//            instance.flutterNavigator = FlutterMeteor.flutterNavigator
//            registrar.addMethodCallDelegate(instance, channel: flutterMethodChannel)
//        }
    }
    
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        handleFlutterMethodCall(call, result: result)
    }
    
    public func detachFromEngine(for registrar: any FlutterPluginRegistrar) {
        
    }
    
}
