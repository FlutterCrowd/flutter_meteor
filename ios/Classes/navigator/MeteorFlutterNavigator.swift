//
//  MeteorFlutterNavigator.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/8/2.
//

import Flutter
import Foundation
import UIKit


public extension FlutterViewController {
    func navigatorChannel() -> FlutterMethodChannel? {
        let channelProvider = FlutterMeteorPlugin.channelProvider(with: pluginRegistry())
        return channelProvider?.navigatorChannel
    }

    func flutterPush(routeName: String,
                     options: MeteorPushOptions? = nil,
                     completion: MeteorNavigatorCallBack? = nil)
    {
        if let channel = navigatorChannel() {
            var arguments: [String: Any?] = [:]
            arguments["routeName"] = routeName
            arguments["arguments"] = options?.arguments
            channel.save_invoke(method: FMPushNamedMethod, arguments: arguments) { ret in
                completion?(ret)
            }
        } else {
            completion?(nil)
            MeteorLog.info("MethodChannel 为空")
        }
    }

    func flutterPushToAndRemoveUntil(routeName: String,
                                     untilRouteName: String?,
                                     options: MeteorPushOptions? = nil,
                                     completion: MeteorNavigatorCallBack? = nil)
    {
        if let channel = navigatorChannel() {
            var arguments: [String: Any?] = [:]
            arguments["routeName"] = routeName
            arguments["arguments"] = options?.arguments
            arguments["untilRouteName"] = untilRouteName
            channel.save_invoke(method: FMPushNamedAndRemoveUntilMethod, arguments: arguments) { ret in
                completion?(ret)
            }
        } else {
            completion?(nil)
            MeteorLog.info("MethodChannel 为空")
        }
    }

    func flutterPushNamedAndRemoveUntilRoot(routeName: String,
                                            options: MeteorPushOptions? = nil,
                                            completion: MeteorNavigatorCallBack? = nil)
    {
        if let channel = navigatorChannel() {
            var arguments: [String: Any?] = [:]
            arguments["routeName"] = routeName
            arguments["arguments"] = options?.arguments
            channel.save_invoke(method: FMPushNamedAndRemoveUntilRootMethod, arguments: arguments) { ret in
                completion?(ret)
            }
        } else {
            completion?(nil)
            MeteorLog.info("MethodChannel 为空")
        }
    }

    func flutterPushToReplacement(routeName: String,
                                  options: MeteorPushOptions? = nil,
                                  completion: MeteorNavigatorCallBack? = nil)
    {
        if let channel = navigatorChannel() {
            var arguments: [String: Any?] = [:]
            arguments["routeName"] = routeName
            arguments["arguments"] = options?.arguments
            channel.save_invoke(method: FMPushReplacementNamedMethod, arguments: arguments) { ret in
                completion?(ret)
            }
        } else {
            completion?(nil)
            MeteorLog.info("MethodChannel 为空")
        }
    }

    func flutterPop(options: MeteorPopOptions? = nil,
                 completion: MeteorNavigatorCallBack? = nil) {
        if let channel = navigatorChannel() {
            channel.save_invoke(method: FMPopMethod, arguments: options?.result) { ret in
                completion?(ret)
            }
        } else {
            completion?(nil)
            MeteorLog.info("MethodChannel 为空")
        }
    }

    func flutterPopUntil(untilRouteName: String?,
                        isFarthest: Bool = false,
                        options: MeteorPopOptions? = nil)
    {
        if let channel = navigatorChannel() {
            var arguments: [String: Any?] = [:]
            arguments["routeName"] = untilRouteName
            arguments["isFarthest"] = isFarthest
            arguments["result"] = options?.result
            channel.save_invoke(method: FMPopUntilMethod, arguments: arguments) { ret in
                options?.callBack?(ret)
            }
        } else {
            options?.callBack?(nil)
            MeteorLog.info("MethodChannel 为空")
        }
    }

    func flutterPopToRoot(options: MeteorPopOptions? = nil) {
        if let channel = navigatorChannel() {
            channel.save_invoke(method: FMPopToRootMethod, arguments: options?.result) { response in
                options?.callBack?(response)
            }
        } else {
            options?.callBack?(nil)
            MeteorLog.info("No valid method channel")
        }
    }
}

public extension FlutterViewController {
    func flutterRouteExists(routeName: String,
                            result: @escaping ((_ exists: Bool) -> Void)) {
        let arguments = ["routeName": routeName]
        if let channel = navigatorChannel() {
            channel.save_invoke(method: FMRouteExists, arguments: arguments) { ret in
                if let exists = ret as? Bool, exists {
                    result(true)
                } else {
                    result(false)
                }
            }
        } else {
            result(false)
        }
    }

    func flutterIsRoot(routeName _: String, 
                       result: @escaping ((_ isRoot: Bool) -> Void)) {
        if let channel = navigatorChannel() {
            channel.save_invoke(method: FMIsRoot, arguments: nil) { ret in
                if let isRoot = ret as? Bool {
                    result(isRoot)
                } else {
                    result(false)
                }
            }
        } else {
            result(false)
        }
    }

    func flutterRootRouteName(result: @escaping ((_ rootRouteName: String?) -> Void)) {
        if let channel = navigatorChannel() {
            channel.save_invoke(method: FMRootRouteName) { [weak self] rootRouteName in
                if let rootRouteName = rootRouteName as? String {
                    result(rootRouteName)
                } else {
                    result(self?.routeName)
                }
            }
        } else {
            result(routeName)
        }
    }

    func flutterTopRouteName(result: @escaping ((_ topRouteName: String?) -> Void)) {
        if let channel = navigatorChannel() {
            channel.save_invoke(method: FMTopRouteName) { [weak self] topRouteName in
                if let topRouteName = topRouteName as? String {
                    result(topRouteName)
                } else {
                    result(self?.routeName)
                }
            }
        } else {
            result(routeName)
        }
    }

    func flutterRouteNameStack(result: @escaping ((_ routeStack: [String]?) -> Void)) {
        if let channel = navigatorChannel() {
            channel.save_invoke(method: FMRouteNameStack) { [weak self] ret in
                if let retArray = ret as? [String] {
                    result(retArray)
                } else {
                    result([self?.routeName ?? "\(type(of: self))"])
                }
            }
        } else {
            result([routeName ?? "\(type(of: self))"])
        }
    }
}
