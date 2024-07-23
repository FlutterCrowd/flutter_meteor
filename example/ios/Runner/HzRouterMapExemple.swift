//
//  HzRouterMapExemple.swift
//  Runner
//
//  Created by itbox_djx on 2024/5/12.
//

import UIKit
import flutter_meteor

class HzRouterMapExemple  {
    
    static func setUp() -> Void {
        FlutterMeteorRouter.insertRouter(routeName: "test") { arguments in
            let testVc = TestViewController.init()
            return testVc
        }
        
        FlutterMeteorRouter.insertRouter(routeName: "test1") { arguments in
            let testVc = TestViewController1.init()
            return testVc
        }
        
        FlutterMeteorRouter.insertRouter(routeName: "test2") { arguments in
            let testVc = TestViewController2.init()
            return testVc
        }
        
        FlutterMeteorRouter.insertRouter(routeName: "push_native") { arguments in
            let testVc = TestViewController3.init()
            return testVc
        }
        
        FlutterMeteorRouter.insertRouter(routeName: "routeName") { arguments in
            let testVc = TestViewController.init()
            return testVc
        }
        
//        FlutterMeteorRouter.insertRouter(routeName: "test2") { arguments in
//            var arg = Dictionary<String, Any>.init()
//            arg["1"] = 1
//            arg["2"] = "2"
//            let testVc = FMFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: arg, initialRoute: "multi_engin2", popCallBack: nil)
//            return testVc
//        }
//        
        FlutterMeteorRouter.insertRouter(routeName: "multi_engin2") { arguments in
            var arg = Dictionary<String, Any>.init()
            arg["1"] = 1
            arg["2"] = "2"
            let testVc = FMFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: arg, initialRoute: "multi_engin2", popCallBack: nil)
            return testVc
        }
        
        FlutterMeteorRouter.insertRouter(routeName: "multi_engin") { arguments in
            var arg = Dictionary<String, Any>.init()
            arg["1"] = 1
            arg["2"] = "2"
            let testVc = FMFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: arg, initialRoute: "multi_engin", popCallBack: nil)
            return testVc
        }
        
        FlutterMeteorRouter.insertRouter(routeName: "multi_engin_native") { arguments in
            var arg = Dictionary<String, Any>.init()
            arg["1"] = 1
            arg["2"] = "2"
            let testVc = FMFlutterViewController.init(entryPoint: "childEntry", entrypointArgs: arg, initialRoute: "multi_engin2", popCallBack: nil)
            return testVc
        }
    }

}
