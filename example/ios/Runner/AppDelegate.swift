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
//    GeneratedPluginRegistrant.register(with: self)
    
      UIViewController.swizzlePresentation
      FlutterMeteor.pluginRegistryDelegate = self

      let vc: FMFlutterViewController =  FMFlutterViewController.init()
      vc.routeName = "MeteorRootPage"
      let navi: UINavigationController = UINavigationController.init(rootViewController: vc)
      navi.navigationBar.isHidden = true
      navi.title = "首页导航"
      self.window.rootViewController = navi
      
      
      FlutterMeteorRouter.startMonitoring()

      
//      let vc: UIViewController =  self.window.rootViewController!//TestViewController.init()//
//      vc.title = "首页"
//      let navi: UINavigationController = UINavigationController.init(rootViewController: vc)
//      navi.navigationBar.isHidden = true
//      navi.title = "首页导航"
//      self.window.rootViewController = navi
      

      
      // 指定自定义路由
      FlutterMeteor.customRouterDelegate = HzCustomRouter.init()
      
      // 初始化路由表
      HzRouterMapExemple.setUp()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
