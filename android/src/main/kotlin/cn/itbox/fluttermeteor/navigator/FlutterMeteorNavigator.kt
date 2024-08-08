package cn.itbox.fluttermeteor.navigator

import android.app.Activity
import android.content.Intent

import cn.itbox.fluttermeteor.core.ActivityInjector
import cn.itbox.fluttermeteor.core.FlutterMeteor
import cn.itbox.fluttermeteor.core.FlutterMeteorRouteOptions
import cn.itbox.fluttermeteor.engine.EngineInjector
import cn.itbox.fluttermeteor.FlutterMeteorChannelProvider
import cn.itbox.fluttermeteor.router.FlutterMeteorRouter

import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.atomic.AtomicInteger


class FlutterMeteorNavigator : MethodChannel.MethodCallHandler {
    var activity: Activity? = null
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        println("onMethodCall: ${call.method}")
        when (call.method) {
            "pushNamed" -> handlePushNamed(call, result)
            "popUntil" -> handlePopUntil(call, result)
            "pop" -> handlePop(call, result)
            "popToRoot" -> handlePopToRoot(result)
            else -> result.notImplemented()
        }
    }

    private fun handlePushNamed(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments
        if (arguments is Map<*, *>) {
            val withNewEngine = arguments["withNewEngine"] == true
            val newEngineOpaque = arguments["newEngineOpaque"] == true
            val openNative = arguments["openNative"] == true
            val routeName = arguments["routeName"]?.toString() ?: ""
            val routeArguments = arguments["arguments"]

            if (withNewEngine) {
                val argumentsMap = if (routeArguments is Map<*, *>) routeArguments else null
                activity?.also { theActivity ->
                    val args = argumentsMap?.filter { it.value != null }
                        ?.map { it.key.toString() to it.value!! }?.toMap()
                    val builder = FlutterMeteorRouteOptions.Builder().initialRoute(routeName)
                    if (args != null) {
                        builder.arguments(args)
                    }
                    builder.backgroundMode(if (newEngineOpaque) FlutterActivityLaunchConfigs.BackgroundMode.opaque else FlutterActivityLaunchConfigs.BackgroundMode.transparent)
                    FlutterMeteor.delegate?.onPushFlutterPage(theActivity, builder.build())
                }
            } else if (openNative) {
                FlutterMeteor.delegate?.onPushNativePage(routeName, routeArguments)
            }
        }
        result.success(true)
    }

    private fun handlePopUntil(call: MethodCall, result: MethodChannel.Result) {
        val routeName = call.argument<String>("routeName")
        if (routeName != null) {
            popUntil(routeName)
        }
    }

    private fun handlePop(call: MethodCall, result: MethodChannel.Result) {
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

    private fun handlePopToRoot(result: MethodChannel.Result) {
        result.success(true).also { FlutterMeteor.popToRoot() }
    }

    /**
     * 出栈到指定路由
     */
    private fun popUntil(routeName: String) {
        val entries = EngineInjector.getMapEntries().reversed()
        val popEngineSet: MutableSet<MutableMap.MutableEntry<FlutterEngine, FlutterMeteorChannelProvider>> = mutableSetOf()

        entries.forEach { (engine, channelProvider) ->
            channelProvider?.routerChannel?.invokeMethod("routeNameStack", null, object : MethodChannel.Result {
                override fun success(p0: Any?) {
                    val routeStack: List<String> = p0 as List<String>
                    if (routeStack.isNotEmpty()) {
                        if (routeStack.contains(routeName)) {
                            // 显pop其他引擎
                            if (popEngineSet.size < 1) {
                                channelProvider.navigatorChannel.invokeMethod("popUntil", mutableMapOf<String, Any>("routeName" to routeName))
                            } else {
                                popEngine(popEngineSet, routeName) {
                                    channelProvider.navigatorChannel.invokeMethod("popUntil", mutableMapOf<String, Any>("routeName" to routeName))
                                }
                            }
                            return
                        } else {
                            val entry = mutableMapOf<FlutterEngine, FlutterMeteorChannelProvider>()
                            entry[engine] = channelProvider
                            popEngineSet.addAll(entry.entries)
                        }
                    }
                }

                override fun error(p0: String, p1: String?, p2: Any?) {}

                override fun notImplemented() {}
            })
        }
    }

    /**
     * pop指定引擎
     */
    private fun popEngine(entries: MutableSet<MutableMap.MutableEntry<FlutterEngine, FlutterMeteorChannelProvider>>, routeName: String, result: (Boolean) -> Unit) {
        val remainingCalls = AtomicInteger(entries.size)

        entries.forEach { (_, channelProvider) ->
            channelProvider.navigatorChannel.invokeMethod("popToRoot", null, object : MethodChannel.Result {
                override fun success(p0: Any?) {
                    ActivityInjector.popActivity(routeName)

                    if (remainingCalls.decrementAndGet() == 0) {
                        result(true)
                    }
                }

                override fun error(p0: String, p1: String?, p2: Any?) {
                    if (remainingCalls.decrementAndGet() == 0) {
                        result(true)
                    }
                }

                override fun notImplemented() {
                    if (remainingCalls.decrementAndGet() == 0) {
                        result(true)
                    }
                }
            })
        }
    }
}

