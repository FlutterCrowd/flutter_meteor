//
//  HzFlutterViewController.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/9.
//

import Flutter

public typealias FlutterMeteorPopCallBack = (_ response: Dictionary<String, Any>?) -> Void


public class FMFlutterViewController: FlutterViewController, FlutterMeteorDelegate  {
    
    var methodChannel: FlutterMethodChannel?
    var popCallBack: FlutterMeteorPopCallBack?
    
//    private var  _meteorDelegate:FlutterMeteorDelegate?
//
//    public var meteorDelegate: FlutterMeteorDelegate {
//       get {
//           if _meteorDelegate == nil {
//               _meteorDelegate = self
//           }
//           return _meteorDelegate!
//       }
//       set {
//           _meteorDelegate = newValue
//       }
//    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(engine: FlutterEngine, nibName: String?, bundle nibBundle: Bundle?) {
        
        super.init(engine: engine, nibName: nibName, bundle: nibBundle)
        // 创建Method Channel
        methodChannel = createMethodChannel(channelName: FlutterMeteor.HzRouterMethodChannelName)
        FlutterMeteor.saveEngine(engine: engine, flutterVc: self)
        FlutterMeteor.pluginRegistDelegate.register(pluginRegistry: self.pluginRegistry())
    }
    
    /***
     * @ param entryPoint flutter 端入口函数
     * @ param initialRoute flutter端页面路由
     * @ param entrypointArgs 参数
     * @ param popCallBack 退出页面的回调
     */
    public convenience init (entryPoint: String?,
         entrypointArgs: Dictionary<String, Any>?,
         initialRoute: String?,
         popCallBack: FlutterMeteorPopCallBack?
    ) {
        // 创建新的引擎
        let flutterEngine = FlutterMeteor.createFlutterEngine(entryPoint: entryPoint, initialRoute: initialRoute, entrypointArgs: entrypointArgs)
        // 初始化VC
        self.init(engine: flutterEngine, nibName: nil, bundle: nil)
        self.popCallBack = popCallBack
       
    }
    
    /***
     * @ param entryPoint flutter 端入口函数
     * @ param initialRoute flutter端页面路由
     * @ param entrypointArgs 参数
     * @ param popCallBack 退出页面的回调
     */
    public convenience init (entryPoint: String?,
          entrypointArgs: Dictionary<String, Any>?,
          initialRoute: String?,
           nibName: String?,
           bundle: Bundle?,
      popCallBack: FlutterMeteorPopCallBack?
    ) {
         // 创建新的引擎
         let flutterEngine = FlutterMeteor.createFlutterEngine(entryPoint: entryPoint, initialRoute: initialRoute, entrypointArgs: entrypointArgs)
         // 初始化VC
         self.init(engine: flutterEngine, nibName: nibName, bundle: bundle)
        self.popCallBack = popCallBack
     }
    
    
    func createMethodChannel(channelName:String) -> FlutterMethodChannel {
        
        let channel = FlutterMethodChannel(name: channelName, binaryMessenger: self.binaryMessenger)
        channel.setMethodCallHandler {[weak self] call, result in
            self?.handleFlutterMethodCall(call, result: result)
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
        print("current engins \(FlutterMeteor.engineCache.count())")
//        HzEngineManager.printCache()
    }
    
    public func pop(options: FMMeteorOptions?) {
        FMNativeNavigator.pop()
        popCallBack?(options?.arguments)
    }
}
