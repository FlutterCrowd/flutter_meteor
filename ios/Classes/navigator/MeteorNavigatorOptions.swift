//
//  MeteorNavigatorOptions.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/8/12.
//

import Foundation

public typealias MeteorNavigatorCallBack = (_ response: Any?) -> Void

public struct MeteorPushOptions {
    public var withNewEngine: Bool = false
    public var isOpaque: Bool = true
    public var present: Bool = false
    public var animated: Bool = true
    public var arguments: Dictionary<String, Any>?
    public var callBack: MeteorNavigatorCallBack?
    public init(arguments: Dictionary<String, Any>? = nil,
                callBack: MeteorNavigatorCallBack? = nil,
                isOpaque: Bool = true,
                present: Bool = false,
                animated: Bool = true,
                withNewEngine: Bool = false
    ) {
        self.arguments = arguments
        self.callBack = callBack
        self.isOpaque = isOpaque
        self.present = present
        self.withNewEngine = withNewEngine
        self.animated = animated
    }
    
    public func toJson() -> [String: Any?]{
        return [
            "withNewEngine": withNewEngine,
            "isOpaque": isOpaque,
            "present": present,
            "animated": animated,
            "arguments": arguments,
            "callBack": callBack,
        ]
    }
}

public struct MeteorPopOptions {
    // 动画
    public var animated: Bool = true
    // 在无法pop的情况下是否支持dismiss
    public var canDismiss: Bool = true
    public var result: Dictionary<String, Any>?
    public var callBack: MeteorNavigatorCallBack?

    public init(result: Dictionary<String, Any>? = nil,
                callBack: MeteorNavigatorCallBack? = nil) {
        self.result = result
        self.callBack = callBack
    }
    
    public func toJson() -> [String: Any?]{
        return [
            "canDismiss": canDismiss,
            "animated": animated,
            "result": result,
            "callBack": callBack,
        ]
    }
}
