import Flutter
import UIKit

public class FlutterMeteorPlugin : NSObject, FlutterPlugin, FlutterMeteorDelegate {
    
    
    public var methodChannel: FlutterMethodChannel!
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
       let channel = FlutterMethodChannel.init(name: FMRouterMethodChannelName, binaryMessenger: registrar.messenger())
        let instance = FlutterMeteorPlugin()
        instance.methodChannel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
        FlutterMeteor.saveMehtodChannel(key:registrar.messenger(), chennel: channel)
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.handleFlutterMethodCall(call, result: result)
    }
    
    public func detachFromEngine(for registrar: any FlutterPluginRegistrar) {
        FlutterMeteor.sremoveMehtodChannel(key: registrar.messenger())
    }
    
}
