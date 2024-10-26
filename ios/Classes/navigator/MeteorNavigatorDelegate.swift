//
//  MeteorNavigatorDelegate.swift
//  hz_router
//
//  Created by itbox_djx on 2024/5/8.
//

import Flutter
import Foundation

public let FMPushNamedMethod: String = "pushNamed"
public let FMPushReplacementNamedMethod: String = "pushReplacementNamed"
public let FMPushNamedAndRemoveUntilMethod: String = "pushNamedAndRemoveUntil"
public let FMPushNamedAndRemoveUntilRootMethod: String = "pushNamedAndRemoveUntilRoot"
public let FMPopMethod: String = "pop"
public let FMPopUntilMethod: String = "popUntil"
public let FMPopToRootMethod: String = "popToRoot"
// public let FMDismissMethod: String = "dismiss"

public let FMRouteExists: String = "routeExists"
public let FMIsRoot: String = "isRoot"
public let FMRootRouteName: String = "rootRouteName"
public let FMTopRouteName: String = "topRouteName"
public let FMRouteNameStack: String = "routeNameStack"
public let FMTopRouteIsNative: String = "topRouteIsNative"

private struct MeteorPushParams {
    public var routeName: String
    public var untilRouteName: String?
    public var options: MeteorPushOptions?
    public init(routeName: String, untilRouteName: String? = nil, options: MeteorPushOptions? = nil) {
        self.routeName = routeName
        self.untilRouteName = untilRouteName
        self.options = options
    }
}

private struct MeteorPopParams {
    public var untilRouteName: String?
    public var isFarthest: Bool = false
    public var options: MeteorPopOptions?
    public init(untilRouteName: String? = nil, isFarthest: Bool = false, options: MeteorPopOptions? = nil) {
        self.isFarthest = isFarthest
        self.untilRouteName = untilRouteName
        self.options = options
    }
}

protocol MeteorNavigatorDelegate {
    // push
    func present(routeName: String, options: MeteorPushOptions?)

    func push(routeName: String, options: MeteorPushOptions?)

    /// push 到指定页面并替换当前页面
    ///
    /// @parma toPage 要跳转的页面，
    func pushToReplacement(routeName: String, options: MeteorPushOptions?)

    /// push 到指定页面，同时会清除从页面untilRouteName页面到指定routeName链路上的所有页面
    ///
    /// @parma routeName 要跳转的页面，
    /// @parma untilRouteName 移除截止页面，默认根页面，
    func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: MeteorPushOptions?)

    func pushNamedAndRemoveUntilRoot(routeName: String, options: MeteorPushOptions?)

    // pop
    func pop(options: MeteorPopOptions?)

    func popUntil(untilRouteName: String?, isFarthest: Bool, options: MeteorPopOptions?)

    func popToRoot(options: MeteorPopOptions?)
}

extension MeteorNavigatorDelegate {
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
        case FMPushReplacementNamedMethod:
            if let params = getPushParams(call, result: result) {
                pushToReplacement(routeName: params.routeName, options: params.options)
            } else {
                print("Invalid pushToReplacement params")
                result(nil)
            }
        case FMPushNamedAndRemoveUntilMethod:
            if let params = getPushParams(call, result: result) {
                pushToAndRemoveUntil(routeName: params.routeName, untilRouteName: params.untilRouteName, options: params.options)
            } else {
                print("Invalid pushToAndRemoveUntil params")
                result(nil)
            }
        case FMPushNamedAndRemoveUntilRootMethod:
            if let params = getPushParams(call, result: result) {
                pushNamedAndRemoveUntilRoot(routeName: params.routeName, options: params.options)
            } else {
                print("Invalid pushNamedAndRemoveUntilRoot params")
                result(nil)
            }
        case FMPopMethod:
            let params = getPopParams(call, result: result)
            pop(options: params.options)
        case FMPopUntilMethod:
            let params = getPopParams(call, result: result)
            popUntil(untilRouteName: params.untilRouteName, isFarthest: params.isFarthest, options: params.options)
        case FMPopToRootMethod:
            let params = getPopParams(call, result: result)
            popToRoot(options: params.options)
        case FMRouteExists:
            if let methodArguments = call.arguments as? [String: Any] {
                if let routeName = methodArguments["routeName"] as? String {
                    MeteorNavigator.routeExists(routeName: routeName, result: result)
                } else {
                    print("Invalid routeName")
                    result(false)
                }
            } else {
                print("Invalid methodArguments")
                result(false)
            }
        case FMIsRoot:
            if let methodArguments = call.arguments as? [String: Any] {
                if let routeName = methodArguments["routeName"] as? String {
                    MeteorNavigator.isRoot(routeName: routeName, result: result)
                } else {
                    print("Invalid routeName")
                    result(false)
                }
            } else {
                print("Invalid methodArguments")
                result(false)
            }
        case FMRootRouteName:
            MeteorNavigator.rootRouteName(result: result)
        case FMTopRouteName:
            MeteorNavigator.topRouteName(result: result)
        case FMRouteNameStack:
            MeteorNavigator.routeNameStack(result: result)
        case FMTopRouteIsNative:
            MeteorNavigator.topRouteIsNative(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func getPopParams(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> MeteorPopParams {
        var params = MeteorPopParams()
        var options = MeteorPopOptions()
        if let methodArguments = call.arguments as? [String: Any] {
            options.result = methodArguments["result"]
            params.untilRouteName = methodArguments["routeName"] as? String
            params.isFarthest = methodArguments["isFarthest"] as? Bool ?? false
            options.animated = methodArguments["animated"] as? Bool ?? true
            options.canDismiss = methodArguments["canDismiss"] as? Bool ?? true
        }
        options.callBack = { response in
            result(response)
        }
        params.options = options
        return params
    }

    private func getPushParams(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> MeteorPushParams? {
        var params: MeteorPushParams?
        var options = MeteorPushOptions()
        if let methodArguments = call.arguments as? [String: Any] {
            if let routeName = methodArguments["routeName"] as? String {
                let untilRouteName = methodArguments["untilRouteName"] as? String
                params = MeteorPushParams(routeName: routeName, untilRouteName: untilRouteName)
    
                options.isOpaque = (methodArguments["isOpaque"] != nil) && methodArguments["isOpaque"] as! Bool == true
                options.animated = methodArguments["animated"] as? Bool ?? true
                let pageType: Int = methodArguments["pageType"] as? Int ?? 1
                options.pageType = MeteorPageType(fromType: pageType)
                options.present = methodArguments["present"] as? Bool ?? false
                options.arguments = methodArguments["arguments"] as? [String: Any]
            } else {
                print("No valid routeName to push")
            }
        } else {
            print("Invalid push params")
        }
        options.callBack = { response in
            result(response)
        }
        params?.options = options
        return params
    }
}

/// 默认实现

extension MeteorNavigatorDelegate {
    
    func present(routeName: String, options: MeteorPushOptions?) {

        if let delegate = FlutterMeteor.customRouterDelegate {
            if let pageType = options?.pageType, pageType == .flutter {
                delegate.openFlutterPage(routeName: routeName, options: options)
            } else {
                delegate.openNativePage(routeName: routeName, options: options)
            }
        } else {
            MeteorNavigator.present(routeName: routeName, options: options)
        }
    }

    func push(routeName: String, options: MeteorPushOptions?) {
        
        if let delegate = FlutterMeteor.customRouterDelegate {
            if let pageType = options?.pageType, pageType == .flutter {
                delegate.openFlutterPage(routeName: routeName, options: options)
            } else {
                delegate.openNativePage(routeName: routeName, options: options)
            }
        } else {
            MeteorNavigator.push(routeName: routeName, options: options)
        }
    }

    func pushToReplacement(routeName: String, options: MeteorPushOptions?) {

//        MeteorNavigator.pushToReplacement(routeName: routeName, options: options)
        MeteorNavigator.pop(options: MeteorPopOptions(animated: false, callBack: { response in
            push(routeName: routeName, options: options)
        }))
    
    }

    func pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: MeteorPushOptions?) {
        MeteorNavigator.popUntil(untilRouteName: untilRouteName, options: MeteorPopOptions(animated: false, callBack: { response in
            push(routeName: routeName, options: options)
        }))
//        MeteorNavigator.pushToAndRemoveUntil(routeName: routeName, untilRouteName: untilRouteName, options: options)
    }

    func pushNamedAndRemoveUntilRoot(routeName: String, options: MeteorPushOptions?) {
        MeteorNavigator.popToRoot(options: MeteorPopOptions(animated: false, callBack: { response in
            push(routeName: routeName, options: options)
        }))
//        MeteorNavigator.pushNamedAndRemoveUntilRoot(routeName: routeName, options: options)
    }

    // pop
    func pop(options: MeteorPopOptions?) {
        MeteorNativeNavigator.pop(animated: options?.animated ?? true) {
            options?.callBack?(nil)
        }
    }

    func popUntil(untilRouteName: String?, isFarthest: Bool = false, options: MeteorPopOptions?) {
        MeteorNavigator.popUntil(untilRouteName: untilRouteName, isFarthest: isFarthest, options: options)
    }

    func popToRoot(options: MeteorPopOptions?) {
        MeteorNavigator.popToRoot(options: options)
    }
}
