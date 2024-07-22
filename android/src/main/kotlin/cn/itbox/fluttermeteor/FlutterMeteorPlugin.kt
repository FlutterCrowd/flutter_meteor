package cn.itbox.fluttermeteor

import android.app.Activity
import android.content.Intent
import android.util.Log
import cn.itbox.fluttermeteor.core.ActivityInjector
import cn.itbox.fluttermeteor.core.FlutterMeteor
import cn.itbox.fluttermeteor.core.FlutterMeteorRouteOptions
import cn.itbox.fluttermeteor.engine.EngineInjector
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.atomic.AtomicInteger

/** HzRouterPlugin */
class FlutterMeteorPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "itbox.meteor.channel"
        )
        channel.setMethodCallHandler(this)
        println("开始注册插件")
        EngineInjector.put(flutterPluginBinding.flutterEngine, channel)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        println("onMethodCall: ${call.method}")
        when (call.method) {
            "pushNamed" -> {
                val arguments = call.arguments
                if (arguments is Map<*, *>) {
                    val withNewEngine = arguments["withNewEngine"] == true
                    val newEngineOpaque = arguments["newEngineOpaque"] == true
                    val openNative = arguments["openNative"] == true
                    val routeName = arguments["routeName"]?.toString() ?: ""
                    val initialRoute = arguments["initialRoute"]?.toString() ?: ""
                    val routeArguments = arguments["arguments"]
                    if (withNewEngine) {
                        val argumentsMap = if (routeArguments is Map<*, *>) routeArguments else null
                        activity?.also { theActivity ->
                            val args = argumentsMap?.filter { it. value != null }
                                ?.map { it.key.toString() to it.value!! }?.toMap()
                            val builder = FlutterMeteorRouteOptions.Builder().initialRoute(routeName)
                            if (args != null) {
                                builder.arguments(args)
                            }
                            builder.backgroundMode(if (newEngineOpaque) FlutterActivityLaunchConfigs.BackgroundMode.opaque else FlutterActivityLaunchConfigs.BackgroundMode.transparent)
                            Log.e("FlutterMeteor","onPushFlutterPage------$initialRoute")
                            FlutterMeteor.delegate?.onPushFlutterPage(theActivity, builder.build())
                        }
                    } else if (openNative) {
                        Log.e("FlutterMeteor","onPushNativePage------$routeName<------->$routeArguments")
                        FlutterMeteor.delegate?.onPushNativePage(routeName, routeArguments)
                    }
                }
                result.success(true)
            }
            "popUntil" ->{
                val routeName = call.argument<String>("routeName")
                Log.e("FlutterMeteor","popUntil------$routeName")
                if(routeName != null){
                    popUntil(routeName)
                }
            }
            "pop" -> {
                result.success(true)
                val arguments = call.arguments
                val data = Intent()
                if (arguments is Map<*, *>) {
                    arguments.forEach {
                        val key = it.key.toString()
                        when (val value = it.value) {
                            is Int -> data.putExtra(key, value)
                            is Double -> data.putExtra(key, value)
                            is Boolean -> data.putExtra(key, value)
                            is String -> data.putExtra(key, value)
                            is List<*> -> data.putExtra(key, ArrayList(value))
                            is Map<*, *> -> data.putExtra(key, HashMap(value))
                        }
                    }
                }
                activity?.setResult(if (arguments == null) Activity.RESULT_CANCELED else Activity.RESULT_OK, data)
                activity?.finish()
            }
            "popToRoot" -> {
                result.success(true).also { FlutterMeteor.popToRoot() }
            }
            "cn.itbox.multiEnginEvent" -> { // MeteorEventBus
                EngineInjector.allChannels().forEach {
                    it.invokeMethod(call.method, call.arguments)
                }
                result.success(true)
            }
            "routeExists" -> {
                val routeName = call.argument<String>("routeName")
                collectRouteNamesFromChannels() { finalRouteStack ->
                    result.success(finalRouteStack.contains(routeName))
                }
            }
            "isRoot" -> {
                val routeName = call.argument<String>("routeName")
                collectRouteNamesFromChannels() { finalRouteStack ->
                    result.success(routeName == finalRouteStack.first())
                }
            }
            "rootRouteName" -> {
                EngineInjector.firstChannel().invokeMethod("routeNameStack",null,object :MethodChannel.Result{
                    override fun success(p0: Any?) {
                        val routeStack: List<String> = p0 as List<String>
                        if(routeStack.isNotEmpty()){
                            result.success(routeStack.first())
                        }else{
                            result.success("")
                        }
                    }

                    override fun error(p0: String, p1: String?, p2: Any?) {
                        result.success("")
                    }

                    override fun notImplemented() {
                        result.success("")
                    }

                })
            }
            "topRouteName" -> {
                EngineInjector.lastChannel().invokeMethod("routeNameStack",null,object :MethodChannel.Result{
                    override fun success(p0: Any?) {
                        val routeStack: List<String> = p0 as List<String>
                        if(routeStack.isNotEmpty()){
                            val activityRouteName = ActivityInjector.lastActivityRouteName
                            if(activityRouteName != "" && !routeStack.contains(activityRouteName)){
                                result.success(activityRouteName)
                            }else{
                                result.success(routeStack.last())
                            }
                        }else{
                            result.success("")
                        }
                    }

                    override fun error(p0: String, p1: String?, p2: Any?) {
                        result.success("")
                    }

                    override fun notImplemented() {
                        result.success("")
                    }

                })
            }
            "routeNameStack" -> {
                collectRouteNamesFromChannels() { finalRouteStack ->
                    Log.e("FlutterMeteor","collectRouteNamesFromChannels------$finalRouteStack")
                    result.success(finalRouteStack)
                }
            }
            "topRouteIsNative" -> {
                EngineInjector.lastChannel().invokeMethod("routeNameStack",null,object :MethodChannel.Result{
                    override fun success(p0: Any?) {
                        val routeStack: List<String> = p0 as List<String>
                        if(routeStack.isNotEmpty()){
                            val activityRouteName = ActivityInjector.lastActivityRouteName
                            if(activityRouteName != "" && !routeStack.contains(activityRouteName)){
                                result.success(true)
                            }else{
                                result.success(false)
                            }
                        }else{
                            result.success(null)
                        }
                    }

                    override fun error(p0: String, p1: String?, p2: Any?) {
                        result.success(null)
                    }

                    override fun notImplemented() {
                        result.success(null)
                    }

                })
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    /**
     * 遍历当前所有引擎channel
     */
    private fun collectRouteNamesFromChannels(result: (List<String>) -> Unit) {
        val channels = EngineInjector.allChannels()
        val routeNameStack = mutableListOf<String>()
        val remainingCalls = AtomicInteger(channels.size)
        if (channels.isNotEmpty()) {
            for ((index, channel) in channels.withIndex()) {
                channel.invokeMethod("routeNameStack", null, object : MethodChannel.Result {
                    override fun success(p0: Any?) {
                        val routeStack: List<String> = p0 as List<String>
                        if (routeStack.isNotEmpty()) {
                            synchronized(routeNameStack) {
                                routeNameStack.addAll(routeStack)
                            }
                        }
                        if (remainingCalls.decrementAndGet() == 0) {
                            // 所有调用已经完成，调用传入的回调函数
                            result.invoke(routeNameStack)
                        }
                    }

                    override fun error(p0: String, p1: String?, p2: Any?) {
                        // 错误处理
                        if (remainingCalls.decrementAndGet() == 0) {
                            // 所有调用已经完成，调用传入的回调函数
                            result.invoke(routeNameStack)
                        }
                    }

                    override fun notImplemented() {
                        // 未实现情况处理
                        if (remainingCalls.decrementAndGet() == 0) {
                            // 所有调用已经完成，调用传入的回调函数
                            result.invoke(routeNameStack)
                        }
                    }
                })
            }
        } else {
            // 如果channels为空，直接调用传入的回调函数
            result.invoke(emptyList())
        }
    }

    /**
     * 出栈到指定路由
     */
    private fun popUntil(routeName: String) {
        val entries = EngineInjector.getMapEntries().reversed()
        val popEngineSet: MutableSet<MutableMap.MutableEntry<FlutterEngine, MethodChannel>> = mutableSetOf()

        entries.forEach { (engine, channel) ->
            channel.invokeMethod("routeNameStack", null, object : MethodChannel.Result {
                override fun success(p0: Any?) {
                    val routeStack: List<String> = p0 as List<String>
                    if (routeStack.isNotEmpty()) {
                       if(routeStack.contains(routeName)){
                               ///显pop其他引擎
                               if(popEngineSet.size < 1){
                                   channel.invokeMethod("popUntil", mutableMapOf<String,Any>("routeName" to routeName))
                               }else{
                                   popEngine(popEngineSet, routeName,result = {
                                       channel.invokeMethod("popUntil", mutableMapOf<String,Any>("routeName" to routeName))
                                   })
                               }
                           return
                       }else{
                           val entry = mutableMapOf<FlutterEngine, MethodChannel>()
                           entry.put(engine,channel)
                           popEngineSet.addAll((entry.entries))
                       }
                    }
                }

                override fun error(p0: String, p1: String?, p2: Any?) {

                }

                override fun notImplemented() {

                }
            })
        }
    }

    /**
     * pop指定引擎
     */
    private fun popEngine(entries: MutableSet<MutableMap.MutableEntry<FlutterEngine, MethodChannel>>,routeName:String,result: (Boolean) -> Unit) {
        val remainingCalls = AtomicInteger(entries.size)

        entries.forEach { (engine, channel) ->

            channel.invokeMethod("popToRoot", null,object : MethodChannel.Result{
                override fun success(p0: Any?) {
                      ActivityInjector.popActivity(routeName)

                    if (remainingCalls.decrementAndGet() == 0) {
                        // 所有调用已经完成，调用传入的回调函数
                        result.invoke(true)
                    }
                }

                override fun error(p0: String, p1: String?, p2: Any?) {
                    if (remainingCalls.decrementAndGet() == 0) {
                        // 所有调用已经完成，调用传入的回调函数
                        result.invoke(true)
                    }
                }

                override fun notImplemented() {
                    if (remainingCalls.decrementAndGet() == 0) {
                        // 所有调用已经完成，调用传入的回调函数
                        result.invoke(true)
                    }
                }

            })

        }
    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        EngineInjector.remove(binding.flutterEngine)
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
