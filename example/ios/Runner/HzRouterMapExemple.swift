//
//  HzRouterMapExemple.swift
//  Runner
//
//  Created by itbox_djx on 2024/5/12.
//

import UIKit
import hz_router

class HzRouterMapExemple  {
    
    static func setUp() -> Void {
        HzRouter.insertRouter(routeName: "test") { arguments in
            let testVc = TestViewController.init()
            return testVc
        }
        
        HzRouter.insertRouter(routeName: "test1") { arguments in
            let testVc = TestViewController.init()
            return testVc
        }
        
        HzRouter.insertRouter(routeName: "routeName") { arguments in
            let testVc = TestViewController.init()
            return testVc
        }
        
        HzRouter.insertRouter(routeName: "test2") { arguments in
            var arg = Dictionary<String, Any>.init()
            arg["1"] = 1
            arg["2"] = "2"
            let testVc = HzFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: arg, initialRoute: "multi_engin2")
            return testVc
        }
        
        HzRouter.insertRouter(routeName: "multi_engin2") { arguments in
            var arg = Dictionary<String, Any>.init()
            arg["1"] = 1
            arg["2"] = "2"
            let testVc = HzFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: arg, initialRoute: "multi_engin2")
            return testVc
        }
        
        HzRouter.insertRouter(routeName: "multi_engin") { arguments in
            var arg = Dictionary<String, Any>.init()
            arg["1"] = 1
            arg["2"] = "2"
            let testVc = HzFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: arg, initialRoute: "multi_engin")
            return testVc
        }
        
        HzRouter.insertRouter(routeName: "multi_engin_native") { arguments in
            var arg = Dictionary<String, Any>.init()
            arg["1"] = 1
            arg["2"] = "2"
            let testVc = HzFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: arg, initialRoute: "multi_engin2")
            return testVc
        }
    }

}
