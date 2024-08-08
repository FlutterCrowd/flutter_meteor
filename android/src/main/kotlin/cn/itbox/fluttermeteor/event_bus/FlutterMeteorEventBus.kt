package cn.itbox.fluttermeteor.event_bus

import cn.itbox.fluttermeteor.FlutterMeteorPlugin
import kotlin.collections.HashMap

typealias FMEventBusListener = (Map<String, Any?>?) -> Unit

class FMEventBus {

    companion object {
        private val listeners: MutableMap<String, MutableList<FMEventBusListener>> = HashMap()

        @JvmStatic
        fun addListener(eventName: String, listener: FMEventBusListener) {
            listeners.getOrPut(eventName) { mutableListOf() }.add(listener)
        }

        @JvmStatic
        fun removeListener(eventName: String, listener: FMEventBusListener) {
            listeners[eventName]?.removeAll { it == listener }
        }

        @JvmStatic
        fun commit(eventName: String, data: Map<*, *>?) {
            // 通知原生的 listeners
            listeners[eventName]?.forEach { it(data) }

            // 遍历多引擎Channel
            val message = HashMap<String, Any?>()
            message["eventName"] = eventName
            message["data"] = data

            FlutterMeteorPlugin.channelHolderList.forEach { plugin ->
                plugin.eventBusChannel.send(message)
            }
        }

        // 处理从flutter端收到的消息
        @JvmStatic
        fun receiveMessageFromFlutter(message: Any?) {
            if (message is Map<*, *>) {
                val eventName = message["eventName"] as? String
                val data = message["data"] as? Map<*, *>
                if (eventName != null) {
                    commit(eventName, data)
                }
            }
        }
    }
}
