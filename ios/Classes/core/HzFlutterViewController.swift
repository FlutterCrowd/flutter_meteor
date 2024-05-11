//
//  HzFlutterViewController.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/9.
//

import Flutter

public class HzFlutterViewController: FlutterViewController {

    var methodChannel: FlutterMethodChannel?

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(engine: FlutterEngine, nibName: String?, bundle nibBundle: Bundle?) {
        super.init(engine: engine, nibName: nibName, bundle: nibBundle)
    }
    
   public init (entryPoint: String?,
         entrypointArgs: Dictionary<String, Any>?,
         initialRoute: String?) {
       
        // 创建新的引擎
        let flutterEngine = HzEngineManager.createFlutterEngine(entryPoint: entryPoint, initialRoute: initialRoute, entrypointArgs: entrypointArgs)
       
        // 初始化VC
        super.init(engine: flutterEngine, nibName: nil, bundle: nil)
        // 创建Method Channel
        methodChannel = createMethodChannel(channelName: HzEngineManager.HzRouterMethodChannelName)
       
    }
    
    public init (entryPoint: String?,
          entrypointArgs: Dictionary<String, Any>?,
          initialRoute: String?,
           nibName: String?,
           bundle: Bundle?) {
         // 创建新的引擎
         let flutterEngine = HzEngineManager.createFlutterEngine(entryPoint: entryPoint, initialRoute: initialRoute, entrypointArgs: entrypointArgs)
         // 初始化VC
         super.init(engine: flutterEngine, nibName: nibName, bundle: bundle)
//         // 创建Method Channel
         methodChannel = createMethodChannel(channelName: HzEngineManager.HzRouterMethodChannelName)
     }
    
    
    func createMethodChannel(channelName:String) -> FlutterMethodChannel {
        
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: self.binaryMessenger)
        channel.setMethodCallHandler { call, result in
            var arguments: Dictionary<String, Any> = Dictionary<String, Any>.init() //call.arguments as? Dictionary<String, Any?>
            if (call.arguments is Dictionary<String, Any>) {
                arguments = call.arguments as! Dictionary<String, Any>
            }
            let routeName: String = arguments["routeName"] as? String ?? ""
            switch call.method {
            case HzRouterPlugin.hzPushNamedMethod:
                HzNavigator.push(routeName: routeName, arguments: arguments) { response in
                    result(response)
                }
                break
           
            case HzRouterPlugin.hzPopMethod:
                HzNavigator.pop(arguments: arguments) { response in
                    result(response)
                }
                break
            case HzRouterPlugin.hzPushReplacementNamedMethod:
                HzNavigator.pushToReplacement(routeName: routeName, arguments: arguments) { response in
                    result(response)
                }
                break
            case HzRouterPlugin.hzPushNamedAndRemoveUntilMethod:
                let untilRouteName: String? = arguments["untilRouteName"] as? String
                HzNavigator.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, arguments: arguments) { response in
                    result(response)
                }
                break
            case HzRouterPlugin.hzPopUntilMethod:
                let untilRouteName: String = arguments["untilRouteName"] as? String ?? "/"
                HzNavigator.popUntil(untilRouteName: untilRouteName, arguments: arguments) { response in
                    result(response)
                }
                break
            case HzRouterPlugin.hzPopToRootMethod:
                HzNavigator.popToRoot(arguments: arguments) { response in
                    result(response)
                }
                break
            default:
              result(FlutterMethodNotImplemented)
            }
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
//        HzEngineManager.printCache()
    }
   

}
