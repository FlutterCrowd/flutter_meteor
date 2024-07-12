//
//  FlutterMeteorRouterManager.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/12.
//

import UIKit

public typealias FMRouterBuilder = (_ arguments: Dictionary<String, Any>?) -> UIViewController


public class FlutterMeteorRouter: NSObject {
    
    public static var routerDict = Dictionary<String, FMRouterBuilder>()
    
    public static func insertRouter(routeName:String, routerBuilder: @escaping FMRouterBuilder) {
        routerDict[routeName] = routerBuilder
    }
    
    public static func routeExists(routeName:String) -> Bool {
        
    }
    
    public static func isCurrentRoot() -> Bool {
    }
    
    public static func isRoot(routeName:String) -> Bool {
    }
    
    public static func rootRouteName() -> String {
    }
    
    public static func topRouteName() -> String {
    }
    
    public static func routeNameStack() -> Array<String> {
    }

}
