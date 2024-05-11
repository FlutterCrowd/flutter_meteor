import UIKit
import Flutter
import hz_router

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
//    let multiEngin = /*MultiEngineHandler*/.init()
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
      let flutterVc: FlutterViewController = self.window.rootViewController as! FlutterViewController
//      let channel = FlutterMethodChannel(name:"cn.itbox.driver/multi_engin", binaryMessenger: flutterVc.binaryMessenger)
//      MultiEngineHandler.register(with: flutterVc.pluginRegistry().registrar(forPlugin: "MultiEngineHandler")!)

      let navi: UINavigationController = UINavigationController.init(rootViewController: flutterVc)
      navi.navigationBar.isHidden = true
      self.window.rootViewController = navi
      
      
      HzNavigator.setCustomDelegate(customDelegate: HzCustomRouter.init())
      
      let  routerBuilder: HzRouterBuilder =  { arguments in
          let testVc = TestViewController.init()
          return testVc
      }
      HzRouter.insertRouter(routeName: "test", routerBuilder: routerBuilder)
      
      HzRouter.insertRouter(routeName: "multi_engin_native") { arguments in
          var arg = Dictionary<String, Any>.init()
          arg["1"] = 1
          arg["2"] = "2"
          let testVc = HzFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: arg, initialRoute: "multi_engin2")
          return testVc
      }
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
