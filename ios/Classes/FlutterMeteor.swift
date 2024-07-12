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
    func register(pluginRegistry: any FlutterPluginRegistry)
    func unRegister(pluginRegistry: any FlutterPluginRegistry)
}


public class FlutterMeteor  {
 
    // 自定义路由代理
    public static var customRouterDelegate: (any FlutterMeteorCustomDelegate)?
    
    // 主引擎路由代理
    public static var mainEnginRouterDelegate: (any FlutterMeteorDelegate)?

    private static var mainEngineFlutterNaviagtor: FMFlutterNavigator?
    
    public static var flutterRootEngineMethodChannel: FlutterMethodChannel!

    
    // 主引擎MethodChannel
    public static var flutterNavigator: FMFlutterNavigator {
        get {
            if (mainEngineFlutterNaviagtor == nil) {
                mainEngineFlutterNaviagtor = FMFlutterNavigator.init(methodChannel: flutterRootEngineMethodChannel)
            }
            return mainEngineFlutterNaviagtor!
        }
        set {
            mainEngineFlutterNaviagtor = newValue
        }
    }
    
    public static var  pluginRegistryDelegate: FMNewEnginePluginRegistryDelegate!
 
 
    
    public static let flutterEngineGroup = FlutterEngineGroup(name: "itbox.meteor.flutterEnginGroup", project: nil)
    public static let engineCache = FMWeakDictionary<FlutterEngine, FlutterMethodChannel>()
    static let _channelList = FMWeakArray<FlutterMethodChannel>()
    public static let HzRouterMethodChannelName = "itbox.meteor.channel"

    static var channelList: FMWeakArray<FlutterMethodChannel> {
        get {
            if(!_channelList.contains(flutterRootEngineMethodChannel)) {
                _channelList.add(flutterRootEngineMethodChannel)
            }
            return _channelList
        }
    }
    
    public static func saveEngine(engine: FlutterEngine, chennel: FlutterMethodChannel) {
        engineCache[engine] = chennel
        channelList.add(chennel)
    }
    
    public static func channel(engine: FlutterEngine) -> FlutterMethodChannel? {
        return engineCache[engine]
    }
    
    public static func sendEvent(eventName: String, arguments: Any?) {
        print("FlutterMeteor start invoke channel:\(flutterRootEngineMethodChannel.description), method: \(FMMultiEngineEventCallMethod), eventName:\(eventName), arguments:\(String(describing: arguments))")
        var methodAguments: Dictionary<String, Any> = Dictionary<String, Any> .init()
        methodAguments["eventName"] = eventName
        methodAguments["arguments"] = arguments ?? Dictionary<String, Any> .init()
        flutterRootEngineMethodChannel.invokeMethod(FMMultiEngineEventCallMethod, arguments: methodAguments)
        for key in engineCache.mapTable.keyEnumerator() {
            if let key = key as? FlutterEngine,
               let channel: FlutterMethodChannel = engineCache.mapTable.object(forKey: key) {
                print("FlutterMeteor start channel:\(channel.description) invoke method: \(FMMultiEngineEventCallMethod), eventName:\(eventName)")
                channel.invokeMethod(FMMultiEngineEventCallMethod, arguments: methodAguments)
                
            }
        }
    }
    
    public static func sendEventWithEngine(engine: FlutterEngine, eventName: String, arguments: Dictionary<String, Any>?, result: FlutterResult?) {
        let  channel: FlutterMethodChannel? =  channel(engine: engine)
        var methodAguments: Dictionary<String, Any?> = Dictionary<String, Any?> .init()
        methodAguments["eventName"] = eventName
        methodAguments["arguments"] = arguments
        channel?.invokeMethod(FMMultiEngineEventCallMethod, arguments: methodAguments)
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
    
    public static func createFlutterEngine(entryPoint: String?) -> FlutterEngine  {
        let flutterEngine = flutterEngineGroup.makeEngine(withEntrypoint: entryPoint, libraryURI: nil)
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
