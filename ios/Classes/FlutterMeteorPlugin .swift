import Flutter
import UIKit

public class FlutterMeteorPlugin: NSObject, FlutterPlugin {

    
    public static func register(with registrar: FlutterPluginRegistrar) {
        // 缓存Channel以供多引擎相互通信
        let channelProvider = FlutterMeteorChannelProvider(registrar: registrar)
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

//        // 注册 UIApplicationDelegate 代理
//        registrar.addApplicationDelegate(instance)

        // 处理共享缓存
        MeteorCacheApiSetup.setUp(binaryMessenger: registrar.messenger(), api: MeteorMemoryCache.shared)
    }

    public static func channelProvider(with registry: FlutterPluginRegistry) -> FlutterMeteorChannelProvider? {
        return registry.valuePublished(byPlugin: "FlutterMeteorPlugin") as? FlutterMeteorChannelProvider
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        handleFlutterMethodCall(call, result: result)
    }

    deinit {
        // 移除观察者
        NotificationCenter.default.removeObserver(self)
    }
}

extension FlutterMeteorPlugin: MeteorNavigatorDelegate {}

//
// extension FlutterMeteorPlugin: UIApplicationDelegate {
//    // 拦截 AppDelegate 的生命周期事件
//    public func applicationDidBecomeActive(_ application: UIApplication) {
//       // 处理应用进入前台事件
//       print("App became active from AppDelegate")
//    }
//
//    public func applicationDidEnterBackground(_ application: UIApplication) {
//       // 处理应用进入后台事件
//       print("App entered background from AppDelegate")
//    }
//
//    public func applicationWillResignActive(_ application: UIApplication) {
//        // 应用将进入非活跃状态
//        print("App will resign active from AppDelegate")
//    }
//
//    public func applicationWillTerminate(_ application: UIApplication) {
//        // 处理应用进入后台事件
//        print("App will terminate from AppDelegate")
//    }
//
//    public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
//        // 处理应用进入后台事件
//        print("App did received memory warning from AppDelegate")
//    }
//
////    UIApplication.willResignActiveNotification: 应用将进入非活跃状态。
////    UIApplication.willTerminateNotification: 应用将被终止。
// }
