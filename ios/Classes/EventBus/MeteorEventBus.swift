import UIKit
import Flutter

// 定义事件监听器的别名
typealias MeteorEventBusListener = ([String: Any?]?) -> Void

// 事件监听器条目，包含监听器 ID 和监听器函数
private struct MeteorEventBusListenerItem {
    let listenerId: String?
    let listener: MeteorEventBusListener
    
    init(listenerId: String? = nil, listener: @escaping MeteorEventBusListener) {
        self.listenerId = listenerId
        self.listener = listener
    }
}

class MeteorEventBus: NSObject {

    // 存储事件监听器
    private static var listeners = [String: [MeteorEventBusListenerItem]]()

    // 添加事件监听器
    static func addListener(eventName: String, listenerId: String? = nil, listener: @escaping MeteorEventBusListener) {
        let item = MeteorEventBusListenerItem(listenerId: listenerId, listener: listener)
        listeners[eventName, default: []].append(item)
    }

    // 移除事件监听器
    static func removeListener(eventName: String, listenerId: String? = nil, listener: MeteorEventBusListener? = nil) {
        guard var items = listeners[eventName] else { return }
        
        if let listenerId = listenerId {
            items.removeAll { $0.listenerId == listenerId }
        } else if let listener = listener {
            items.removeAll { $0.listener as AnyObject === listener as AnyObject }
        } else {
            items.removeAll()
        }

        listeners[eventName] = items.isEmpty ? nil : items
    }

    // 触发事件
    static func commit(eventName: String, data: [String: Any?]?) {
        listeners[eventName]?.forEach { $0.listener(data) }

        let message: [String: Any?] = [
            "eventName": eventName,
            "data": data
        ]
        
        FlutterMeteorPlugin.channelHolderMap.allObjects()?.forEach { provider in
            provider.eventBusChannel.sendMessage(message)
        }
    }

    // 处理从 Flutter 端收到的消息
    static func receiveMessageFromFlutter(message: Any?) {
        guard let map = message as? [String: Any?],
              let eventName = map["eventName"] as? String else { return }
        
        commit(eventName: eventName, data: map["data"] as? [String: Any?])
    }
}

