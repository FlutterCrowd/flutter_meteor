//
//  HzRouterMapExemple.swift
//  Runner
//
//  Created by itbox_djx on 2024/5/12.
//

import flutter_meteor
import UIKit

class HzRouterMapExemple {
    static func setUp() {
        MeteorRouterManager.insertRouter(routeName: "native_page") { _ in
            let testVc = TestViewController()
            testVc.hidesBottomBarWhenPushed = true
            testVc.title = "native_page"
            testVc.popCallBack = { result in
                print("TestViewController native_page pop result:\(result)")
            }
//            let navi = UINavigationController.init(rootViewController: testVc)
            return testVc
        }

        MeteorRouterManager.insertRouter(routeName: "native_page1") { _ in
            let testVc = TestViewController1()
            testVc.title = "native_page1"
            testVc.hidesBottomBarWhenPushed = true
            testVc.popCallBack = { result in
                print("TestViewController native_page pop result:\(result)")
            }
            return testVc
        }

        MeteorRouterManager.insertRouter(routeName: "native_page2") { _ in
            let testVc = TestViewController2()
            testVc.hidesBottomBarWhenPushed = true
            testVc.title = "native_page2"
            testVc.popCallBack = { result in
                print("TestViewController native_page pop result:\(result)")
            }
            return testVc
        }

        MeteorRouterManager.insertRouter(routeName: "native_page3") { _ in
            let testVc = TestViewController3()
            testVc.title = "native_page3"
            testVc.hidesBottomBarWhenPushed = true
            testVc.popCallBack = { result in
                print("TestViewController native_page pop result:\(result)")
            }
            return testVc
        }

        MeteorRouterManager.insertRouter(routeName: "native_page4") { _ in
            let testVc = TestViewController3()
            testVc.title = "native_page4"
            testVc.hidesBottomBarWhenPushed = true
            testVc.popCallBack = { result in
                print("TestViewController native_page pop result:\(result)")
            }
            return testVc
        }

        MeteorRouterManager.insertRouter(routeName: "push_native") { _ in
            let testVc = TabBarViewController()
            testVc.title = "push_native"
            testVc.hidesBottomBarWhenPushed = true
            testVc.modalPresentationStyle = .overFullScreen
            testVc.popCallBack = { result in
                print("TestViewController native_page pop result:\(result)")
            }
            return testVc
        }

        MeteorRouterManager.insertRouter(routeName: "routeName") { _ in
            let testVc = TestViewController()
            testVc.hidesBottomBarWhenPushed = true
            testVc.popCallBack = { result in
                print("TestViewController native_page pop result:\(result)")
            }
            return testVc
        }

        MeteorRouterManager.insertRouter(routeName: "multiEnginePage2") { _ in
            var arg = [String: Any]()
            arg["1"] = 1
            arg["2"] = "2"
            let engineGroupOptions = MeteorEngineGroupOptions(
                entrypoint: "main",
                initialRoute: "multiEnginePage2",
                entrypointArgs: arg
            )
            let testVc = MeteorFlutterViewController(options: engineGroupOptions, popCallBack: nil)
            testVc.hidesBottomBarWhenPushed = true
            testVc.popCallBack = { result in
                print("MeteorFlutterViewController multiEnginePage2 pop result:\(result)")
            }
            return testVc
        }

        MeteorRouterManager.insertRouter(routeName: "multiEnginePage") { _ in
            var arg = [String: Any]()
            arg["1"] = 1
            arg["2"] = "2"
            let engineGroupOptions = MeteorEngineGroupOptions(
                entrypoint: "main",
                initialRoute: "multiEnginePage",
                entrypointArgs: arg
            )
            let testVc = MeteorFlutterViewController(options: engineGroupOptions, popCallBack: nil)
            testVc.hidesBottomBarWhenPushed = true
            testVc.popCallBack = { result in
                print("MeteorFlutterViewController multiEnginePage pop result:\(result)")
            }
            return testVc
        }
    }
}
