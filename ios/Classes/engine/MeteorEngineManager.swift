//
//  FMEngineManager.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/8/6.
//

import Foundation
import Flutter

public class MeteorEngineGroupOptions {
    
    let entrypoint: String?
    
    let initialRoute: String?
    
    let entrypointArgs: Dictionary<String, Any>?
    
    let libraryURI: String?
    
    public init(entrypoint: String? = "main",
         initialRoute: String? = nil,
         entrypointArgs: Dictionary<String, Any>? = nil,
         libraryURI: String? = nil) {
        self.entrypoint = entrypoint
        self.initialRoute = initialRoute
        self.entrypointArgs = entrypointArgs
        self.libraryURI = libraryURI
    }
}


class MeteorEngineManager: NSObject {
    
    // FlutterEngineGroup 用于管理所有引擎
    private static let flutterEngineGroup = FlutterEngineGroup(name: "itbox.meteor.flutterEnginGroup", project: nil)
    
//    public static  var engineCache:MeteorWeakDictionary = MeteorWeakDictionary<FlutterBinaryMessenger, FlutterEngine>()

    public static func createFlutterEngine(options: MeteorEngineGroupOptions? = nil) -> FlutterEngine  {
      
        var arguments: Dictionary<String, Any> = Dictionary<String, Any>.init()

        let initialRoute = options?.initialRoute
        let entrypointArgs = options?.entrypointArgs
        if(initialRoute != nil) {
            arguments["initialRoute"] = initialRoute
        }
        if(initialRoute != nil) {
            arguments["routeArguments"] = entrypointArgs
        }
        
        var entrypointArgList:Array<String> = Array<String>.init()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arguments, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                entrypointArgList.append(jsonString)
            }
        } catch {
            print("Error converting dictionary to JSON")
        }
        
        // 创建新引擎
        let engineGroupOptions = FlutterEngineGroupOptions.init()
        engineGroupOptions.entrypoint = options?.entrypoint
        engineGroupOptions.initialRoute = initialRoute
        engineGroupOptions.entrypointArgs = entrypointArgList
        engineGroupOptions.libraryURI = options?.libraryURI
        let flutterEngine: FlutterEngine = flutterEngineGroup.makeEngine(with: engineGroupOptions)
//        engineCache[flutterEngine.binaryMessenger] = flutterEngine
        return flutterEngine
    }
}
