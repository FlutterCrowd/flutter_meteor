//
//  MultiEngineManager.swift
//  multi_engin
//
//  Created by itbox_djx on 2024/5/7.
//

import UIKit
import Foundation
import Flutter

public typealias HzMethodCallBack = (_ method:String, _ arguments:Dictionary<String, Any>, _ flutterVc:FlutterViewController) -> Any
public class HzEngineManager {
    
    public static let flutterEngineGroup = FlutterEngineGroup(name: "cn.itbox.router.flutterEnginGroup", project: nil)
    
    public static func createFlutterVC (
        callBack: HzMethodCallBack?
    ) -> FlutterViewController? {
        

        let flutterEngine = flutterEngineGroup.makeEngine(with: nil)
        let ret = flutterEngine.run()
        flutterEngine.viewController = nil;
        
        if(ret) {
            let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
            let channel = FlutterMethodChannel(name:"cn.itbox.driver/multi_engin", binaryMessenger: flutterViewController.binaryMessenger)
            // 监听Flutter发送的消息
            channel.setMethodCallHandler({
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                if (callBack == nil) {
                    
                } else {
                    if (call.arguments is Dictionary<String, Any>) {
    
                        result(callBack?(call.method, call.arguments! as! Dictionary<String, Any>, flutterViewController))
                    } else {
                        result(callBack?(call.method, Dictionary<String, Any>.init(), flutterViewController))
                    }
                }
                flutterEngine.viewController = nil
            })
            return flutterViewController
        } else {
            return nil;
        }
    }
    
    public static func createFlutterVCWithEntryPoint (
        entryPoint: String?,
        callBack: HzMethodCallBack?
    ) -> FlutterViewController? {
        
        let flutterEngine = flutterEngineGroup.makeEngine(withEntrypoint: entryPoint, libraryURI: nil)
        
        flutterEngine.viewController = nil;
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        let channel = FlutterMethodChannel(name:"cn.itbox.driver/multi_engin", binaryMessenger: flutterViewController.binaryMessenger)
        // 监听Flutter发送的消息
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (callBack == nil) {
                
            } else {
                if (call.arguments is Dictionary<String, Any>) {
                    result(callBack?(call.method, call.arguments as! Dictionary<String, Any>, flutterViewController))
                } else {
                    result(callBack?(call.method, Dictionary<String, Any>.init(), flutterViewController))
                }
            }
            flutterEngine.viewController = nil
        })
        return flutterViewController
    }
    
    public static func creatCustomFlutterVC(
        entryPoint: String?,
        entrypointArgs: Dictionary<String, Any>?,
        initialRoute: String?,
        callBack: @escaping HzMethodCallBack
    ) -> FlutterViewController? {
      
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
        
        let engineGroupOptions = FlutterEngineGroupOptions.init()
        engineGroupOptions.entrypoint = entryPoint
        engineGroupOptions.initialRoute = initialRoute
        engineGroupOptions.entrypointArgs = entrypointArgList
        
        let flutterEngine = flutterEngineGroup.makeEngine(with: engineGroupOptions)
        flutterEngine.viewController = nil;
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        let channel = FlutterMethodChannel(name:"cn.itbox.driver/multi_engin", binaryMessenger: flutterViewController.binaryMessenger)
                  
        // 监听Flutter发送的消息
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.arguments is Dictionary<String, Any>) {
                result(callBack(call.method, call.arguments as! Dictionary<String, Any>, flutterViewController))
            } else {
                result(callBack(call.method, Dictionary<String, Any>.init(), flutterViewController))
            }
            flutterEngine.viewController = nil
        })
        return flutterViewController
    }
    
    
    public static func createDefaultFlutterVC (
        callBack: HzMethodCallBack?
    ) -> FlutterViewController {
        
        let flutterViewController = FlutterViewController()
        let channel = FlutterMethodChannel(name:"cn.itbox.driver/multi_engin", binaryMessenger: flutterViewController.binaryMessenger)
        // 监听Flutter发送的消息
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (callBack == nil) {
                
            } else {
                if (call.arguments is Dictionary<String, Any>) {
                    result(callBack?(call.method, call.arguments as! Dictionary<String, Any>, flutterViewController))
                } else {
                    result(callBack?(call.method, Dictionary<String, Any>.init(), flutterViewController))
                }
            }
            
        })
        return flutterViewController
    }
}
    
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
//}

