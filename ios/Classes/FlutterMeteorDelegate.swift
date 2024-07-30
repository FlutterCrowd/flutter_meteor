//
//  HzRouterDelegate.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/8.
//

import Foundation
import Flutter


public let FMPushNamedMethod: String = "pushNamed"
public let FMPushReplacementNamedMethod: String = "pushReplacementNamed"
public let FMPushNamedAndRemoveUntilMethod: String = "pushNamedAndRemoveUntil"
public let FMPushNamedAndRemoveUntilRootMethod: String = "pushNamedAndRemoveUntilRoot"
public let FMPopMethod: String = "pop"
public let FMPopUntilMethod: String = "popUntil"
public let FMPopToRootMethod: String = "popToRoot"
public let FMDismissMethod: String = "dismiss"

public let FMMultiEngineEventCallMethod: String = "cn.itbox.multiEnginEvent"


public typealias FlutterMeteorRouterCallBack = (_ response: Any?) -> Void

public struct FMPushOptions {
    public var withNewEngine: Bool = false
    public var newEngineOpaque: Bool = false
    public var present: Bool = false
    public var animated: Bool = true
    public var arguments: Dictionary<String, Any>?
    public var callBack: FlutterMeteorRouterCallBack?
    public init(arguments: Dictionary<String, Any>? = nil, callBack: FlutterMeteorRouterCallBack? = nil) {
        self.arguments = arguments
        self.callBack = callBack
    }
}

public struct FMPopOptions {
    // 动画
    public var animated: Bool = true
    // 在无法pop的情况下是否支持dismiss
    public var canDismiss: Bool = true
    public var result: Dictionary<String, Any>?
    public var callBack: FlutterMeteorRouterCallBack?

    public init(result: Dictionary<String, Any>? = nil,
                callBack: FlutterMeteorRouterCallBack? = nil) {
        self.result = result
        self.callBack = callBack
    }
}

private struct FMPushParams {
    public var routeName: String
    public var untilRouteName: String?
    public var options: FMPushOptions?
    public init(routeName: String, untilRouteName: String? = nil, options: FMPushOptions? = nil) {
        self.routeName = routeName
        self.untilRouteName = untilRouteName
        self.options = options
    }
}

private struct FMPopParams {
    
    public var untilRouteName: String?
    public var options: FMPopOptions?
    public init(untilRouteName: String? = nil, options: FMPopOptions? = nil) {
        self.untilRouteName = untilRouteName
        self.options = options
    }
}



public protocol FlutterMeteorCustomDelegate {
        
    func push(routeName: String, options: FMPushOptions?)
}


protocol FlutterMeteorDelegate {
        
    // push
    func present(routeName: String, options: FMPushOptions?)
    
    func push(routeName: String, options: FMPushOptions?)
         
    /// push 到指定页面并替换当前页面
    ///
    /// @parma toPage 要跳转的页面，
    func pushToReplacement(routeName: String, options: FMPushOptions?)

    /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
    ///
    /// @parma routeName 要跳转的页面，
    /// @parma untilRouteName 移除截止页面，默认根页面，
    func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: FMPushOptions?)
    
    func pushNamedAndRemoveUntilRoot(routeName: String, options: FMPushOptions?)
    
    // pop
    func pop(options: FMPopOptions?)
    
    func popUntil(untilRouteName: String?, options: FMPopOptions?)
     
    func popToRoot(options: FMPopOptions?)
     
    func dismiss(options: FMPopOptions?)
    
}


extension FlutterMeteorDelegate {
    
    func handleFlutterMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case FMPushNamedMethod:
            if let params = getPushParams(call, result: result) {
                if params.options?.present == true {
                    present(routeName: params.routeName, options: params.options)
                } else {
                    push(routeName: params.routeName, options: params.options)
                }
            } else {
                print("Invalid push params")
                result(nil)
            }
            break
        case FMPushReplacementNamedMethod:
            if let params = getPushParams(call, result: result) {
                pushToReplacement(routeName: params.routeName, options: params.options)
            } else {
                print("Invalid push params")
                result(nil)
            }
            break
        case FMPushNamedAndRemoveUntilMethod:
            if let params = getPushParams(call, result: result) {
                pushToAndRemoveUntil(routeName: params.routeName, untilRouteName: params.untilRouteName, options: params.options)
            } else {
                print("Invalid push params")
                result(nil)
            }
            break
        case FMPushNamedAndRemoveUntilRootMethod:
            if let params = getPushParams(call, result: result) {
                pushNamedAndRemoveUntilRoot(routeName: params.routeName, options: params.options)
            } else {
                print("Invalid push params")
                result(nil)
            }
            break
        case FMPopMethod:
            let params = getPopParams(call, result: result)
            pop(options: params.options)
            break
        case FMPopUntilMethod:
            let params = getPopParams(call, result: result)
            popUntil(untilRouteName: params.untilRouteName, options: params.options)
            break
        case FMPopToRootMethod:
            let params = getPopParams(call, result: result)
            popToRoot(options: params.options)
            break
        case FMDismissMethod:
            let params = getPopParams(call, result: result)
            dismiss(options: params.options)
            break
            
            
        case FMMultiEngineEventCallMethod:
            if (call.arguments is Dictionary<String, Any>) {
                let methodArguments: Dictionary<String, Any> = call.arguments as! Dictionary<String, Any>
                let eventName = methodArguments["eventName"] as? String ?? ""
                let arguments = methodArguments["arguments"]
                FlutterMeteor.sendEvent(eventName: eventName, arguments: arguments)
                
            } else {
                print("Invalid call.arguments")
            }
            break
            
        case FMRouteExists:
            if let methodArguments = call.arguments as? Dictionary<String, Any> {
                if let routeName = methodArguments["routeName"] as? String {
                    FlutterMeteorRouter.routeExists(routeName: routeName, result: result)
                } else {
                    print("Invalid routeName")
                    result(false)
                }
            } else {
                print("Invalid methodArguments")
                result(false)
            }
            break
        case FMIsRoot:
            if let methodArguments = call.arguments as? Dictionary<String, Any> {
                if let routeName = methodArguments["routeName"] as? String {
                    FlutterMeteorRouter.isRoot(routeName: routeName, result: result)
                } else {
                    print("Invalid routeName")
                    result(false)
                }
            } else {
                print("Invalid methodArguments")
                result(false)
            }
            break
        case FMRootRouteName:
            FlutterMeteorRouter.rootRouteName(result: result)
            break
        case FMTopRouteName:
            FlutterMeteorRouter.topRouteName(result: result)
            break
        case FMRouteNameStack:
            FlutterMeteorRouter.routeNameStack(result: result)
            break
        case FMTopRouteIsNative:
            FlutterMeteorRouter.topRouteIsNative(result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func  getPopParams(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> FMPopParams {
        var params = FMPopParams.init()
        if let methodArguments = call.arguments as? Dictionary<String, Any> {
            params.untilRouteName = methodArguments["routeName"] as? String
            var options = FMPopOptions()
            options.animated = methodArguments["animated"] as? Bool ?? true
            options.canDismiss = methodArguments["canDismiss"] as? Bool ?? true
            options.result = methodArguments["result"] as? Dictionary<String, Any>
            options.callBack = {response in
                result(response)
            params.options = options
            }
        }
        return params
    }
    
    private func  getPushParams(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> FMPushParams? {
        var params: FMPushParams?
        if let methodArguments = call.arguments as? Dictionary<String, Any> {
            if let routeName = methodArguments["routeName"] as? String   {
                let untilRouteName = methodArguments["untilRouteName"] as? String
                params = FMPushParams(routeName: routeName, untilRouteName: untilRouteName)
                var options = FMPushOptions()
                options.newEngineOpaque = (methodArguments["newEngineOpaque"] != nil) && methodArguments["newEngineOpaque"] as! Bool == true
                options.animated = methodArguments["animated"] as? Bool ?? true
                options.withNewEngine = methodArguments["withNewEngine"] as? Bool ?? false
                options.present = methodArguments["present"] as? Bool ?? false
                options.callBack = {response in
                    result(response)
                }
                options.arguments = methodArguments["arguments"] as? Dictionary<String, Any>
                params?.options = options
            } else {
                print("No valid routeName to push")
            }
        } else {
            print("Invalid push params")
        }
        return params
    }

}


/// 默认实现

extension FlutterMeteorDelegate {
    
    func present(routeName: String, options: FMPushOptions?) {
        FMNavigator.present(routeName: routeName, options: options)
    }
    
    func push(routeName: String, options: FMPushOptions?) {
        FMNavigator.push(routeName: routeName, options: options)
    }
         
    /// push 到指定页面并替换当前页面
    ///
    /// @parma toPage 要跳转的页面，
    func pushToReplacement(routeName: String, options: FMPushOptions?) {
        FMNavigator.pushToReplacement(routeName: routeName, options: options)
    }

    /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
    ///
    /// @parma routeName 要跳转的页面，
    /// @parma untilRouteName 移除截止页面，默认根页面，
    func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: FMPushOptions?) {
        FMNavigator.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
    }
    
    func pushNamedAndRemoveUntilRoot(routeName: String, options: FMPushOptions?) {
        FMNavigator.pushNamedAndRemoveUntilRoot(routeName: routeName, options: options)
    }
    
    // pop
    func pop(options: FMPopOptions?) {
        FMNavigator.pop(options: options)
    }
    
    func popUntil(untilRouteName: String?, options: FMPopOptions?) {
        FMNavigator.popUntil(untilRouteName: untilRouteName, options: options)
    }
     
    func popToRoot(options: FMPopOptions?) {
        FMNavigator.popToRoot(options: options)
    }
     
    func dismiss(options: FMPopOptions?) {
        FMNavigator.dismiss(options: options)
    }
    
}
