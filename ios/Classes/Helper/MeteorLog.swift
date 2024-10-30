//
//  MeteorLog.swift
//  flutter_meteor
//
//  Created by itbox_djx on 2024/10/28.
//

import UIKit

class MeteorLog: NSObject {

    static func error(_ message: String) {
        print("[Meteor][Error]: \(message)")
    }
    
    static func warning(_ message: String) {
        print("[Meteor][Warning]: \(message)")
    }

    static func info(_ message: String) {
        print("[Meteor][Info]: \(message)")
    }
    
    static func debug(_ message: String) {
        #if DEBUG
        print("[Meteor][Debug]: \(message)")
        #endif
    }
}
