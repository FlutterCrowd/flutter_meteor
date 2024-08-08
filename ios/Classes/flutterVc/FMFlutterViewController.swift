//
//  FMFlutterViewController.swift
//  FlutterMeteor
//
//  Created by itbox_djx on 2024/5/9.
//

import Flutter

public typealias FlutterMeteorPopCallBack = (_ response: Dictionary<String, Any>?) -> Void


public class FMFlutterViewController: FlutterViewController, FMNavigatorDelegate  {
    
    
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
        let flutterEngine = FMEngineManager.createFlutterEngine()
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
        let flutterEngine = FMEngineManager.createFlutterEngine(options: options)
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
         let flutterEngine = FMEngineManager.createFlutterEngine(options: options)
         // 初始化VC
         self.init(engine: flutterEngine, nibName: nibName, bundle: bundle)
         self.popCallBack = popCallBack
     }
    
    
    func createMethodChannel() -> FlutterMethodChannel {
        let channel = FlutterMethodChannel(name: FMNavigatorMethodChannelName, binaryMessenger: self.binaryMessenger)
        channel.setMethodCallHandler {[weak self] call, result in
            self?.handleFlutterMethodCall(call, result: result)    }
        return channel
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        let channelProvider = FlutterMeteorPlugin.channelProvider(with: self.pluginRegistry())
        var _methodChannel: FlutterMethodChannel? = channelProvider?.navigatorChannel
        if (_methodChannel == nil) {
            _methodChannel = createMethodChannel()
//            FlutterMeteor.saveMehtodChannel(key: self.binaryMessenger, chennel: _methodChannel!)
        } else {
            _methodChannel!.setMethodCallHandler {[weak self] call, result in
                self?.handleFlutterMethodCall(call, result: result)
            }
//            print("-------:\(channelHolder?.registrar.messenger())")
//            print("-------:\(self.binaryMessenger)")
//            print("-------:\(self.engine?.binaryMessenger)")
//            print("-------:\(FMEngineManager.engineCache[channelHolder!.registrar.messenger()])")
//            print("-------:\(FMEngineManager.engineCache[self.binaryMessenger])")
//            print("-------:\(self.engine)")
//            print("-------:\(FMEngineManager.engineCache.allObjects())")
//            print("-------:\(FMEngineManager.engineCache)")

        }
        methodChannel = _methodChannel
//        print("-----+viewWillAppear FlutterMeteorPluginPubish:\(String(describing: self.pluginRegistry().valuePublished(byPlugin: "FlutterMeteorPlugin")))")
    }
    

    deinit {
        
//        print("-----+deinit CurrentEngineId:\(String(describing: self.engine?.isolateId))")
//        print("-----+deinit FlutterMeteorPluginPubish:\(String(describing: self.pluginRegistry().valuePublished(byPlugin: "FlutterMeteorPlugin")))")
        
        FlutterMeteor.pluginRegistryDelegate.unRegister(pluginRegistry: self.pluginRegistry())
//        print("channelList: \(FlutterMeteor.channelList.allObjects)")
//        print("HzFlutterViewController did deinit")
//        FlutterMeteor.removeMehtodChannel(key: self.binaryMessenger)
    }
    
    public func pop(options: FMPopOptions?) {
        FMNavigator.pop()
        popCallBack?(options?.result)
    }
    
    public func dismiss(options: FMPopOptions?) {
        FMNavigator.dismiss()
        popCallBack?(options?.result)
    }
    
    public func popUntil(untilRouteName: String?, options: FMPopOptions?) {
        FMNavigator.popUntil(untilRouteName: untilRouteName, options: options)
    }
    
}
