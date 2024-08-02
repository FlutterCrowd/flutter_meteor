import Flutter
import UIKit

public class FlutterMeteorPlugin : NSObject, FlutterPlugin {
    
    
    public var methodChannel: FlutterMethodChannel!
    
    private let _defaultNavigator: FlutterMeteorDelegate = FMDefaultNavigator.shared
    
    public static func register(with registrar: FlutterPluginRegistrar) {
       let channel = FlutterMethodChannel.init(name: FMRouterMethodChannelName, binaryMessenger: registrar.messenger())
        let instance = FlutterMeteorPlugin()
        instance.methodChannel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
        FlutterMeteor.saveMehtodChannel(key:registrar.messenger(), chennel: channel)
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        _defaultNavigator.handleFlutterMethodCall(call, result: result)
    }
    
    public func detachFromEngine(for registrar: any FlutterPluginRegistrar) {
        FlutterMeteor.sremoveMehtodChannel(key: registrar.messenger())
    }
    
    deinit {
    
    }
}


class FMDefaultNavigator: NSObject, FlutterMeteorDelegate {
    
    public static let shared = FMDefaultNavigator()
    private override init() { super.init() }
    deinit {
        
    }
}
