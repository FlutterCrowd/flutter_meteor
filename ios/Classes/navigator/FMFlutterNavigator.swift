//
//  FMFlutterNavigator.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/8/2.
//

import UIKit
import Foundation
import Flutter

public class FMFlutterNavigator {
       
    

    public static func navigatorChannel(flutterVc: FlutterViewController) -> FlutterMethodChannel? {
        
        let channelProvider = FlutterMeteorPlugin.channelProvider(with: flutterVc.pluginRegistry())
        return channelProvider?.navigatorChannel
    }
    
    public static func push(flutterVc:FlutterViewController,
                            routeName: String,
                            options: FMPushOptions? = nil) {

        if let channel = navigatorChannel(flutterVc: flutterVc) {
            var arguments: Dictionary<String, Any?> = [:]
            arguments["routeName"] = routeName
            arguments["arguments"] = options?.arguments
            channel.save_invoke(method: FMPushNamedMethod, arguments: arguments) { ret in
                options?.callBack?(ret)
            }
        } else {
            options?.callBack?(nil)
            print("MethodChannel 为空")
        }
    }
    
    
    public static func pushToAndRemoveUntil(flutterVc:FlutterViewController,
                                            routeName: String,
                                            untilRouteName: String?,
                                            options: FMPushOptions? = nil) {
        
        if let channel = navigatorChannel(flutterVc: flutterVc) {
            var arguments: Dictionary<String, Any?> = [:]
            arguments["routeName"] = routeName
            arguments["arguments"] = options?.arguments
            arguments["untilRouteName"] = untilRouteName
            channel.save_invoke(method: FMPushNamedAndRemoveUntilMethod, arguments: arguments) { ret in
                options?.callBack?(ret)
            }
        } else {
            options?.callBack?(nil)
            print("MethodChannel 为空")
        }
    }

    
    public static func pushNamedAndRemoveUntilRoot(flutterVc:FlutterViewController,
                                                   routeName: String,
                                                   options: FMPushOptions? = nil) {
        
        if let channel = navigatorChannel(flutterVc: flutterVc) {
            var arguments: Dictionary<String, Any?> = [:]
            arguments["routeName"] = routeName
            arguments["arguments"] = options?.arguments
            channel.save_invoke(method: FMPushNamedAndRemoveUntilRootMethod, arguments: arguments) { ret in
                options?.callBack?(ret)
            }
        } else {
            options?.callBack?(nil)
            print("MethodChannel 为空")
        }
    }

   
    public static func pushToReplacement(flutterVc:FlutterViewController,
                                         routeName: String,
                                         options: FMPushOptions? = nil) {

        if let channel = navigatorChannel(flutterVc: flutterVc) {
            var arguments: Dictionary<String, Any?> = [:]
            arguments["routeName"] = routeName
            arguments["arguments"] = options?.arguments
            channel.save_invoke(method: FMPushReplacementNamedMethod, arguments: arguments) { ret in
                options?.callBack?(ret)
            }
        } else {
            options?.callBack?(nil)
            print("MethodChannel 为空")
        }
   }
   
    public static func pop(flutterVc:FlutterViewController,
                           options: FMPopOptions? = nil) {
        if let channel = navigatorChannel(flutterVc: flutterVc) {
            channel.save_invoke(method: FMPopMethod, arguments: nil) { ret in
                options?.callBack?(ret)
            }
        } else {
            options?.callBack?(nil)
            print("MethodChannel 为空")
        }
   }
    
    public static func popUntil(flutterVc:FlutterViewController,
                                untilRouteName: String?,
                                options: FMPopOptions? = nil) {
        
        if let channel = navigatorChannel(flutterVc: flutterVc) {
            var arguments: Dictionary<String, Any?> = [:]
            arguments["routeName"] = untilRouteName
            channel.save_invoke(method: FMPopUntilMethod, arguments: nil) { ret in
                options?.callBack?(ret)
            }
        } else {
            options?.callBack?(nil)
            print("MethodChannel 为空")
        }
   
    }
   
    public static func popToRoot(flutterVc: FlutterViewController,
                                 options: FMPopOptions? = nil) {
        if let channel = navigatorChannel(flutterVc: flutterVc) {
            channel.save_invoke(method: FMPopToRootMethod, arguments: options?.result) { response in
                options?.callBack?(response)
            }
        } else {
            options?.callBack?(nil)
            print("No valid method channel")
        }
    }
}


