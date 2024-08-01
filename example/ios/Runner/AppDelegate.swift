import UIKit
import Flutter
import flutter_meteor

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FMNewEnginePluginRegistryDelegate {
    
    func register(pluginRegistry: any FlutterPluginRegistry) {
        GeneratedPluginRegistrant.register(with: pluginRegistry)
    }
    
    
    func unRegister(pluginRegistry: any FlutterPluginRegistry) {
        
    }
    
//    let multiEngin = /*MultiEngineHandler*/.init()
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      //
      GeneratedPluginRegistrant.register(with: self)
      
    
      // 在第一次使用FMFlutterViewController之前调用
      FlutterMeteor.setUp(pluginRegistryDelegate: self)
      UIViewController.fmInitializeSwizzling
//      let vc: FMFlutterViewController =  FMFlutterViewController.init()
      let vc = FlutterViewController.init()
//      vc.routeName = "RootPage"
//      let vc =  self.window.rootViewController

      let navi: UINavigationController = UINavigationController.init(rootViewController: vc)
      navi.navigationBar.isHidden = true
      navi.title = "首页导航"
      self.window.rootViewController = navi
      
      // 开始监听路由，需要在self.window.rootViewController 设置完成之后调用
      FMNavigatorObserver.shared.startMonitoring()
      
      // 指定自定义路由
      FlutterMeteor.customRouterDelegate = HzCustomRouter.init()
      // 初始化路由表
      HzRouterMapExemple.setUp()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
