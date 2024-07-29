//
//  FMFlutterViewController.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/9.
//

import Flutter

public typealias FlutterMeteorPopCallBack = (_ response: Dictionary<String, Any>?) -> Void


public class FMFlutterViewController: FlutterViewController, FlutterMeteorDelegate  {
    
    
    var methodChannel: FlutterMethodChannel?
    var popCallBack: FlutterMeteorPopCallBack?
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private override init(engine: FlutterEngine, nibName: String?, bundle nibBundle: Bundle?) {
    
        super.init(engine: engine, nibName: nibName, bundle: nibBundle)
        // 创建Method Channel
        FlutterMeteor.pluginRegistryDelegate.register(pluginRegistry: self.pluginRegistry())
    }
    
    public convenience init () {
        // 创建新的引擎
        let flutterEngine = FlutterMeteor.createFlutterEngine()
        // 初始化VC
        self.init(engine: flutterEngine, nibName: nil, bundle: nil)
    }
    
    /***
     * @ param options FMEngineGroupOptions
     * @ param popCallBack 退出页面的回调
     */
    public convenience init (
        options: FMEngineGroupOptions?,
        popCallBack: FlutterMeteorPopCallBack?
    ) {
        // 创建新的引擎
        let flutterEngine = FlutterMeteor.createFlutterEngine(options: options)
        // 初始化VC
        self.init(engine: flutterEngine, nibName: nil, bundle: nil)
        self.popCallBack = popCallBack
       
    }
    
    /***
     * @ param options FMEngineGroupOptions
     * @ param nibName
     * @ param bundle
     * @ param popCallBack 退出页面的回调
     */
    public convenience init (
        options: FMEngineGroupOptions?,
        nibName: String?,
        bundle: Bundle?,
      popCallBack: FlutterMeteorPopCallBack?
    ) {
         // 创建新的引擎
         let flutterEngine = FlutterMeteor.createFlutterEngine(options: options)
         // 初始化VC
         self.init(engine: flutterEngine, nibName: nibName, bundle: bundle)
         self.popCallBack = popCallBack
     }
    
    
    func createMethodChannel() -> FlutterMethodChannel {
        let channel = FlutterMethodChannel(name: FMRouterMethodChannelName, binaryMessenger: self.binaryMessenger)
        channel.setMethodCallHandler {[weak self] call, result in
            self?.handleFlutterMethodCall(call, result: result)    }
        return channel
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        var _methodChannel: FlutterMethodChannel? = FlutterMeteor.methodChannel(flutterVc: self)
        if (_methodChannel == nil) {
            _methodChannel = createMethodChannel()
            FlutterMeteor.saveMehtodChannel(key: self.binaryMessenger, chennel: _methodChannel!)
        } else {
            _methodChannel!.setMethodCallHandler {[weak self] call, result in
                self?.handleFlutterMethodCall(call, result: result)
            }
        }
        methodChannel = _methodChannel
    }
    

    deinit {
        FlutterMeteor.pluginRegistryDelegate.unRegister(pluginRegistry: self.pluginRegistry())
        print("channelList: \(FlutterMeteor.channelList.allObjects)")
        print("HzFlutterViewController did deinit")
        FlutterMeteor.sremoveMehtodChannel(key: self.binaryMessenger)
    }
    
    public func pop(options: FMPopOptions?) {
        FMNativeNavigator.pop()
        popCallBack?(options?.result)
    }
    
    public func dismiss(options: FMPopOptions?) {
        FMNativeNavigator.pop()
        popCallBack?(options?.result)
    }
    
}
