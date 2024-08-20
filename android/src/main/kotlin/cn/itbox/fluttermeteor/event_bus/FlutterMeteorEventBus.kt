package cn.itbox.fluttermeteor.event_bus
import cn.itbox.fluttermeteor.engine.EngineInjector

typealias MeteorEventBusListener = (Any?) -> Unit

private data class MeteorEventBusListenerItem(
    val listenerId: String?,
    val listener: MeteorEventBusListener
)

object MeteorEventBus {

    private val listeners = mutableMapOf<String, MutableList<MeteorEventBusListenerItem>>()

    fun addListener(eventName: String, listenerId: String? = null, listener: MeteorEventBusListener) {
        listeners.getOrPut(eventName) { mutableListOf() }.add(MeteorEventBusListenerItem(listenerId, listener))
    }

    fun removeListener(eventName: String, listenerId: String? = null, listener: MeteorEventBusListener? = null) {
        listeners[eventName]?.apply {
            when {
                listenerId != null -> removeAll { it.listenerId == listenerId }
                listener != null -> removeAll { it.listener == listener }
                else -> clear()
            }
        }
    }

    fun commit(eventName: String, data: Any?) {
        // Notify native listeners
        listeners[eventName]?.forEach { it.listener(data) }

        // Broadcast to multiple engine channels
        val message = mutableMapOf<String, Any?>(
            "eventName" to eventName,
            "data" to data
        )

        EngineInjector.allChannelProviders().forEach { provider ->
            provider?.eventBusChannel?.send(message)
        }
    }

    // Handle messages received from Flutter
    fun receiveMessageFromFlutter(message: Any?) {
        (message as? Map<String, Any?>)?.let { map ->
            map["eventName"]?.let { eventName ->
                commit(eventName as String, map["data"])
            }
        }
    }
}

