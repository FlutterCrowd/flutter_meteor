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
    
    public static let FmRouterMethodChannelName = "itbox.meteor.channel"
    public static let fmPushNamedMethod: String = "pushNamed";
    public static let fmPushReplacementNamedMethod: String = "pushReplacementNamed";
    public static let fmPushNamedAndRemoveUntilMethod: String = "pushNamedAndRemoveUntil";
    public static let fmPopMethod: String = "pop";
    public static let fmPopUntilMethod: String = "popUntil";
    public static let fmPopToRootMethod: String = "popToRoot";
    public static let fmDismissMethod: String = "dismiss";
    public static var flutterRootEngineMethodChannel: FlutterMethodChannel!
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {

        if (FlutterMeteorPlugin.flutterRootEngineMethodChannel == nil) {
            let instance = FlutterMeteorPlugin.init(registrar: registrar)
            instance._routerDelegate = instance
        }
    }
    
    
    public init(registrar: FlutterPluginRegistrar) {
        super.init()
        let flutterMethodChannel = FlutterMethodChannel.init(name: FlutterMeteorPlugin.FmRouterMethodChannelName, binaryMessenger: registrar.messenger())
        if (FlutterMeteorPlugin.flutterRootEngineMethodChannel == nil) {
            FlutterMeteorPlugin.flutterRootEngineMethodChannel = flutterMethodChannel
        }
        registrar.addMethodCallDelegate(self, channel: flutterMethodChannel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        routerDelegate.handleFlutterMethodCall(call, result: result)
    }
    
    public func detachFromEngine(for registrar: any FlutterPluginRegistrar) {
        
    }
    
}
