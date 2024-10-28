import Flutter
import flutter_meteor
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MeteorPluginRegistryDelegate {
    func register(pluginRegistry: any FlutterPluginRegistry) {
        GeneratedPluginRegistrant.register(with: pluginRegistry)
    }

    func unRegister(pluginRegistry _: any FlutterPluginRegistry) {}

//    let multiEngin = /*MultiEngineHandler*/.init()
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 在第一次使用FMFlutterViewController之前调用
        FlutterMeteor.setUp(pluginRegistryDelegate: self)
        
        
        GeneratedPluginRegistrant.register(with: self)
        
        UIViewController.fmInitializeSwizzling
        
        let vc: UIViewController = MeteorFlutterViewController(options: MeteorEngineGroupOptions(isMain: true)) // MeteorFlutterViewController.init()//self.window.rootViewController ?? //TabBarViewController.init()//
//        vc.routeName = "rootPage"
//        vc.interactivePopGestureRecognizer = true
        let navi = UINavigationController(rootViewController: vc)
        navi.navigationBar.isHidden = true
//      navi.navigationBar.tintColor = UIColor.darkGray
        navi.title = "首页导航"
        window.rootViewController = navi

        //demo 开始监听路由，需要在self.window.rootViewController 设置完成之后调用
        FMNavigatorObserver.shared.startMonitoring()

//        // 初始化路由表
//        HzRouterMapExemple.setUp()
//         当路由表没有配置时调用这个代理方法
        FlutterMeteor.customRouterDelegate = HzCustomRouter()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func applicationWillTerminate(_ application: UIApplication) {
        print("App 即将终止")
            // 在这里处理即将退出的逻辑，保存数据、清理资源等
    }
}
