import Flutter
import UIKit


public class FlutterMeteorPluginPubish: NSObject {
    let registrar: FlutterPluginRegistrar!
    
    private var _navigatorChannel: FlutterMethodChannel?
    public var navigatorChannel: FlutterMethodChannel {
        get{
            if _navigatorChannel == nil {/// itbox.channel.FlutterMeteorNavigator
                _navigatorChannel = FlutterMethodChannel(name: "itbox.meteor.channel", binaryMessenger: registrar.messenger())
            }
            return _navigatorChannel!
        }
    }
    
    private var _eventBusChannel: FlutterMethodChannel?
    public var eventBusChannel: FlutterMethodChannel {
        get{
            if _eventBusChannel == nil {
                _eventBusChannel = FlutterMethodChannel(name: "itbox.channel.FlutterMeteorEventBus", binaryMessenger: registrar.messenger())
            }
            return _eventBusChannel!
        }
    }
    private var _routerManagerChannel: FlutterMethodChannel?
    public var routerManagerChannel: FlutterMethodChannel {
        get{
            if _routerManagerChannel == nil {
                _routerManagerChannel = FlutterMethodChannel(name: "itbox.channel.FlutterMeteorEventBus", binaryMessenger: registrar.messenger())
            }
            return _routerManagerChannel!
        }
    }
    
    
    public var createNavigatorChannel: FlutterMethodChannel {
        get{
            return FlutterMethodChannel(name: "itbox.channel.FlutterMeteorNavigator", binaryMessenger: registrar.messenger())
        }
    }
    
    public var createEventBusChannel: FlutterMethodChannel {
        get{
            return FlutterMethodChannel(name: "itbox.channel.FlutterMeteorEventBus", binaryMessenger: registrar.messenger())
        }
    }
    public var createRouterManagerChannel: FlutterMethodChannel {
        get{
            return FlutterMethodChannel(name: "itbox.channel.FlutterMeteorEventBus", binaryMessenger: registrar.messenger())
        }
    }
    
    
    init(registrar: FlutterPluginRegistrar!) {
        self.registrar = registrar
        super.init()
    }
}


public class FlutterMeteorPlugin : NSObject, FlutterPlugin {
    
    
    public var methodChannel: FlutterMethodChannel!
    
    private let _defaultNavigator: FlutterMeteorDelegate = FMDefaultNavigator.shared
    
    public static func register(with registrar: FlutterPluginRegistrar) {
       let channel = FlutterMethodChannel.init(name: FMRouterMethodChannelName, binaryMessenger: registrar.messenger())
        let instance = FlutterMeteorPlugin()
        instance.methodChannel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
        FlutterMeteor.saveMehtodChannel(key:registrar.messenger(), chennel: channel)
        let  pluginPubish = FlutterMeteorPluginPubish.init(registrar: registrar)
        registrar.publish(pluginPubish)
    }
    
    
    public static func pluginPubish(with registry: FlutterPluginRegistry) -> FlutterMeteorPluginPubish? {
        return registry.valuePublished(byPlugin: "FlutterMeteorPlugin") as? FlutterMeteorPluginPubish
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
