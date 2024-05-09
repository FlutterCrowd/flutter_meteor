package cn.itbox.hz_router_plugin.engine

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference

object EngineInjector {

    private var mainEngine: WeakReference<FlutterEngine>? = null

    private val map = mutableMapOf<FlutterEngine, MethodChannel>()

    fun setMainEngine(engine: FlutterEngine) {
        mainEngine = WeakReference(engine)
    }

    fun put(engine: FlutterEngine, channel: MethodChannel) {
        map[engine] = channel
    }

    fun getChannel(engine: FlutterEngine) = map[engine]

    fun getMainChannel(): MethodChannel? {
        val main = mainEngine?.get()
        if (main != null) {
            return getChannel(main)
        }
        return null
    }

    fun remove(engine: FlutterEngine) {
        map.remove(engine)
    }

}