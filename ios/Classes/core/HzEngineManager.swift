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
        let flutterEngine = flutterEngineGroup.makeEngine(withEntrypoint: entryPoint, libraryURI: nil, initialRoute: initialRoute)
        return flutterEngine
    }
    

    public static func createFlutterEngine(
        entryPoint: String?,
        initialRoute: String?,
        entrypointArgs: Dictionary<String, Any>?
    ) -> FlutterEngine  {
      
        var entrypointArgList:Array<String> = Array<String>.init()
        if (initialRoute != nil) {
            entrypointArgList.append(initialRoute ?? "/")
        }
        if (entrypointArgs != nil) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: entrypointArgs!, options: .prettyPrinted)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    entrypointArgList.append(jsonString)
                }
            } catch {
                print("Error converting dictionary to JSON")
            }
        }
        
        // 创建新引擎
        let engineGroupOptions = FlutterEngineGroupOptions.init()
        engineGroupOptions.entrypoint = entryPoint
        engineGroupOptions.initialRoute = initialRoute
        engineGroupOptions.entrypointArgs = entrypointArgList
        let flutterEngine = flutterEngineGroup.makeEngine(with: engineGroupOptions)
        return flutterEngine
    }
    
    public static func createFlutterEngine(
        entryPoint: String?,
        initialRoute: String?,
        entrypointArgs: Dictionary<String, Any>?,
        libraryURI: String?
    ) -> FlutterEngine  {
      
        var entrypointArgList:Array<String> = Array<String>.init()
        if (initialRoute != nil) {
            entrypointArgList.append(initialRoute ?? "/")
        }
        if (entrypointArgs != nil) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: entrypointArgs!, options: .prettyPrinted)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    entrypointArgList.append(jsonString)
                }
            } catch {
                print("Error converting dictionary to JSON")
            }
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
    
//    public static func createFlutterEngineModel(
//        flutterEngine: FlutterEngine,
//        callBack: @escaping HzMethodCallBack
//    ) -> HzFlutterEngineModel {
//            
//        flutterEngine.viewController = nil;
//        // 创建flutter Vc 绑定新引擎
//        let flutterViewController = HzFlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
//        // 创建flutter Channel 绑定VC（新引擎）
//        let channel = createRouterMethodChannel(binaryMessenger: flutterViewController.binaryMessenger) { call, result in
//            result(callBack(call.method, call.arguments, flutterViewController))
////            if (call.arguments is Dictionary<String, Any>) {
////                result(callBack(call.method, call.arguments as! Dictionary<String, Any>, flutterViewController))
////            } else {
////                var arguments = Dictionary<String, Any>.init()
////                arguments["arguments"] = call.arguments
////                result(callBack(call.method, arguments, flutterViewController))
////            }
//            if(call.method == "pop" || call.method == "popToRoot") {
//                flutterEngine.viewController = nil
//                let engineModel: HzFlutterEngineModel? = engineCache[flutterViewController] as? HzFlutterEngineModel
//                engineModel?.clear()
//                engineCache.removeObject(forKey: flutterViewController)
//            }
//        }
//        
//       // 缓存引擎、methodChannel、ViewController
//        let engineModel = HzFlutterEngineModel.init(viewController: flutterViewController, engine: flutterEngine, methodChannel: channel)
//        engineCache[flutterViewController] = engineModel
//        return engineModel
//    }
//    
//    public static func createFlutterVC (
//        callBack: @escaping HzMethodCallBack
//    ) -> FlutterViewController {
//        
//        // 通过group创建新引擎
//        let flutterEngine = flutterEngineGroup.makeEngine(with: nil)
//        flutterEngine.viewController = nil;
//
//        // 创建flutterVC 和 method Channel
//        let engineModel = createFlutterEngineModel(flutterEngine: flutterEngine, callBack: callBack)
//        return engineModel.viewController
//    }
//    
//    public static func createFlutterVC(
//        entryPoint: String?,
//        callBack: @escaping HzMethodCallBack
//    ) -> FlutterViewController? {
//        
//        // 创建新引擎
//        let flutterEngine = flutterEngineGroup.makeEngine(withEntrypoint: entryPoint, libraryURI: nil)
//        flutterEngine.viewController = nil;
//
//        // 创建flutterVC 和 method Channel
//        let engineModel = createFlutterEngineModel(flutterEngine: flutterEngine, callBack: callBack)
//        return engineModel.viewController
//    }
//    
//    public static func createFlutterVC(
//        entryPoint: String?,
//        entrypointArgs: Dictionary<String, Any>?,
//        initialRoute: String?,
//        callBack: @escaping HzMethodCallBack
//    ) -> FlutterViewController {
//      
//        var entrypointArgList:Array<String> = Array<String>.init()
//        if (initialRoute != nil) {
//            entrypointArgList.append(initialRoute ?? "/")
//        }
//        if (entrypointArgs != nil) {
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: entrypointArgs!, options: .prettyPrinted)
//                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                    entrypointArgList.append(jsonString)
//                }
//            } catch {
//                print("Error converting dictionary to JSON")
//            }
//        }
//        
//        // 创建新引擎
//        let engineGroupOptions = FlutterEngineGroupOptions.init()
//        engineGroupOptions.entrypoint = entryPoint
//        engineGroupOptions.initialRoute = initialRoute
//        engineGroupOptions.entrypointArgs = entrypointArgList
//        let flutterEngine = flutterEngineGroup.makeEngine(with: engineGroupOptions)
//        flutterEngine.viewController = nil;
//    
//        // 创建flutterVC 和 method Channel
//        let engineModel = createFlutterEngineModel(flutterEngine: flutterEngine, callBack: callBack)
//        return engineModel.viewController
//    }
//    
//    
//    public static func createDefaultFlutterVC (
//        callBack: @escaping HzMethodCallBack
//    ) -> FlutterViewController {
//        
//        let flutterViewController = HzFlutterViewController()
//        let channel = createRouterMethodChannel(binaryMessenger: flutterViewController.binaryMessenger) { call, result in
//            
//            result(callBack(call.method, call.arguments, flutterViewController))
////            if (call.arguments is Dictionary<String, Any>) {
////                result(callBack(call.method, call.arguments as! Dictionary<String, Any>, flutterViewController))
////            } else {
////                var arguments = Dictionary<String, Any>.init()
////                arguments["arguments"] = call.arguments
////                result(callBack(call.method, arguments, flutterViewController))
////            }
//            let engineModel: HzFlutterEngineModel? = engineCache[flutterViewController] as? HzFlutterEngineModel
//            engineModel?.clear()
//            engineCache.removeObject(forKey: flutterViewController)
//        }
//        let engineModel = HzFlutterEngineModel.init(viewController: flutterViewController, engine: nil, methodChannel: channel)
//        engineCache[flutterViewController] = engineModel
//        return flutterViewController
//    }
//}
    
//    public static func createFlutterVC (
//        callBack: HzMethodCallBack?
//    ) -> FlutterViewController? {
//        
//        let flutterEngine = FlutterEngine(name:"cn.itbox.driver.engine.\(Date.timeIntervalSinceReferenceDate)", project: nil)
//        let ret = flutterEngine.run()
//        flutterEngine.viewController = nil;
//        
//        if(ret) {
//            let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
//            let channel = FlutterMethodChannel(name:"cn.itbox.driver/multi_engin", binaryMessenger: flutterViewController.binaryMessenger)
//            // 监听Flutter发送的消息
//            channel.setMethodCallHandler({
//                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//                if (callBack == nil) {
//                    
//                } else {
//                    if (call.arguments is Dictionary<String, Any>) {
//    
//                        result(callBack?(call.method, call.arguments! as! Dictionary<String, Any>, flutterViewController))
//                    } else {
//                        result(callBack?(call.method, Dictionary<String, Any>.init(), flutterViewController))
//                    }
//                }
//                flutterEngine.viewController = nil
//            })
//            return flutterViewController
//        } else {
//            return nil;
//        }
//    }
//    
//    public static func createFlutterVCWithEntryPoint (
//        entryPoint: String?,
//        callBack: HzMethodCallBack?
//    ) -> FlutterViewController? {
//        
//        let flutterEngine = FlutterEngine(name:"cn.itbox.driver.engine.\(Date.timeIntervalSinceReferenceDate)", project: nil)
//        let ret = flutterEngine.run(withEntrypoint: entryPoint)
//        flutterEngine.viewController = nil;
//        
//        if (ret) {
//            let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
//            let channel = FlutterMethodChannel(name:"cn.itbox.driver/multi_engin", binaryMessenger: flutterViewController.binaryMessenger)
//            // 监听Flutter发送的消息
//            channel.setMethodCallHandler({
//                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//                if (callBack == nil) {
//                    
//                } else {
//                    if (call.arguments is Dictionary<String, Any>) {
//                        result(callBack?(call.method, call.arguments as! Dictionary<String, Any>, flutterViewController))
//                    } else {
//                        result(callBack?(call.method, Dictionary<String, Any>.init(), flutterViewController))
//                    }
//                }
//                flutterEngine.viewController = nil
//            })
//            return flutterViewController
//        } else {
//            return nil;
//        }
//    }
//    
//    public static func creatCustomFlutterVC(
//        entryPoint: String?,
//        entrypointArgs: Dictionary<String, Any>?,
//        initialRoute: String?,
//        callBack: @escaping HzMethodCallBack
//    ) -> FlutterViewController? {
//        let flutterEngine = FlutterEngine(name:"cn.itbox.driver.engine.\(Date.timeIntervalSinceReferenceDate)", project: nil)
//        var entrypointArgList:Array<String> = Array<String>.init()
//        if (initialRoute != nil) {
//            entrypointArgList.append(initialRoute ?? "/")
//        }
//        if (entrypointArgs != nil) {
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: entrypointArgs!, options: .prettyPrinted)
//                if let jsonString = String(data: jsonData, encoding: .utf8) {
//                    entrypointArgList.append(jsonString)
//                }
//            } catch {
//                print("Error converting dictionary to JSON")
//            }
//        }
//        let ret = flutterEngine.run(withEntrypoint: entryPoint, libraryURI: nil, initialRoute: initialRoute, entrypointArgs: entrypointArgList)
//        if (ret) {
//            flutterEngine.viewController = nil;
//            
//            let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
//            let channel = FlutterMethodChannel(name:"cn.itbox.driver/multi_engin", binaryMessenger: flutterViewController.binaryMessenger)
//                      
//            // 监听Flutter发送的消息
//            channel.setMethodCallHandler({
//                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//                if (call.arguments is Dictionary<String, Any>) {
//                    result(callBack(call.method, call.arguments as! Dictionary<String, Any>, flutterViewController))
//                } else {
//                    result(callBack(call.method, Dictionary<String, Any>.init(), flutterViewController))
//                }
//                flutterEngine.viewController = nil
//            })
//            return flutterViewController
//        } else {
//            return nil
//        }
//    }
//    
//    
//    public static func createDefaultFlutterVC (
//        callBack: HzMethodCallBack?
//    ) -> FlutterViewController {
//        
//        let flutterViewController = FlutterViewController()
//        let channel = FlutterMethodChannel(name:"cn.itbox.driver/multi_engin", binaryMessenger: flutterViewController.binaryMessenger)
//        // 监听Flutter发送的消息
//        channel.setMethodCallHandler({
//            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//            if (callBack == nil) {
//                
//            } else {
//                if (call.arguments is Dictionary<String, Any>) {
//                    result(callBack?(call.method, call.arguments as! Dictionary<String, Any>, flutterViewController))
//                } else {
//                    result(callBack?(call.method, Dictionary<String, Any>.init(), flutterViewController))
//                }
//            }
//            
//        })
//        return flutterViewController
//    }
}

