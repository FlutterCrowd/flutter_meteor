//
//  MeteorEngineManager.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/8/6.
//

import Flutter
import Foundation

let FMNavigatorMethodChannelName: String = "itbox.meteor.navigatorChannel"
let FMObserverMethodChannelName: String = "itbox.meteor.observerChannel"
let FMEventBusMessageChannelName: String = "itbox.meteor.multiEnginEventChannel"

public class FlutterMeteorChannelProvider: NSObject {
    private var _navigatorChannel: FlutterMethodChannel?
    public var navigatorChannel: FlutterMethodChannel {
        return _navigatorChannel!
    }

    private var _eventBusChannel: FlutterBasicMessageChannel?
    public var eventBusChannel: FlutterBasicMessageChannel {
        return _eventBusChannel!
    }
    
    private var _observerChannel: FlutterBasicMessageChannel?
    public var observerChannel: FlutterBasicMessageChannel {
        return _observerChannel!
    }

    init(registrar: FlutterPluginRegistrar!) {
        super.init()
        _navigatorChannel = FlutterMethodChannel(name: FMNavigatorMethodChannelName, binaryMessenger: registrar.messenger())
  
        _observerChannel = FlutterBasicMessageChannel(name: FMObserverMethodChannelName, binaryMessenger: registrar.messenger(), codec: FlutterStandardMessageCodec.sharedInstance())
        _eventBusChannel = FlutterBasicMessageChannel(name: FMEventBusMessageChannelName, binaryMessenger: registrar.messenger(), codec: FlutterStandardMessageCodec.sharedInstance())
    }
}

public class MeteorEngineGroupOptions {
    let entrypoint: String?

    let initialRoute: String?

    let entrypointArgs: [String: Any]?

    let libraryURI: String?

    public init(entrypoint: String? = "main",
                initialRoute: String? = nil,
                entrypointArgs: [String: Any]? = nil,
                libraryURI: String? = nil)
    {
        self.entrypoint = entrypoint
        self.initialRoute = initialRoute
        self.entrypointArgs = entrypointArgs
        self.libraryURI = libraryURI
    }
}

class MeteorEngineManager {
    
    public static let shared = MeteorEngineManager()
    private init() {}
    
    
    private static let channelProviderList = MeteorWeakArray<FlutterMeteorChannelProvider>()

    // FlutterEngineGroup 用于管理所有引擎
    private static let flutterEngineGroup = FlutterEngineGroup(name: "itbox.meteor.flutterEnginGroup", project: nil)
    var engineWeakCache = MeteorWeakDictionary<FlutterBinaryMessenger, FlutterEngine>()
    var engineCache = MeteorWeakDictionary<FlutterBinaryMessenger, FlutterEngine>()

    public static func createFlutterEngine(options: MeteorEngineGroupOptions? = nil) -> FlutterEngine {
        var arguments = [String: Any]()
        
        let initialRoute = options?.initialRoute
        let entrypointArgs = options?.entrypointArgs
        if initialRoute != nil {
            arguments["initialRoute"] = initialRoute
        }
        if initialRoute != nil {
            arguments["routeArguments"] = entrypointArgs
        }

        var entrypointArgList = [String]()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arguments, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                entrypointArgList.append(jsonString)
            }
        } catch {
            MeteorLog.error("Error converting dictionary to JSON")
        }

        // 创建新引擎
        let engineGroupOptions = FlutterEngineGroupOptions()
        engineGroupOptions.entrypoint = options?.entrypoint
        engineGroupOptions.initialRoute = initialRoute
        engineGroupOptions.entrypointArgs = entrypointArgList
        engineGroupOptions.libraryURI = options?.libraryURI
        let flutterEngine: FlutterEngine = flutterEngineGroup.makeEngine(with: engineGroupOptions)
        flutterEngine.run()
        shared.engineCache[flutterEngine.binaryMessenger] = flutterEngine
        return flutterEngine
    }

    /// 第一个引擎的Channel
    public static func firstEngineChannelProvider() -> FlutterMeteorChannelProvider? {
        return channelProviderList.allObjects.first
    }

    /// 最后一个引擎的Channel
    public static func lastEngineChannelProvider() -> FlutterMeteorChannelProvider? {
        return channelProviderList.allObjects.last
    }

    /// 所有引擎的Channel
    public static func allEngineChannelProvider() -> [FlutterMeteorChannelProvider] {
        return channelProviderList.allObjects
    }

    /// 保存Channel
    public static func saveEngineChannelProvider(provider: FlutterMeteorChannelProvider) {
        if !channelProviderList.contains(provider) {
            channelProviderList.add(provider)
        }
    }
}
