package cn.itbox.fluttermeteor.event_bus
import cn.itbox.fluttermeteor.engine.EngineInjector

import android.os.Build
import androidx.annotation.RequiresApi



import kotlin.collections.HashMap

typealias FMEventBusListener = (Map<String, Any?>?) -> Unit

class FlutterMeteorEventBus {

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

        @RequiresApi(Build.VERSION_CODES.N)
        @JvmStatic
        fun commit(eventName: String, data: Map<String, Any?>?) {
            // 通知原生的 listeners
            listeners[eventName]?.forEach { listener ->
                listener(data);
            }

            // 遍历多引擎Channel
            val message = HashMap<String, Any?>()
            message["eventName"] = eventName
            message["data"] = data

            EngineInjector.allChannelProviders().forEach { provider ->
                if (provider != null) {
                    provider.eventBusChannel.send(message);
                }
            }
        }


        // 处理从flutter端收到的消息
        @RequiresApi(Build.VERSION_CODES.N)
        @JvmStatic
        fun receiveMessageFromFlutter(message: Any?) {
            if (message is Map<*, *>) {
                val eventName = message["eventName"] as? String
                val data = message["data"] as? Map<String, Any?>
                if (eventName != null) {
                    commit(eventName, data)
                }
            }
        }
    }
}
