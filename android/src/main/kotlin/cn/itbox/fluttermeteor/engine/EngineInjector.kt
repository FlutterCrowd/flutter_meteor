
package cn.itbox.fluttermeteor.engine

import android.util.Log
import cn.itbox.fluttermeteor.core.FlutterMeteor
import cn.itbox.fluttermeteor.FlutterMeteorChannelProvider
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference
import java.util.WeakHashMap

class WeakReferenceList<T> {
    private val list = mutableListOf<WeakReference<T>>()

    // 添加元素
    fun add(element: T) {
        list.add(WeakReference(element))
    }

    // 移除元素
    fun remove(element: T) {
        list.removeAll { it.get() == element }
    }

    // 清理已被垃圾回收的引用
    fun cleanUp() {
        list.removeAll { it.get() == null }
    }

    // 获取当前有效的元素
    fun getAll(): List<T> {
        cleanUp()
        return list.mapNotNull { it.get() }
    }

    fun getFirst(): T? {
        cleanUp()
        return list.firstOrNull()?.get()
    }

    fun getLast(): T? {
        return list.lastOrNull()?.get()
    }


    // 迭代有效元素
    fun forEach(action: (T) -> Unit) {
        cleanUp()
        list.forEach { it.get()?.let(action) }
    }
}

object EngineInjector {

//    private var mainEngine: WeakReference<FlutterEngine>? = null

    // 创建一个 WeakHashMap 实例
    private val weakMap = WeakHashMap<FlutterEngine, FlutterMeteorChannelProvider?>()

    private val channelProviders = WeakReferenceList<FlutterMeteorChannelProvider>()

//    fun setMainEngine(engine: FlutterEngine) {
//        mainEngine = WeakReference(engine)
//    }

    fun put(engine: FlutterEngine, channelProvider: FlutterMeteorChannelProvider) {
        weakMap[engine] = channelProvider
        channelProviders.add(channelProvider)
    }

    fun getChannelProvider(engine: FlutterEngine) = weakMap[engine]

//    fun getMainChannelProvider(): FlutterMeteorChannelProvider? {
//        val main = mainEngine?.get()
//        if (main != null) {
//            return getChannelProvider(main)
//        }
//        return null
//    }

    fun remove(engine: FlutterEngine) {
        val channelProvider = weakMap[engine]
        weakMap.remove(engine)
        if (channelProvider != null) {
            channelProviders.remove(channelProvider)
        }
    }

    fun getMapEntries() = weakMap.entries

    fun allChannelProviders() = channelProviders.getAll()//weakMap.values.toList()

    fun lastChannelProvider() = channelProviders.getLast()//weakMap.values.toList().last()

    fun firstChannelProvider() = channelProviders.getFirst()//weakMap.values.toList().first()

    fun removeLast(){
        if (weakMap.isEmpty()) {
            return
        }
        val engine = weakMap.entries.last().key
        weakMap.remove(engine)
        lastChannelProvider()?.let { channelProviders.remove(it) }
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