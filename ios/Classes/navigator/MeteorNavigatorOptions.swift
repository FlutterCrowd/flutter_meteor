//
//  MeteorNavigatorOptions.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/8/12.
//

import Foundation

public typealias MeteorNavigatorCallBack = (_ response: Any?) -> Void

public enum MeteorPageType: Int {
    case flutter = 0
    case native = 1
    case newEngine = 2

    // 初始化方法，根据类型值返回对应的枚举实例
    init(fromType type: Int) {
        self = MeteorPageType(rawValue: type) ?? .flutter
    }
}

// 使用示例
let pageType = MeteorPageType(fromType: 1) // 返回 .native


public struct MeteorPushOptions {
    public var pageType: MeteorPageType = .native
    public var isOpaque: Bool = true
    public var animated: Bool = true
    
    public var present: Bool = false
    public var arguments: Dictionary<String, Any>?
    public var callBack: MeteorNavigatorCallBack?
    public init(arguments: Dictionary<String, Any>? = nil,
                callBack: MeteorNavigatorCallBack? = nil,
                isOpaque: Bool = true,
                present: Bool = false,
                animated: Bool = true,
                pageType: MeteorPageType = .native
    ) {
        self.arguments = arguments
        self.callBack = callBack
        self.isOpaque = isOpaque
        self.present = present
        self.pageType = pageType
        self.animated = animated
    }
    
    public func toJson() -> [String: Any?]{
        return [
            "pageType": pageType,
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
