//
//  FMFlutterNavigator.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/8/2.
//

import UIKit
import Foundation
import Flutter

//public class MeteorFlutterNavigator {
       
//
//    public static func navigatorChannel(flutterVc: FlutterViewController) -> FlutterMethodChannel? {
//        
//        let channelProvider = FlutterMeteorPlugin.channelProvider(with: flutterVc.pluginRegistry())
//        return channelProvider?.navigatorChannel
//    }
//    
//    public static func push(flutterVc:FlutterViewController,
//                            routeName: String,
//                            options: MeteorPushOptions? = nil) {
//
//        if let channel = navigatorChannel(flutterVc: flutterVc) {
//            var arguments: Dictionary<String, Any?> = [:]
//            arguments["routeName"] = routeName
//            arguments["arguments"] = options?.arguments
//            channel.save_invoke(method: FMPushNamedMethod, arguments: arguments) { ret in
//                options?.callBack?(ret)
//            }
//        } else {
//            options?.callBack?(nil)
//            print("MethodChannel 为空")
//        }
//    }
//    
//    
//    public static func pushToAndRemoveUntil(flutterVc:FlutterViewController,
//                                            routeName: String,
//                                            untilRouteName: String?,
//                                            options: MeteorPushOptions? = nil) {
//        
//        if let channel = navigatorChannel(flutterVc: flutterVc) {
//            var arguments: Dictionary<String, Any?> = [:]
//            arguments["routeName"] = routeName
//            arguments["arguments"] = options?.arguments
//            arguments["untilRouteName"] = untilRouteName
//            channel.save_invoke(method: FMPushNamedAndRemoveUntilMethod, arguments: arguments) { ret in
//                options?.callBack?(ret)
//            }
//        } else {
//            options?.callBack?(nil)
//            print("MethodChannel 为空")
//        }
//    }
//
//    
//    public static func pushNamedAndRemoveUntilRoot(flutterVc:FlutterViewController,
//                                                   routeName: String,
//                                                   options: MeteorPushOptions? = nil) {
//        
//        if let channel = navigatorChannel(flutterVc: flutterVc) {
//            var arguments: Dictionary<String, Any?> = [:]
//            arguments["routeName"] = routeName
//            arguments["arguments"] = options?.arguments
//            channel.save_invoke(method: FMPushNamedAndRemoveUntilRootMethod, arguments: arguments) { ret in
//                options?.callBack?(ret)
//            }
//        } else {
//            options?.callBack?(nil)
//            print("MethodChannel 为空")
//        }
//    }
//
//   
//    public static func pushToReplacement(flutterVc:FlutterViewController,
//                                         routeName: String,
//                                         options: MeteorPushOptions? = nil) {
//
//        if let channel = navigatorChannel(flutterVc: flutterVc) {
//            var arguments: Dictionary<String, Any?> = [:]
//            arguments["routeName"] = routeName
//            arguments["arguments"] = options?.arguments
//            channel.save_invoke(method: FMPushReplacementNamedMethod, arguments: arguments) { ret in
//                options?.callBack?(ret)
//            }
//        } else {
//            options?.callBack?(nil)
//            print("MethodChannel 为空")
//        }
//   }
//   
//    public static func pop(flutterVc:FlutterViewController,
//                           options: MeteorPopOptions? = nil) {
//        if let channel = navigatorChannel(flutterVc: flutterVc) {
//            channel.save_invoke(method: FMPopMethod, arguments: nil) { ret in
//                options?.callBack?(ret)
//            }
//        } else {
//            options?.callBack?(nil)
//            print("MethodChannel 为空")
//        }
//   }
//    
//    public static func popUntil(flutterVc:FlutterViewController,
//                                untilRouteName: String?,
//                                options: MeteorPopOptions? = nil) {
//        
//        if let channel = navigatorChannel(flutterVc: flutterVc) {
//            var arguments: Dictionary<String, Any?> = [:]
//            arguments["routeName"] = untilRouteName
//            channel.save_invoke(method: FMPopUntilMethod, arguments: arguments) { ret in
//                options?.callBack?(ret)
//            }
//        } else {
//            options?.callBack?(nil)
//            print("MethodChannel 为空")
//        }
//   
//    }
//   
//    public static func popToRoot(flutterVc: FlutterViewController,
//                                 options: MeteorPopOptions? = nil) {
//        if let channel = navigatorChannel(flutterVc: flutterVc) {
//            channel.save_invoke(method: FMPopToRootMethod, arguments: options?.result) { response in
//                options?.callBack?(response)
//            }
//        } else {
//            options?.callBack?(nil)
//            print("No valid method channel")
//        }
//    }
//    
//}
//
//
//extension MeteorFlutterNavigator {
//    
//    public static func flutterRouteNameStack(flutterVc: FlutterViewController, result: @escaping FlutterResult) {
//        if let channel = navigatorChannel(flutterVc: flutterVc) {
//            channel.save_invoke(method: FMRouteNameStack, arguments: nil, result: result)
//        } else {
//            result(nil)
//            print("No valid method channel")
//        }
//    }
//}
//
//


extension FlutterViewController {

    public func navigatorChannel() -> FlutterMethodChannel? {
        
        let channelProvider = FlutterMeteorPlugin.channelProvider(with: self.pluginRegistry())
        return channelProvider?.navigatorChannel
    }
    
    public func flutterPush(routeName: String,
                            options: MeteorPushOptions? = nil) {

        if let channel = navigatorChannel() {
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
    
    
    public func flutterPushToAndRemoveUntil(routeName: String,
                                            untilRouteName: String?,
                                            options: MeteorPushOptions? = nil) {
        
        if let channel = navigatorChannel() {
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

    
    public func flutterPushNamedAndRemoveUntilRoot(routeName: String,
                                                   options: MeteorPushOptions? = nil) {
        
        if let channel = navigatorChannel() {
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

   
    public func flutterPushToReplacement(routeName: String,
                                         options: MeteorPushOptions? = nil) {

        if let channel = navigatorChannel() {
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
   
    public func flutterPop(options: MeteorPopOptions? = nil) {
        if let channel = navigatorChannel() {
            channel.save_invoke(method: FMPopMethod, arguments: nil) { ret in
                options?.callBack?(ret)
            }
        } else {
            options?.callBack?(nil)
            print("MethodChannel 为空")
        }
   }
    
    public func flutterPopUntil(untilRouteName: String?,
                                options: MeteorPopOptions? = nil) {
        
        if let channel = navigatorChannel() {
            var arguments: Dictionary<String, Any?> = [:]
            arguments["routeName"] = untilRouteName
            channel.save_invoke(method: FMPopUntilMethod, arguments: arguments) { ret in
                options?.callBack?(ret)
            }
        } else {
            options?.callBack?(nil)
            print("MethodChannel 为空")
        }
   
    }
   
    public func flutterPopToRoot(options: MeteorPopOptions? = nil) {
        if let channel = navigatorChannel() {
            channel.save_invoke(method: FMPopToRootMethod, arguments: options?.result) { response in
                options?.callBack?(response)
            }
        } else {
            options?.callBack?(nil)
            print("No valid method channel")
        }
    }

}

extension FlutterViewController {
    public func flutterRouteExists(routeName:String, result: @escaping FlutterResult) {
        let arguments = ["routeName": routeName]
        if let channel = navigatorChannel() {
            channel.save_invoke(method: FMRouteExists, arguments: arguments, result: result)
        } else {
            result(nil)
        }
    }


    public func flutterIsRoot(routeName:String, result: @escaping FlutterResult) {
        if let channel = navigatorChannel() {
            channel.save_invoke(method:FMIsRoot, arguments: nil, result: result)
        } else {
            result(false)
        }
    }

    public func flutterRootRouteName(result: @escaping FlutterResult) {
        if let channel = navigatorChannel() {
            channel.save_invoke(method:FMRootRouteName, result: result)
        } else {
            result(routeName)
        }
    }

    public func flutterTopRouteName(result: @escaping FlutterResult) {
        
        if let channel = navigatorChannel() {
            channel.save_invoke(method: FMTopRouteName, result: result)
        } else {
            result(routeName)
        }
    }

    public func flutterRouteNameStack(result: @escaping FlutterResult) {
        if let channel = navigatorChannel() {
            channel.save_invoke(method: FMRouteNameStack) { ret in
                if let retArray = ret as? [String] {
                    result(retArray)
                } else {
                    result([self.routeName ?? "\(type(of: self))"])
                }
            }
        } else {
            result([self.routeName ?? "\(type(of: self))"])
        }
    }
}
