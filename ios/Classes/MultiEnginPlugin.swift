//import Flutter
//import UIKit
//
//public class MultiEnginPlugin: NSObject, FlutterPlugin {
//    
//    var currentVc: MutiEnginViewController?
//    
//  public static func register(with registrar: FlutterPluginRegistrar) {
//    let channel = FlutterMethodChannel(name: "multi_engin", binaryMessenger: registrar.messenger())
//    let instance = MultiEnginPlugin()
//    registrar.addMethodCallDelegate(instance, channel: channel)
//  }
//
//  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//    switch call.method {
//    case "getPlatformVersion":
//      result("iOS " + UIDevice.current.systemVersion)
//    case "test":
//        self.currentVc = MutiEnginViewController.init()
////        UIApplication.shared.keyWindow?.rootViewController?.present(self.currentVc!, animated: true)
//        let navi: UINavigationController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
//        
//        navi.pushViewController(self.currentVc!, animated: true)
//      result("这是一条数据")
//    case "back":
////        UIApplication.shared.keyWindow?.rootViewController?.navigationController?.pushViewController(MutiEnginViewController.init(), animated: true)
//        self.currentVc?.dismiss(animated: true)
//        self.currentVc = nil;
//      result("")
//    
//    default:
//      result(FlutterMethodNotImplemented)
//    }
//  }
//
//}
//

