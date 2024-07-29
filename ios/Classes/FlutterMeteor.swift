//
//  HzRouter.swift
//  multi_engin
//
//  Created by itbox_djx on 2024/5/7.
//

import Foundation
import Flutter

public class FMEngineGroupOptions {
    
    
    let entrypoint: String?
    
    let initialRoute: String?
    
    let entrypointArgs: Dictionary<String, Any>?
    
    let libraryURI: String?
    
    public init(entrypoint: String? = "main",
         initialRoute: String? = nil,
         entrypointArgs: Dictionary<String, Any>? = nil,
         libraryURI: String? = nil) {
        self.entrypoint = entrypoint
        self.initialRoute = initialRoute
        self.entrypointArgs = entrypointArgs
        self.libraryURI = libraryURI
    }
    
}

//
public protocol FMNewEnginePluginRegistryDelegate {
    // GeneratedPluginRegistrant.register(with: self) 方法需要在这里调用
    func register(pluginRegistry: any FlutterPluginRegistry)
    // 对应的引擎销毁的时候会调用此方法
    func unRegister(pluginRegistry: any FlutterPluginRegistry)
}


public class FlutterMeteor  {
 
    // 多引擎插件初始化
    //
    // @param pluginRegistryDelegate FMNewEnginePluginRegistryDelegate
    public static func setUp(pluginRegistryDelegate: FMNewEnginePluginRegistryDelegate) {
        // method switch
        UIViewController.fmInitializeSwizzling
        FlutterMeteor.pluginRegistryDelegate = pluginRegistryDelegate
    }
    
    // 自定义路由代理
    public static var customRouterDelegate: (any FlutterMeteorCustomDelegate)?
    
    // 注册插件代理
    public static var  pluginRegistryDelegate: FMNewEnginePluginRegistryDelegate!
 
  
    private static let flutterEngineGroup = FlutterEngineGroup(name: "itbox.meteor.flutterEnginGroup", project: nil)
    private static let channelMap = FMWeakDictionary<AnyObject, FlutterMethodChannel>()
    private static let _channelList = FMWeakArray<FlutterMethodChannel>()
    public static let HzRouterMethodChannelName = "itbox.meteor.channel"

    static var channelList: FMWeakArray<FlutterMethodChannel> {
        get {
            return _channelList
        }
    }
    
    public static func saveMehtodChannel(key: AnyObject, chennel: FlutterMethodChannel) {
        channelMap[key] = chennel
        _channelList.add(chennel)
    }
    
    public static func sremoveMehtodChannel(key: AnyObject) {
        guard let channel = channelMap[key] else { 
            print("No channel for key: \(key)")
            return
        }
        channelMap.removeObject(forKey: key)
        _channelList.remove(channel)
    }
    
    public static func methodChannel(flutterVc: FlutterViewController) -> FlutterMethodChannel? {
        var channel: FlutterMethodChannel?
        if flutterVc.engine != nil {
            channel = channelMap[flutterVc.engine!]
        }
        if(channel == nil) {
            channel = channelMap[flutterVc.binaryMessenger as! NSObject]
        }
        return channel
    }
    
    public static func sendEvent(eventName: String, arguments: Any?) {

        var methodAguments: Dictionary<String, Any> = Dictionary<String, Any> .init()
        methodAguments["eventName"] = eventName
        methodAguments["arguments"] = arguments ?? Dictionary<String, Any> .init()
        channelList.allObjects.forEach { channel in
            print("FlutterMeteor start channel:\(channel.description) invoke method: \(FMMultiEngineEventCallMethod), eventName:\(eventName)")
            channel.save_invoke(method: FMMultiEngineEventCallMethod, arguments: arguments)
//            channel.save_invokeMethod(FMMultiEngineEventCallMethod, arguments: methodAguments)
        }
    }

    public static func createRouterMethodChannel (binaryMessenger: any FlutterBinaryMessenger, result: @escaping FlutterMethodCallHandler) -> FlutterMethodChannel {
        let channel = FlutterMethodChannel(name: HzRouterMethodChannelName, binaryMessenger: binaryMessenger)
        channel.setMethodCallHandler(result)
        return channel
    }
      
    public static func createFlutterEngine(options: FMEngineGroupOptions? = nil) -> FlutterEngine  {
      
        var arguments: Dictionary<String, Any> = Dictionary<String, Any>.init()

        let initialRoute = options?.initialRoute
        let entrypointArgs = options?.entrypointArgs
        if(initialRoute != nil) {
            arguments["initialRoute"] = initialRoute
        }
        if(initialRoute != nil) {
            arguments["routeArguments"] = entrypointArgs
        }
        
        var entrypointArgList:Array<String> = Array<String>.init()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arguments, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                entrypointArgList.append(jsonString)
            }
        } catch {
            print("Error converting dictionary to JSON")
        }
        
        // 创建新引擎
        let engineGroupOptions = FlutterEngineGroupOptions.init()
        engineGroupOptions.entrypoint = options?.entrypoint
        engineGroupOptions.initialRoute = initialRoute
        engineGroupOptions.entrypointArgs = entrypointArgList
        engineGroupOptions.libraryURI = options?.libraryURI
        let flutterEngine = flutterEngineGroup.makeEngine(with: engineGroupOptions)
        return flutterEngine
    }
    
}
