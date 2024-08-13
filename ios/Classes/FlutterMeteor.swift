//
//  HzRouter.swift
//  multi_engin
//
//  Created by itbox_djx on 2024/5/7.
//

import Foundation
import Flutter


public protocol MeteorPluginRegistryDelegate {
    // GeneratedPluginRegistrant.register(with: self) 方法需要在这里调用
    func register(pluginRegistry: any FlutterPluginRegistry)
    // 对应的引擎销毁的时候会调用此方法
    func unRegister(pluginRegistry: any FlutterPluginRegistry)
}

public protocol FlutterMeteorCustomDelegate {
        
    func push(routeName: String, options: MeteorPushOptions?)
}


public class FlutterMeteor  {
 
    // 多引擎插件初始化
    //
    // @param pluginRegistryDelegate FMNewEnginePluginRegistryDelegate
    public static func setUp(pluginRegistryDelegate: MeteorPluginRegistryDelegate) {
        // method switch
        FlutterMeteor.pluginRegistryDelegate = pluginRegistryDelegate
    }
    
    // 自定义路由代理
    public static var customRouterDelegate: (any FlutterMeteorCustomDelegate)?
    
    // 注册插件代理
    public static var  pluginRegistryDelegate: MeteorPluginRegistryDelegate!
    
}
