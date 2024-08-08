
package cn.itbox.fluttermeteor.engine

import android.util.Log
import cn.itbox.fluttermeteor.core.FlutterMeteor
import cn.itbox.fluttermeteor.FlutterMeteorChannelProvider
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference
import java.util.WeakHashMap

object EngineInjector {

    private var mainEngine: WeakReference<FlutterEngine>? = null

//    private val map = mutableMapOf<FlutterEngine, MethodChannel>()

    // 创建一个 WeakHashMap 实例
    private val weakMap = WeakHashMap<FlutterEngine, FlutterMeteorChannelProvider?>()

    fun setMainEngine(engine: FlutterEngine) {
        mainEngine = WeakReference(engine)
    }

    fun put(engine: FlutterEngine, channelProvider: FlutterMeteorChannelProvider) {
        weakMap[engine] = channelProvider
    }

    fun getChannelProvider(engine: FlutterEngine) = weakMap[engine]

    fun getMainChannelProvider(): FlutterMeteorChannelProvider? {
        val main = mainEngine?.get()
        if (main != null) {
            return getChannelProvider(main)
        }
        return null
    }

    fun remove(engine: FlutterEngine) {
        weakMap.remove(engine)
    }

    fun getMapEntries() = weakMap.entries

    fun allChannelProviders() = weakMap.values.toList()

    fun lastChannelProvider() = weakMap.values.toList().last()

    fun firstChannelProvider() = weakMap.values.toList().first()

    fun removeLast(){
        if (weakMap.isEmpty()) {
            return
        }
        val engine = weakMap.entries.last().key
        weakMap.remove(engine)
    }
}



//package cn.itbox.fluttermeteor.engine
//
//import android.util.Log
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//import java.lang.ref.WeakReference
//
//object EngineInjector {
//
//    private var mainEngine: WeakReference<FlutterEngine>? = null
//
//    private val map = mutableMapOf<FlutterEngine, MethodChannel>()
//
//    fun setMainEngine(engine: FlutterEngine) {
//        mainEngine = WeakReference(engine)
//    }
//
//    fun put(engine: FlutterEngine, channel: MethodChannel) {
//        map[engine] = channel
//    }
//
//    fun getChannel(engine: FlutterEngine) = map[engine]
//
//    fun getMainChannel(): MethodChannel? {
//        val main = mainEngine?.get()
//        if (main != null) {
//            return getChannel(main)
//        }
//        return null
//    }
//
//    fun remove(engine: FlutterEngine) {
//        map.remove(engine)
//    }
//
//    fun getMapEntries() = map.entries
//
//    fun allChannels() = map.values.toList()
//
//    fun lastChannel() = map.values.toList().last()
//
//    fun firstChannel() = map.values.toList().first()
//
//    fun removeLast(){
//        if (map.isEmpty()) {
//            return
//        }
//        val engine = map.entries.last().key
//        map.remove(engine)
//    }
//}