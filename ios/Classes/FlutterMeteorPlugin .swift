import Flutter
import UIKit

let FMNavigatorMethodChannelName: String  = "itbox.meteor.navigatorChannel";
let FMRouterMethodChannelName: String  = "itbox.meteor.routerChannel";
let FMEventBusMessageChannelName: String  = "itbox.meteor.multiEnginEventChannel";

public class FlutterMeteorChannelProvider: NSObject {
    
    
    private var _navigatorChannel: FlutterMethodChannel?
    public var navigatorChannel: FlutterMethodChannel {
        get{
            return _navigatorChannel!
        }
    }
    
    private var _eventBusChannel: FlutterBasicMessageChannel?
    public var eventBusChannel: FlutterBasicMessageChannel {
        get{
            return _eventBusChannel!
        }
    }
    private var _routerChannel: FlutterMethodChannel?
    public var routerChannel: FlutterMethodChannel {
        get{
            return _routerChannel!
        }
    }
    init(registrar: FlutterPluginRegistrar!) {
        super.init()
        _routerChannel = FlutterMethodChannel(name: FMRouterMethodChannelName, binaryMessenger: registrar.messenger())
        _navigatorChannel = FlutterMethodChannel(name: FMNavigatorMethodChannelName, binaryMessenger: registrar.messenger())
        _eventBusChannel = FlutterBasicMessageChannel.init(name: FMEventBusMessageChannelName, binaryMessenger: registrar.messenger(), codec: FlutterStandardMessageCodec.sharedInstance())


    }
}


public class FlutterMeteorPlugin : NSObject, FlutterPlugin {
    
//    static let channelHolderList = MeteorWeakArray<FlutterMeteorChannelProvider>()
    static let channelHolderMap = MeteorWeakDictionary<FlutterBinaryMessenger, FlutterMeteorChannelProvider>()

    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        // 缓存Channel以供多引擎相互通信
        let  channelHolder = FlutterMeteorChannelProvider.init(registrar: registrar)
        registrar.publish(channelHolder)
//        channelHolderList.add(channelHolder)
        channelHolderMap[registrar.messenger()] = channelHolder
        
       // 处理导航Channel
        let instance = FlutterMeteorPlugin()
        registrar.addMethodCallDelegate(instance, channel: channelHolder.navigatorChannel)
        
//        // 处理路由Channel
//        channelHolder.routerChannel.setMethodCallHandler { call, resault in
//            instance.handleRouterMethodCall(call, result: resault)
//        }
        
        // 处理路由EventBus Channel
        channelHolder.eventBusChannel.setMessageHandler { message, reply in
            MeteorEventBus.receiveMessageFromFlutter(message: message)
            reply(nil)
        }
        
        // 处理共享缓存
        MeteorCacheApiSetup.setUp(binaryMessenger: registrar.messenger(), api: MeteorMemoryCache.shared)
    }
    
    
    public static func channelProvider(with registry: FlutterPluginRegistry) -> FlutterMeteorChannelProvider? {
        return registry.valuePublished(byPlugin: "FlutterMeteorPlugin") as? FlutterMeteorChannelProvider
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.handleFlutterMethodCall(call, result: result)
    }
    
}

extension FlutterMeteorPlugin: MeteorNavigatorDelegate {
    
}
