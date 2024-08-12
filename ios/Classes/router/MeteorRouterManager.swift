//
//  FlutterMeteorRouterManager.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/12.
//

import UIKit
import Flutter


public typealias FMRouterBuilder = (_ arguments: Dictionary<String, Any>?) -> UIViewController


public class MeteorRouterManager: NSObject {
    
    private static var routes = Dictionary<String, FMRouterBuilder>()
    
    public static func insertRouter(routeName:String, routerBuilder: @escaping FMRouterBuilder) {
        routes[routeName] = routerBuilder
    }
    
    public static func routerBuilder(routeName:String) -> FMRouterBuilder? {
        return routes[routeName]
    }
    
    public static func viewController(routeName: String?, arguments: Dictionary<String, Any>?) -> UIViewController? {
        if(routeName == nil) {
            return nil
        }
        let vcBuilder: FMRouterBuilder? = MeteorRouterManager.routes[routeName!]
        let vc: UIViewController? = vcBuilder?(arguments)
        vc?.routeName = routeName
        return vc
    }
}
