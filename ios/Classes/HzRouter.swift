//
//  HzRouter.swift
//  multi_engin
//
//  Created by itbox_djx on 2024/5/7.
//

import Foundation
import Flutter

public class HzRouter: NSObject {
  
   public static var plugin: HzRouterPlugin?
    
   public static func present(viewController: UIViewController) {
       plugin?.present(viewController: viewController)
   }
   
    public static func push(viewController: UIViewController) {
       plugin?.push(viewController: viewController)
   }
    
    public static func pop() {
        plugin?.pop()
    }
    
    public static func pop(viewController: UIViewController) {
        plugin?.pop(toPage: viewController)
    }
    
    public static func popToRoot() {
        plugin?.popToRoot()
    }
    
    public static func dismiss() {
        plugin?.dismiss()
    }

    public static func flutterPop() {
        plugin?.pop()
     }
    
    public static func flutterPopUntilName(routerName: String) {
        plugin?.pop(toPage: routerName)
     }
    
    public static func flutterPopToRoot() {
        plugin?.flutterPopToRoot()
    }
    
}
