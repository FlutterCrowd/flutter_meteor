import Flutter
import UIKit


public class FlutterMeteorPlugin : NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        // 缓存Channel以供多引擎相互通信
        let  channelProvider = FlutterMeteorChannelProvider.init(registrar: registrar)
        registrar.publish(channelProvider)
        MeteorEngineManager.saveEngineChannelProvider(provider: channelProvider)
        
       // 处理导航Channel
        let instance = FlutterMeteorPlugin()
        registrar.addMethodCallDelegate(instance, channel: channelProvider.navigatorChannel)
        
        // 处理路由EventBus Channel
        channelProvider.eventBusChannel.setMessageHandler { message, reply in
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
