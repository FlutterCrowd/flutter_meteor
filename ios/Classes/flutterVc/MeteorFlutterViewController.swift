//
//  FMFlutterViewController.swift
//  FlutterMeteor
//
//  Created by itbox_djx on 2024/5/9.
//

import Flutter


public typealias FlutterMeteorPopCallBack = (_ response: Dictionary<String, Any>?) -> Void


public class MeteorFlutterViewController: FlutterViewController, MeteorNavigatorDelegate  {
    
    var methodChannel: FlutterMethodChannel?
    var popCallBack: FlutterMeteorPopCallBack?
    
    var canFlutterPop: Bool = false

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
        let flutterEngine = MeteorEngineManager.createFlutterEngine()
        // 初始化VC
        self.init(engine: flutterEngine, nibName: nil, bundle: nil)
    }
    
    /***
     * @ param options FMEngineGroupOptions
     * @ param popCallBack 退出页面的回调
     */
    public convenience init (
        options: MeteorEngineGroupOptions?,
        popCallBack: FlutterMeteorPopCallBack?
    ) {
        // 创建新的引擎
        let flutterEngine = MeteorEngineManager.createFlutterEngine(options: options)
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
        options: MeteorEngineGroupOptions?,
        nibName: String?,
        bundle: Bundle?,
      popCallBack: FlutterMeteorPopCallBack?
    ) {
         // 创建新的引擎
         let flutterEngine = MeteorEngineManager.createFlutterEngine(options: options)
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
        self.setupNavigatorObserverChannel()
        let channelProvider = FlutterMeteorPlugin.channelProvider(with: self.pluginRegistry())
        var _methodChannel: FlutterMethodChannel? = channelProvider?.navigatorChannel
        if (_methodChannel == nil) {
            _methodChannel = createMethodChannel()
        } else {
            _methodChannel!.setMethodCallHandler {[weak self] call, result in
                self?.handleFlutterMethodCall(call, result: result)
            }
        }
        methodChannel = _methodChannel
    }
    
    deinit {
        FlutterMeteor.pluginRegistryDelegate.unRegister(pluginRegistry: self.pluginRegistry())
        removeAllSubviews()
    }
    
    func removeAllSubviews() {
            // Remove all subviews from the FlutterViewController's view
        self.view.subviews.forEach { $0.removeFromSuperview() }
    }
    
    
    public func pop(options: MeteorPopOptions?) {
        MeteorNavigator.pop()
        popCallBack?(options?.result)
    }
    
    public func dismiss(options: MeteorPopOptions?) {
        MeteorNavigator.dismiss()
        popCallBack?(options?.result)
    }
    
    public func popUntil(untilRouteName: String?, options: MeteorPopOptions?) {
        MeteorNavigator.popUntil(untilRouteName: untilRouteName, options: options)
    }
    
    func setupNavigatorObserverChannel() -> Void {

//        let methodChannel = FlutterBasicMessageChannel(name: "itbox.meteor.navigatorObserver", binaryMessenger: self.binaryMessenger, codec: FlutterStandardMessageCodec.sharedInstance())
//        methodChannel.setMessageHandler { arguments, reply in
//            if let map = arguments as? [String:Any] {
//                if map["event"] as! String == "canPop" {
//                    self.canFlutterPop = map["data"] as? Bool ?? false
//                    if self.canFlutterPop {
//                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//                    } else {
//                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                    }
//                }
//            }
//        }
    }
    
//    public override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if self.canFlutterPop {
//            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        } else {
//            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        }
//    }
//    
//    public override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//    }
    
}



//
//var last_resident_size: mach_vm_size_t = 0
//
//
//public func report_memory()->ApplicationMemoryCurrentUsage {
//    var info = mach_task_basic_info()
//    var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
//    
//    let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
//        $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
//            task_info(mach_task_self_,
//                      task_flavor_t(MACH_TASK_BASIC_INFO),
//                      $0,
//                      &count)
//        }
//    }
//    
//    if kerr == KERN_SUCCESS {
//        
//        print("Memory in use (in bytes) last: \(last_resident_size)")
//
//        print("Memory in use (in bytes) current: \(info.resident_size)")
//        
//        print("Memory in use (in bytes) change: \(info.resident_size - last_resident_size), =>\(Double((info.resident_size - last_resident_size))/(1024.0 * 1024.0))MB")
//        last_resident_size = info.resident_size
//        let usage = info.resident_size / (1024 * 1024)
//        let total = ProcessInfo.processInfo.physicalMemory / (1024 * 1024)
//        let ratio = Double(info.virtual_size) / Double(ProcessInfo.processInfo.physicalMemory)
//        return ApplicationMemoryCurrentUsage(usage: Double(usage), total: Double(total), ratio: Double(ratio))
//    }
//    else {
//        print("Error with task_info(): " +
//              (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
//        return ApplicationMemoryCurrentUsage()
//    }
//}
//    
//public struct ApplicationMemoryCurrentUsage{
//    
//    var usage : Double = 0.0
//    var total : Double = 0.0
//    var ratio : Double = 0.0
//    
//    public func toJson() -> [String:Any] {
//        return [
//            "usage": usage,
//            "total": total,
//            "ratio": ratio,
//        ]
//    }
//    
//}
