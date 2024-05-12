//
//  HzFlutterViewController.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/9.
//

import Flutter

public class HzFlutterViewController: FlutterViewController, HzRouterDelegate {
    
    var methodChannel: FlutterMethodChannel?

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(engine: FlutterEngine, nibName: String?, bundle nibBundle: Bundle?) {
        
        super.init(engine: engine, nibName: nibName, bundle: nibBundle)
        // 创建Method Channel
        methodChannel = createMethodChannel(channelName: HzEngineManager.HzRouterMethodChannelName)
        HzEngineManager.saveEngine(engine: engine, flutterVc: self)
    }
    
    public convenience init (entryPoint: String?,
         entrypointArgs: Dictionary<String, Any>?,
         initialRoute: String?) {
       
        // 创建新的引擎
        let flutterEngine = HzEngineManager.createFlutterEngine(entryPoint: entryPoint, initialRoute: initialRoute, entrypointArgs: entrypointArgs)
        // 初始化VC
        self.init(engine: flutterEngine, nibName: nil, bundle: nil)
       
    }
    
    public convenience init (entryPoint: String?,
          entrypointArgs: Dictionary<String, Any>?,
          initialRoute: String?,
           nibName: String?,
           bundle: Bundle?) {
         // 创建新的引擎
         let flutterEngine = HzEngineManager.createFlutterEngine(entryPoint: entryPoint, initialRoute: initialRoute, entrypointArgs: entrypointArgs)
         // 初始化VC
         self.init(engine: flutterEngine, nibName: nibName, bundle: bundle)
     }
    
    
    func createMethodChannel(channelName:String) -> FlutterMethodChannel {
        
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: self.binaryMessenger)
        channel.setMethodCallHandler {[weak self] call, result in
           self?.handleFlutterMethodCall(call, result: result)
//            var options = HzRouterOptions.init()
//            var routeName: String = ""
//            var untilRouteName: String?
//            if (call.arguments is Dictionary<String, Any>) {
//                let arguments: Dictionary<String, Any> = call.arguments as! Dictionary<String, Any>
//                options.newEngineOpaque = (arguments["newEngineOpaque"] != nil) && arguments["newEngineOpaque"] as! Bool == true
//                options.withNewEngine = arguments["withNewEngine"] as? Bool ?? false
//                routeName = arguments["routeName"] as? String ?? ""
//                untilRouteName = arguments["routeName"] as? String
//                if (arguments ["arguments"] != nil && arguments ["arguments"] is Dictionary<String, Any>) {
//                    options.arguments = arguments["arguments"] as? Dictionary<String, Any>
//                }
//            }
//            
//            options.callBack = {response in
//                result(response)
//            }
//
//            switch call.method {
//            case HzRouterPlugin.hzPushNamedMethod:
//                self?.push(routeName: routeName, options: options)
//                break
//           
//            case HzRouterPlugin.hzPopMethod:
//                self?.pop(options: options)
//                break
//            case HzRouterPlugin.hzPushReplacementNamedMethod:
//                self?.pushToReplacement(routeName: routeName, options: options)
//                break
//            case HzRouterPlugin.hzPushNamedAndRemoveUntilMethod:
//                self?.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
//                break
//            case HzRouterPlugin.hzPopUntilMethod:
//                self?.popUntil(untilRouteName: routeName, options: options)
//                break
//            case HzRouterPlugin.hzPopToRootMethod:
//                self?.popToRoot(options: options)
//                break
//            case HzRouterPlugin.hzDismissMethod:
//                self?.dismiss(options: options)
//                break
//            default:
//              result(FlutterMethodNotImplemented)
//            }
        }
        return channel
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }

    deinit {
        print("HzFlutterViewController did deinit")
        print("current engins \(HzEngineManager.engineCache.count())")
//        HzEngineManager.printCache()
    }
   

}
