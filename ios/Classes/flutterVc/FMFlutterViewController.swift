//
//  HzFlutterViewController.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/9.
//

import Flutter

public typealias FlutterMeteorPopCallBack = (_ response: Dictionary<String, Any>?) -> Void


public class FMFlutterViewController: FlutterViewController, FlutterMeteorDelegate  {
    
    
    private var _flutterNavigator: (any FlutterMeteorDelegate)?
    
    public var flutterNavigator: any FlutterMeteorDelegate {
        get {
            return _flutterNavigator!
        }
        
        set {
            _flutterNavigator = newValue
        }
    }
    
    var methodChannel: FlutterMethodChannel?
    var popCallBack: FlutterMeteorPopCallBack?
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(engine: FlutterEngine, nibName: String?, bundle nibBundle: Bundle?) {
    
        super.init(engine: engine, nibName: nibName, bundle: nibBundle)
        // 创建Method Channel
        FlutterMeteor.pluginRegistryDelegate.register(pluginRegistry: self.pluginRegistry())
        let _methodChannel: FlutterMethodChannel = createMethodChannel()
        methodChannel = _methodChannel

        if (FlutterMeteor.flutterRootEngineMethodChannel == nil) {
            FlutterMeteor.flutterRootEngineMethodChannel = _methodChannel
        }
        FlutterMeteor.saveMehtodChannel(engine: engine, chennel: _methodChannel)
        if (FlutterMeteor.mainEnginRouterDelegate == nil) {
            FlutterMeteor.mainEnginRouterDelegate = self
        }
        
    }
    
    /***
     * @ param popCallBack 退出页面的回调
     */
    public convenience init () {
        // 创建新的引擎
        let flutterEngine = FlutterMeteor.createFlutterEngine(entryPoint: "main", initialRoute: nil)
        // 初始化VC
        self.init(engine: flutterEngine, nibName: nil, bundle: nil)
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
    
    
    func createMethodChannel() -> FlutterMethodChannel {
        let channel = FlutterMethodChannel(name: FlutterMeteor.HzRouterMethodChannelName, binaryMessenger: self.binaryMessenger)
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
        FlutterMeteor.pluginRegistryDelegate.unRegister(pluginRegistry: self.pluginRegistry())
        FlutterMeteor.engineCache.removeObject(forKey: self.engine)
        print("channelList engineCache: \(String(describing: FlutterMeteor.engineCache.allObjects()))")
        print("channelList: \(FlutterMeteor.channelList.allObjects)")
        print("HzFlutterViewController did deinit")

    }
    
    public func pop(options: FMMeteorOptions?) {
        FMNativeNavigator.pop()
        popCallBack?(options?.arguments)
    }
    
    public func dismiss(options: FMMeteorOptions?) {
        FMNativeNavigator.pop()
        popCallBack?(options?.arguments)
    }
    
}
