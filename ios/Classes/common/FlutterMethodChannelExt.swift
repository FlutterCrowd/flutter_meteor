//
//  FlutterMethodChannelExt.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/7/29.
//

import Foundation
import Flutter

extension FlutterMethodChannel {
//result: @escaping FlutterResult
    ///fix error: The 'itbox.meteor.channel' channel sent a message from native to Flutter on a non-platform thread. Platform channel messages must be sent on the platform thread. Failure to do so may result in data loss or crashes, and must be fixed in the plugin or application code creating that channel.
    func save_invoke(method: String, arguments: Any? = nil, result: FlutterResult? = nil) -> Void {
        DispatchQueue.main.async {
            self.invokeMethod(method, arguments: arguments, result: result)
        }
    }
    
}
