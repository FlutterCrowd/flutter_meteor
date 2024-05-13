//
//  FlutterMeteorMethodChannel.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/5/13.
//

import Foundation
import Flutter

struct FMMethodChannel {
    

    
    public static let FmRouterMethodChannelName = "itbox.meteor.channel"

    public static let fmPushNamedMethod: String = "pushNamed";
    public static let fmPushReplacementNamedMethod: String = "pushReplacementNamed";
    public static let fmPushNamedAndRemoveUntilMethod: String = "pushNamedAndRemoveUntil";
    public static let fmPopMethod: String = "pop";
    public static let fmPopUntilMethod: String = "popUntil";
    public static let fmPopToRootMethod: String = "popToRoot";
    public static let fmDismissMethod: String = "dismiss";
    
    /// 创建一个MethodChannel
    public static func createMehodChannel( _ binaryMessenger: any FlutterBinaryMessenger)->FlutterMethodChannel {
        return FlutterMethodChannel.init(name: FmRouterMethodChannelName, binaryMessenger: binaryMessenger)
    }
    
    private static var _flutterRootEngineMethodChannel: FlutterMethodChannel?
    // 主引擎MethodChannel
    public static var flutterRootEngineMethodChannel: FlutterMethodChannel {
        get {
            return _flutterRootEngineMethodChannel!
        }
        set {
            _flutterRootEngineMethodChannel = newValue
        }
    }
    
    public static func  handleFlutterMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        var options = FMMeteorOptions.init()
        var routeName: String = ""
        var untilRouteName: String?
        if (call.arguments is Dictionary<String, Any>) {
            let arguments: Dictionary<String, Any> = call.arguments as! Dictionary<String, Any>
            options.newEngineOpaque = (arguments["newEngineOpaque"] != nil) && arguments["newEngineOpaque"] as! Bool == true
            options.withNewEngine = arguments["withNewEngine"] as? Bool ?? false
            routeName = arguments["routeName"] as? String ?? ""
            untilRouteName = arguments["routeName"] as? String
            if (arguments ["arguments"] != nil && arguments ["arguments"] is Dictionary<String, Any>) {
                options.arguments = arguments["arguments"] as? Dictionary<String, Any>
            }
        }
        options.callBack = {response in
            result(response)
        }

        switch call.method {
        case fmPushNamedMethod:
            FMNavigator.push(routeName: routeName, options: options)
            break
        case fmPopMethod:
            FMNavigator.pop(options: options)
            break
        case fmPushReplacementNamedMethod:
            FMNavigator.pushToReplacement(routeName: routeName, options: options)
            break
        case fmPushNamedAndRemoveUntilMethod:
            FMNavigator.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
            break
        case fmPopUntilMethod:
            FMNavigator.popUntil(untilRouteName: untilRouteName ?? routeName, options: options)
            break
        case fmPopToRootMethod:
            FMNavigator.popToRoot(options: options)
            break
        case fmDismissMethod:
            FMNavigator.dismiss(options: options)
            break
        default:
          result(FlutterMethodNotImplemented)
        }
    }
}
