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
        MeteorRouterManager.insertRouter(routeName: "native_page") { arguments in
            let testVc = TestViewController.init()
            testVc.hidesBottomBarWhenPushed = true
            testVc.title = "native_page"
//            let navi = UINavigationController.init(rootViewController: testVc)
            return testVc
        }
        
        MeteorRouterManager.insertRouter(routeName: "native_page1") { arguments in
            let testVc = TestViewController1.init()
            testVc.title = "native_page1"
            testVc.hidesBottomBarWhenPushed = true
            return testVc
        }
        
        MeteorRouterManager.insertRouter(routeName: "native_page2") { arguments in
            let testVc = TestViewController2.init()
            testVc.hidesBottomBarWhenPushed = true
            testVc.title = "native_page2"
            return testVc
        }
        
        MeteorRouterManager.insertRouter(routeName: "native_page3") { arguments in
            let testVc = TestViewController3.init()
            testVc.title = "native_page3"
            testVc.hidesBottomBarWhenPushed = true
            return testVc
        }
        
        MeteorRouterManager.insertRouter(routeName: "native_page4") { arguments in
            let testVc = TestViewController3.init()
            testVc.title = "native_page4"
            testVc.hidesBottomBarWhenPushed = true
            return testVc
        }
        
        MeteorRouterManager.insertRouter(routeName: "push_native") { arguments in
            let testVc = TabBarViewController.init()
            testVc.title = "push_native"
            testVc.hidesBottomBarWhenPushed = true
            return testVc
        }
        
        MeteorRouterManager.insertRouter(routeName: "routeName") { arguments in
            let testVc = TestViewController.init()
            testVc.hidesBottomBarWhenPushed = true
            return testVc
        }
        
        MeteorRouterManager.insertRouter(routeName: "multiEnginePage2") { arguments in
            var arg = Dictionary<String, Any>.init()
            arg["1"] = 1
            arg["2"] = "2"
            let engineGroupOptions = MeteorEngineGroupOptions.init(
                entrypoint: "main",
                initialRoute: "multiEnginePage2",
                entrypointArgs: arg)
            let testVc = MeteorFlutterViewController.init(options: engineGroupOptions, popCallBack: nil)
            testVc.hidesBottomBarWhenPushed = true
            return testVc
        }
        
        MeteorRouterManager.insertRouter(routeName: "multiEnginePage") { arguments in
            var arg = Dictionary<String, Any>.init()
            arg["1"] = 1
            arg["2"] = "2"
            let engineGroupOptions = MeteorEngineGroupOptions.init(
                entrypoint: "main",
                initialRoute: "multiEnginePage",
                entrypointArgs: arg)
            let testVc = MeteorFlutterViewController.init(options: engineGroupOptions, popCallBack: nil)
            testVc.hidesBottomBarWhenPushed = true
            return testVc
        }
    }

}
