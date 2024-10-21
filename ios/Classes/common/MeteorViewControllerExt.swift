//
//  MeteorViewControllerExt.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/29.
//

import Foundation

private var FMAssociatedRouteNameHandle: UInt8 = 0

private var FMAssociatedPopCallBackHandle: UInt8 = 0

public typealias FlutterMeteorPopCallBack = (_ response: Any?) -> Void

public extension UIViewController {
    // 页面路由名称
    @objc var routeName: String? {
        get {
            return objc_getAssociatedObject(self, &FMAssociatedRouteNameHandle) as? String
                        ?? String(describing: type(of: self))
        }
        set {
            objc_setAssociatedObject(self, &FMAssociatedRouteNameHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    // 当页面pop或者dismiss时会调用这个回调
    @objc var popCallBack: FlutterMeteorPopCallBack? {
        get {
            return objc_getAssociatedObject(self, &FMAssociatedPopCallBackHandle) as? FlutterMeteorPopCallBack
        }
        set {
            objc_setAssociatedObject(self, &FMAssociatedPopCallBackHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
