//
//  MeteorRouterManager.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/12.
//

import UIKit
import Flutter

/// UIViewController构造器
public typealias MeteorViewControllerBuilder = (_ arguments: Dictionary<String, Any>?) -> UIViewController

/// UIViewController构造器
public class MeteorRouterManager: NSObject {
    
    public static let shared = MeteorRouterManager()
    private override init() {}
    
    private let queue = DispatchQueue(label: "com.example.MemoryCacheQueue", attributes: .concurrent)

    private var routes = Dictionary<String, MeteorViewControllerBuilder>()
    
    
    public static func insertRouter(routeName:String,
                                    routerBuilder: @escaping MeteorViewControllerBuilder) {
        shared.routes[routeName] = routerBuilder
    }
    
    public static func routerBuilder(routeName:String) -> MeteorViewControllerBuilder? {
        return shared.routes[routeName]
    }
    
    public static func getViewController(routeName: String?,
                                         arguments: Dictionary<String, Any>?) -> UIViewController? {
        if(routeName == nil) {
            return nil
        }
        let vcBuilder: MeteorViewControllerBuilder? = shared.routes[routeName!]
        let vc: UIViewController? = vcBuilder?(arguments)
        if let naviVC = vc as? UINavigationController,
           let visibleVc = naviVC.visibleViewController {
            if visibleVc.fmRouteName == nil {
                visibleVc.fmRouteName = routeName
            }
        }
        vc?.fmRouteName = routeName
        return vc
    }
    
    public static func getViewController(routeName: String?,
                                         options: MeteorPushOptions?) -> UIViewController? {
        if(routeName == nil) {
            return nil
        }
        let vcBuilder: MeteorViewControllerBuilder? = shared.routes[routeName!]
        let vc: UIViewController? = vcBuilder?(options?.arguments)
        
        if options?.isOpaque == false {
            vc?.view.backgroundColor = UIColor.clear
            vc?.view.isOpaque = false
        }
        if let naviVC = vc as? UINavigationController,
           let visibleVc = naviVC.visibleViewController {
            if options?.isOpaque == false {
                visibleVc.view.backgroundColor = UIColor.clear
                visibleVc.view.isOpaque = false
            }
            if visibleVc.fmRouteName == nil {
                visibleVc.fmRouteName = routeName
            }
        }
        vc?.fmRouteName = routeName
        return vc
    }
    
    
    public static func getDefaultFlutterViewController(routeName: String,
                                                       entrypoint: String? = "main",
                                                       options: MeteorPushOptions?) -> MeteorFlutterViewController {
        let isOpaque: Bool = options?.isOpaque ?? true
        
        let engineGroupOptions = MeteorEngineGroupOptions(
            entrypoint: entrypoint,
            initialRoute: routeName,
            entrypointArgs: options?.arguments)
        
        let flutterVc = MeteorFlutterViewController.init(options: engineGroupOptions) { response in
            options?.callBack?(nil)
        }
        flutterVc.fmRouteName = routeName
        flutterVc.isViewOpaque = isOpaque
        flutterVc.modalPresentationStyle = .overFullScreen
        if(!isOpaque) {
            flutterVc.view.backgroundColor = UIColor.clear
        }
        return flutterVc
    }
}
