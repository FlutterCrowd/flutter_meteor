import Flutter
import UIKit

public class FlutterMeteorPlugin : NSObject, FlutterPlugin, FlutterMeteorDelegate {
    
    private var _routerDelegate: (any FlutterMeteorDelegate)?
    
    public var routerDelegate: any FlutterMeteorDelegate {
        get {
            return _routerDelegate ?? self
        }
        set {
            _routerDelegate = newValue
        }
    }
    
    
    public static var flutterRootEngineMethodChannel: FlutterMethodChannel!
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {

        if (FMNavigator.flutterRootEngineMethodChannel == nil) {
            let instance = FlutterMeteorPlugin.init(registrar: registrar)
            instance._routerDelegate = instance
        }
    }
    
    
    public init(registrar: FlutterPluginRegistrar) {
        super.init()
        let flutterMethodChannel = FlutterMethodChannel.init(name: FmRouterMethodChannelName, binaryMessenger: registrar.messenger())
        if (FMNavigator.flutterRootEngineMethodChannel == nil) {
            FMNavigator.flutterRootEngineMethodChannel = flutterMethodChannel
        }
        registrar.addMethodCallDelegate(self, channel: flutterMethodChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        routerDelegate.handleFlutterMethodCall(call, result: result)
    }
    
    public func detachFromEngine(for registrar: any FlutterPluginRegistrar) {
        
    }
    
}
