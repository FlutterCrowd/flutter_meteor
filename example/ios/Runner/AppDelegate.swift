import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let multiEngin = MultiEngineHandler.init()
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
      let flutterVc: FlutterViewController = self.window.rootViewController as! FlutterViewController
//      let channel = FlutterMethodChannel(name:"cn.itbox.driver/multi_engin", binaryMessenger: flutterVc.binaryMessenger)
      MultiEngineHandler.register(with: flutterVc.pluginRegistry().registrar(forPlugin: "MultiEngineHandler")!)

      let navi: UINavigationController = UINavigationController.init(rootViewController: flutterVc)
      self.window.rootViewController = navi
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
