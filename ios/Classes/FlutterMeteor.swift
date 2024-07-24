//
//  HzRouter.swift
//  multi_engin
//
//  Created by itbox_djx on 2024/5/7.
//

import Foundation
import Flutter

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
    // @param pluginRegistryDelegate 注册插件的回调FMNewEnginePluginRegistryDelegate
    // @return void
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
    private static let engineCache = FMWeakDictionary<FlutterEngine, FlutterMethodChannel>()
    private static let _channelList = FMWeakArray<FlutterMethodChannel>()
    public static let HzRouterMethodChannelName = "itbox.meteor.channel"

    static var channelList: FMWeakArray<FlutterMethodChannel> {
        get {
            return _channelList
        }
    }
    
    public static func saveMehtodChannel(engine: FlutterEngine, chennel: FlutterMethodChannel) {
        engineCache[engine] = chennel
        _channelList.add(chennel)
        print("channelList: \(channelList.allObjects), chennel: \(chennel)")
    }
    
    public static func methodChannel(engine: FlutterEngine) -> FlutterMethodChannel? {
        return engineCache[engine]
    }
    
    public static func sendEvent(eventName: String, arguments: Any?) {

        var methodAguments: Dictionary<String, Any> = Dictionary<String, Any> .init()
        methodAguments["eventName"] = eventName
        methodAguments["arguments"] = arguments ?? Dictionary<String, Any> .init()
        channelList.allObjects.forEach { channel in
            print("FlutterMeteor start channel:\(channel.description) invoke method: \(FMMultiEngineEventCallMethod), eventName:\(eventName)")
            channel.invokeMethod(FMMultiEngineEventCallMethod, arguments: methodAguments)
        }
    }

    public static func createRouterMethodChannel (binaryMessenger: any FlutterBinaryMessenger, result: @escaping FlutterMethodCallHandler) -> FlutterMethodChannel {
        let channel = FlutterMethodChannel(name: HzRouterMethodChannelName, binaryMessenger: binaryMessenger)
        channel.setMethodCallHandler(result)
        return channel
    }
    
    
    public static func createFlutterEngine() -> FlutterEngine  {
        let flutterEngine = flutterEngineGroup.makeEngine(with: nil)
        return flutterEngine
    }

    public static func createFlutterEngine(entryPoint: String?, initialRoute: String?) -> FlutterEngine  {
        return createFlutterEngine(entryPoint: nil, initialRoute: initialRoute, entrypointArgs: nil, libraryURI: nil)
    }
    

    public static func createFlutterEngine(
        entryPoint: String?,
        initialRoute: String?,
        entrypointArgs: Dictionary<String, Any>?
    ) -> FlutterEngine  {
      
        return createFlutterEngine(entryPoint: entryPoint, initialRoute: initialRoute, entrypointArgs: entrypointArgs, libraryURI: nil)
    }
    
    public static func createFlutterEngine(
        entryPoint: String?,
        initialRoute: String?,
        entrypointArgs: Dictionary<String, Any>?,
        libraryURI: String?
    ) -> FlutterEngine  {
      
        var arguments: Dictionary<String, Any> = Dictionary<String, Any>.init()

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
        engineGroupOptions.entrypoint = entryPoint
        engineGroupOptions.initialRoute = initialRoute
        engineGroupOptions.entrypointArgs = entrypointArgList
        engineGroupOptions.libraryURI = libraryURI
        let flutterEngine = flutterEngineGroup.makeEngine(with: engineGroupOptions)
        return flutterEngine
    }
    
}
