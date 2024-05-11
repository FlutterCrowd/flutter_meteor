//
//  MultiEngineManager.swift
//  multi_engin
//
//  Created by itbox_djx on 2024/5/7.
//

import UIKit
import Foundation
import Flutter

public typealias HzMethodCallBack = (_ method:String, _ arguments:Any?, _ flutterVc:FlutterViewController) -> Any

public typealias HzFlutterEngineCallBack = (_ method:String, _ arguments:Dictionary<String, Any>, _ engineModel:HzFlutterEngineModel) -> Any


public class HzFlutterEngineModel: NSObject {
    
    var viewController: HzFlutterViewController
    var engine: FlutterEngine?
    var methodChannel: FlutterMethodChannel?
    
    public func clear() {
        engine?.viewController = nil
        engine = nil
        methodChannel = nil
    }
    init(viewController: HzFlutterViewController, engine: FlutterEngine?, methodChannel: FlutterMethodChannel?) {
        self.viewController = viewController
        self.engine = engine
        self.methodChannel = methodChannel
    }

}

  
public class WeakDictionary<Key: AnyObject, Value: AnyObject> {
    private let mapTable: NSMapTable<Key, Value>
      
    init() {
        mapTable = NSMapTable<Key, Value>(
            keyOptions: .weakMemory,
            valueOptions: .weakMemory,
            capacity: 0
        )
    }
      
    subscript(key: Key) -> Value? {
        get { return mapTable.object(forKey: key) }
        set { mapTable.setObject(newValue, forKey: key) }
    }
    
    public func object(forKey:Key?) {
        mapTable.object(forKey: forKey)
    }
    
    public func removeObject(forKey:Key?) {
        mapTable.removeObject(forKey: forKey)
    }
}
  
public class HzEngineManager {
    
    
    public static let flutterEngineGroup = FlutterEngineGroup(name: "cn.itbox.router.flutterEnginGroup", project: nil)
    private static let engineCache = WeakDictionary<NSObject, NSObject>()

    public static let HzRouterMethodChannelName = "cn.itbox.router.multiEngine.methodChannel"

    public static func printCache() {
        print(engineCache)
    }
    
    public static func getFlutterEngineModel(flutterVc: FlutterViewController) -> HzFlutterEngineModel? {
        return engineCache[flutterVc] as? HzFlutterEngineModel;
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
            arguments["entrypointArgs"] = entrypointArgs
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
    
    public static func createFlutterEngineNoGroup() -> FlutterEngine  {
        let flutterEngine = FlutterEngine(name: "cn.itbox.flutter.engine.name", project: nil)
        flutterEngine.run(withEntrypoint: "childEntry", initialRoute: "mine")
        return flutterEngine
    }
    
}

