//
//  HzFlutterViewController.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/9.
//

import Flutter

public protocol HzCustomRouterDelegate {
    func pushToNative(routeName: String, arguments :Dictionary<String, Any>?, callBack: HzRouterCallBack?)
    func popNativeUntil(untilRouteName: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?)
}

class HzFlutterViewController: FlutterViewController, HzRouterDelegate {


    var methodChannel: FlutterMethodChannel?
    
    // Native 导航器
    private let nativeNavigator: HzNativeNavigator = HzNativeNavigator.init()
    // 主引擎 Flutter 导航器
    private let flutterNavigator: HzFlutterNavigator = HzFlutterNavigator.init(methodChannel: HzRouter.plugin?.methodChannel)
    
    var routerDelegate : (any HzRouterDelegate<String>)?
    var customRouterDelegate : (any HzCustomRouterDelegate)?

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init (entryPoint: String?,
         entrypointArgs: Dictionary<String, Any>?,
         initialRoute: String?,
          nibName: String?,
          bundle: Bundle?
    ) {
        // 创建新的引擎
        let flutterEngine = HzEngineManager.createFlutterEngine(entryPoint: entryPoint, initialRoute: initialRoute, entrypointArgs: entrypointArgs)
        // 初始化VC
        super.init(engine: flutterEngine, nibName: nibName, bundle: bundle)
        routerDelegate = self
        // 创建Method Channel
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
                self.routerDelegate?.push(toPage: routeName, arguments: arguments, callBack: { response in
                    result(response)
                })
                break
           
            case HzRouterPlugin.hzPopMethod:
                self.routerDelegate?.pop(arguments: arguments, callBack: { response in
                    result(response)
                })
                break
            case HzRouterPlugin.hzPushReplacementNamedMethod:
                self.routerDelegate?.pushToReplacement(toPage: routeName, arguments: arguments, callBack: { response in
                    result(response)
                })
                break
            case HzRouterPlugin.hzPushNamedAndRemoveUntilMethod:
                let untilRouteName: String? = arguments["untilRouteName"] as? String
                self.routerDelegate?.pushToAndRemoveUntil(toPage: routeName, untilPage: untilRouteName, arguments: arguments, callBack: { response in
                    result(response)
                })
                break
            case HzRouterPlugin.hzPopUntilMethod:
                let untilRouteName: String = arguments["untilRouteName"] as? String ?? "/"
                self.routerDelegate?.popUntil(untilPage: untilRouteName, arguments: arguments, callBack: { response in
                    result(response)
                })
                break
            case HzRouterPlugin.hzPopToRootMethod:
                self.routerDelegate?.popToRoot(arguments: arguments, callBack: { response in
                    result(response)
                })
                break
            default:
              result(FlutterMethodNotImplemented)
            }
        }
        return channel
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        print("HzFlutterViewController did deinit")
//        HzEngineManager.printCache()
    }

    
    /******************** HzRouterDelegate  start****************************/
    
    typealias Page = String
    
    func present(toPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        
    }
    
    func push(toPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        let withNewEngine: Bool = arguments?["withNewEngine"] as? Bool ?? false
        let entrypointArgs: Dictionary<String, Any>? = arguments?["arguments"] as? Dictionary<String, Any>
        if(withNewEngine) {
            let flutterVc = HzFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: entrypointArgs, initialRoute: toPage, nibName: nil, bundle:nil)
            self.navigationController?.pushViewController(flutterVc, animated: true)
            callBack?(true)
        } else {
            let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[toPage]
            let vc: UIViewController? = vcBuilder?(arguments)
            if (vc != nil) {
                self.navigationController?.pushViewController(vc!, animated: true)
            }else if (self.customRouterDelegate != nil ){
                self.customRouterDelegate?.pushToNative(routeName: toPage, arguments: arguments, callBack: callBack)
            } else {
                callBack?(false)
            }

        }
    }
    
    func popUntil(untilPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[untilPage]
        if (vcBuilder != nil && self.customRouterDelegate != nil) {
            self.customRouterDelegate?.popNativeUntil(untilRouteName: untilPage, arguments: arguments, callBack: callBack)
        } else {
            self.flutterNavigator.popUntil(untilPage: untilPage, arguments: arguments, callBack: callBack)
        }
    }
    
    func pushToReplacement(toPage: String, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[toPage]
        let vc: UIViewController? = vcBuilder?(arguments)
        if (vc != nil) {
            self.nativeNavigator.pushToReplacement(toPage: vc!, arguments: arguments, callBack: callBack)
        } else {
            self.flutterNavigator.pushToReplacement(toPage: toPage, arguments: arguments, callBack: callBack)
        }
    }
    
    func pop(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func popToRoot(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        self.nativeNavigator.popToRoot(arguments: arguments, callBack: nil)
        self.flutterNavigator.popToRoot(arguments: arguments, callBack: callBack)
    }
    
    func dismissPage(arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        self.dismiss(animated: true)
    }
    
    func pushToAndRemoveUntil(toPage: String, untilPage: String?, arguments: Dictionary<String, Any>?, callBack: HzRouterCallBack?) {
        let vcBuilder: HzRouterBuilder? = HzRouter.routerDict[toPage]
        let vc: UIViewController? = vcBuilder?(arguments)
        if (vc != nil) {
            self.nativeNavigator.pushToAndRemoveUntil(toPage: vc!, untilPage: nil, arguments: arguments, callBack: callBack)
        } else {
            self.flutterNavigator.pushToAndRemoveUntil(toPage: toPage, untilPage: untilPage, arguments: arguments, callBack: callBack)
        }
        
    }
    /******************** HzRouterDelegate  end****************************/
    

}
