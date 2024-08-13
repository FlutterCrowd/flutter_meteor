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
    public var isOpaque: Bool = false
    public var present: Bool = false
    public var animated: Bool = true
    public var arguments: Dictionary<String, Any>?
    public var callBack: MeteorNavigatorCallBack?
    public init(arguments: Dictionary<String, Any>? = nil, callBack: MeteorNavigatorCallBack? = nil) {
        self.arguments = arguments
        self.callBack = callBack
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
}
