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
    GeneratedPluginRegistrant.register(with: self)
    
      let vc: UIViewController =  TestViewController.init()//self.window.rootViewController as! FlutterViewController
//      let channel = FlutterMethodChannel(name:"cn.itbox.driver/multi_engin", binaryMessenger: flutterVc.binaryMessenger)
//      MultiEngineHandler.register(with: flutterVc.pluginRegistry().registrar(forPlugin: "MultiEngineHandler")!)

      let navi: UINavigationController = UINavigationController.init(rootViewController: vc)
      navi.navigationBar.isHidden = true
      self.window.rootViewController = navi
      
      FlutterMeteor.pluginRegistryDelegate = self
      
      // 指定自定义路由
      FlutterMeteor.customRouterDelegate = HzCustomRouter.init()
      
      // 初始化路由表
//      HzRouterMapExemple.setUp()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
