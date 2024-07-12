//
//  FlutterMeteorRouterManager.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/12.
//

import UIKit
import Flutter

public let FMRouteExists: String  = "routeExists";
public let FMIsRoot: String  = "isRoot";
public let FMRootRouteName: String  = "rootRouteName";
public let FMTopRouteName: String  = "topRouteName";
public let FMRouteNameStack: String  = "routeNameStack";


public typealias FMRouterBuilder = (_ arguments: Dictionary<String, Any>?) -> UIViewController


public class FlutterMeteorRouter: NSObject {
    
    public static var routerDict = Dictionary<String, FMRouterBuilder>()
    
    public static func insertRouter(routeName:String, routerBuilder: @escaping FMRouterBuilder) {
        routerDict[routeName] = routerBuilder
    }
    
    public static func routeExists(routeName:String, result: @escaping FlutterResult) {
        
        var ret = false
        for channel in FlutterMeteor.channelList.allObjects {
            if ret {
                break
            }
            channel.invokeMethod(FMRouteExists, arguments: [
                "routeName": routeName,
            ]) { data in
                if (data is Bool && !ret) {
                    ret = data as! Bool
                    result(ret)
                    return
                }
            }
        }
    }
    
    
    public static func isRoot(routeName:String, result: @escaping FlutterResult) {
//        FlutterMeteor.flutterRootEngineMethodChannel?.invokeMethod(FMIsRoot, arguments: ["routeName": routeName], result: result)

        FlutterMeteor.flutterRootEngineMethodChannel?.invokeMethod(FMIsRoot, arguments: [
            "routeName": routeName,
        ]) { ret in
            result(ret)
        }
    }
    
    public static func rootRouteName(result: @escaping FlutterResult) {
//        FlutterMeteor.flutterRootEngineMethodChannel?.invokeMethod(FMRootRouteName, arguments: nil, result: result)
        FlutterMeteor.flutterRootEngineMethodChannel?.invokeMethod(FMRootRouteName, arguments: nil) { ret in
            result(ret)
        }
    }
    
    public static func topRouteName(result: @escaping FlutterResult) {
        let channel = FlutterMeteor.channelList.allObjects.last
        channel?.invokeMethod(FMTopRouteName, arguments: nil) { ret in
            result(ret)
        }
    }
    
    public static func routeNameStack(result: @escaping FlutterResult) {
        
        let dispatchGroup = DispatchGroup()
        
        var routeStack = Array<String>()
        for channel in FlutterMeteor.channelList.allObjects {
            dispatchGroup.enter()
            channel.invokeMethod(FMRouteNameStack, arguments: nil) { ret in
                if ret is Array<String> {
                    routeStack.append(contentsOf: ret as! Array<String>)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            result(routeStack)
        }
    }
    

}
