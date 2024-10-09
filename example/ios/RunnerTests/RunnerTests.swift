import Flutter
import UIKit
import XCTest

@testable import hz_router_plugin

// This demonstrates a simple unit test of the Swift portion of this plugin's implementation.
//
// See https://developer.apple.com/documentation/xctest for more information about using XCTest.

class RunnerTests: XCTestCase {
    func testGetPlatformVersion() {
        let plugin = HzRouterPlugin()

        let call = FlutterMethodCall(methodName: "getPlatformVersion", arguments: [])

        let resultExpectation = expectation(description: "result block must be called.")
        plugin.handle(call) { result in
            XCTAssertEqual(result as! String, "iOS " + UIDevice.current.systemVersion)
            resultExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}
