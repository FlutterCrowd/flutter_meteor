//
//  MeteorFlutterViewController.swift
//  FlutterMeteor
//
//  Created by itbox_djx on 2024/5/9.
//

import Flutter

// public typealias FlutterMeteorPopCallBack = (_ response: Dictionary<String, Any>?) -> Void

public class MeteorFlutterViewController: FlutterViewController, MeteorNavigatorDelegate {
    var methodChannel: FlutterMethodChannel?
//    var popCallBack: FlutterMeteorPopCallBack?

    var canFlutterPop: Bool = false

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override private init(engine: FlutterEngine, nibName: String?, bundle nibBundle: Bundle?) {
        super.init(engine: engine, nibName: nibName, bundle: nibBundle)
        // 创建Method Channel
        FlutterMeteor.pluginRegistryDelegate.register(pluginRegistry: pluginRegistry())
    }

    public convenience init(isMainEngine: Bool) {
        let options = MeteorEngineGroupOptions(isMain: isMainEngine)
        // 创建新的引擎
        let flutterEngine = MeteorEngineManager.createFlutterEngine(options: options)
        // 初始化VC
        self.init(engine: flutterEngine, nibName: nil, bundle: nil)
    }

    /***
     * @ param options FMEngineGroupOptions
     * @ param popCallBack 退出页面的回调
     */
    public convenience init(
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
    public convenience init(
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
        let channel = FlutterMethodChannel(name: FMNavigatorMethodChannelName, binaryMessenger: binaryMessenger)
        channel.setMethodCallHandler { [weak self] call, result in
            self?.handleFlutterMethodCall(call, result: result)
        }
        return channel
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupNavigatorObserverChannel()
        let channelProvider = FlutterMeteorPlugin.channelProvider(with: pluginRegistry())
        var _methodChannel: FlutterMethodChannel? = channelProvider?.navigatorChannel
        if _methodChannel == nil {
            _methodChannel = createMethodChannel()
        } else {
            _methodChannel!.setMethodCallHandler { [weak self] call, result in
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
        view.subviews.forEach { $0.removeFromSuperview() }
    }

//    public func pop(options: MeteorPopOptions?) {
//        MeteorNavigator.pop()
//        popCallBack?(options?.result)
//    }
    ////
//    public func popUntil(untilRouteName: String?, options: MeteorPopOptions?) {
//        MeteorNavigator.popUntil(untilRouteName: untilRouteName, options: options)
//        if untilRouteName == self.routeName {
//            popCallBack?(options?.result)
//        }
//    }

    func setupNavigatorObserverChannel() {
        let methodChannel = FlutterBasicMessageChannel(name: "itbox.meteor.navigatorObserver", binaryMessenger: binaryMessenger, codec: FlutterStandardMessageCodec.sharedInstance())
        methodChannel.setMessageHandler { [weak self] arguments, _ in
            if let map = arguments as? [String: Any] {
                if map["event"] as! String == "canPop" { /// 当FLutter端可以pop时，禁用原生PopGesture手势，当FLutter不可以pop时，开启PopGesture手势以支持原生右滑退出页面
                    let canPop: Bool = map["data"] as? Bool ?? false
                    self?.canFlutterPop = canPop
                    if canPop {
                        self?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    } else {
                        self?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    }
                }
            }
        }
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /// 当页面消失时默认支持右滑退出页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}
