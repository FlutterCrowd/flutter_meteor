package cn.itbox.fluttermeteor.navigator

import android.app.Activity
import android.content.Intent
import android.util.Log
import kotlinx.coroutines.*

import cn.itbox.fluttermeteor.core.ActivityInjector
import cn.itbox.fluttermeteor.core.FlutterMeteor
import cn.itbox.fluttermeteor.core.FlutterMeteorRouteOptions
import cn.itbox.fluttermeteor.engine.EngineInjector
import cn.itbox.fluttermeteor.FlutterMeteorChannelProvider
import cn.itbox.fluttermeteor.core.ActivityInfo

import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.atomic.AtomicInteger


class NavigatorMethodHandler : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        println("onMethodCall: ${call.method}")
        when (call.method) {
            "pushNamed" -> handlePushNamed(call, result)
            "popUntil" -> {
                val routeName = call.argument<String>("routeName")
                if(routeName != null){
                    handlePopUntil(routeName)
                }
            }
            "pop" -> handlePop(call, result)
            "popToRoot" -> handlePopToRoot(result)

            "routeExists" -> {
                val routeName = call.argument<String>("routeName")
                if (routeName != null) {
                    routeExists(routeName, result)
                } else {
                    result.success(false)
                }
            }

            "isRoot" -> {
                val routeName = call.argument<String>("routeName")
                if (routeName != null) {
                    isRoot(routeName, result)
                } else {
                    result.success(false)
                }
            }

            "rootRouteName" -> rootRouteName(result)
            "topRouteName" -> topRouteName(result)
            "routeNameStack" -> routeNameStack(result)
            "topRouteIsNative" -> topRouteIsNative(result)
            "pushReplacementNamed" -> pushReplacementNamed(call, result)
            "pushNamedAndRemoveUntil" -> pushNamedAndRemoveUntil(call, result)
            "pushNamedAndRemoveUntilRoot" -> pushNamedAndRemoveUntilRoot(call, result)
            else -> result.notImplemented()
        }
    }

    private fun pushNamedAndRemoveUntilRoot(call: MethodCall, result: MethodChannel.Result) {
        FlutterMeteor.popToRoot()
        handlePushNamed(call, result)
    }

    private fun pushNamedAndRemoveUntil(call: MethodCall, result: MethodChannel.Result) {
        val untilName = call.argument<String>("untilRouteName")
        if(untilName != null){
            handlePopUntil(untilName)
            handlePushNamed(call, result)
        }
    }

    private fun pushReplacementNamed(call: MethodCall, result: MethodChannel.Result) {
        val routeName = call.argument<String>("routeName")
        if (routeName != null) {
            val activityInfoStack: List<ActivityInfo> = ActivityInjector.activityInfoStack
            CoroutineScope(Dispatchers.Main).launch {
                if (activityInfoStack.first().channelProvider != null) {
                    val provider = activityInfoStack.first().channelProvider!!
                    val channel = provider.navigatorChannel
                    val routeStack: List<String> =
                        callMethodSynchronously(
                            channel,
                            "routeNameStack"
                        ) as? List<String> ?: emptyList<String>()
                    if (routeStack.size > 1) {
                        callMethodSynchronously(
                            channel,
                            "pop"
                        )
                    } else {
                        ActivityInjector.popTop()
                    }
                } else {
                    ActivityInjector.popTop()
                }

                handlePushNamed(call, result)
            }
        } else {
            result.success(false)
        }
    }

    private fun handlePushNamed(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments
        if (arguments is Map<*, *>) {
            val withNewEngine = arguments["withNewEngine"] == true
            val isOpaque = arguments["isOpaque"] == true
            val openNative = arguments["openNative"] == true
            val routeName = arguments["routeName"]?.toString() ?: ""
            val routeArguments = arguments["arguments"]
            if (withNewEngine) {
                val argumentsMap = if (routeArguments is Map<*, *>) routeArguments else null
                ActivityInjector.currentActivity?.also { theActivity ->
                    val args = argumentsMap?.filter { it.value != null }
                        ?.map { it.key.toString() to it.value!! }?.toMap()
                    val builder = FlutterMeteorRouteOptions.Builder().initialRoute(routeName)
                    if (args != null) {
                        builder.arguments(args)
                    }
                    builder.backgroundMode(if (isOpaque) FlutterActivityLaunchConfigs.BackgroundMode.opaque else FlutterActivityLaunchConfigs.BackgroundMode.transparent)
                    FlutterMeteor.delegate?.onPushFlutterPage(theActivity, builder.build())
                }
            } else if (openNative) {
                FlutterMeteor.delegate?.onPushNativePage(routeName, routeArguments)
            }else{
                throw Exception("未指定新页面弹出方式")
            }
        }
        result.success(true)
    }

    private fun handlePopUntil(routeName: String) {
        CoroutineScope(Dispatchers.Main).launch {
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
        ActivityInjector.currentActivity?.setResult(
            if (arguments == null) Activity.RESULT_CANCELED else Activity.RESULT_OK,
            data
        )
        ActivityInjector.currentActivity?.finish()
    }

    private fun handlePopToRoot(result: MethodChannel.Result) {
        result.success(true).also { FlutterMeteor.popToRoot() }
    }

    /**
     * 出栈到指定路由
     */
    suspend fun popUntil(routeName: String) {
        val activityInfoStack = ActivityInjector.activityInfoStack
        val tempList = mutableListOf<ActivityInfo>()

        if (activityInfoStack.isEmpty()) {
            return
        }

        for (activityInfo in activityInfoStack) {
            val provider = activityInfo.channelProvider
            if (provider != null) {
                val channel = provider.navigatorChannel
                val routeStack: List<String>? =
                    callMethodSynchronously(channel, "routeNameStack") as? List<String>
                if (routeStack != null && routeStack.isNotEmpty()) {
                    if (routeStack.contains(routeName)) {
                        popActivity(tempList, channel, routeName)
                        return
                    } else {
                        tempList.add(activityInfo)
                    }
                } else {
                    tempList.add(activityInfo)
                }
            } else {
                if (routeName == activityInfo.routeName) {
                    for (info in tempList) {
                        info.avtivity.get()?.finish()
                    }
                    return
                } else {
                    tempList.add(activityInfo)
                }
            }
        }
    }

    /**
     * 出栈指定activity集合
     */
    private fun popActivity(list: List<ActivityInfo>, channel: MethodChannel, routeName: String) {
        for (info in list) {
            ActivityInjector.remove(info.avtivity.get()!!)
        }
        channel.invokeMethod("popUntil", mutableMapOf<String, Any>("routeName" to routeName))
    }

    private fun routeExists(routeName: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.Main).launch {
            collectRouteNamesFromChannels { finalRouteStack ->
                result.success(finalRouteStack.contains(routeName))
            }
        }
    }

    private fun isRoot(routeName: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.Main).launch {
            collectRouteNamesFromChannels { finalRouteStack ->
                result.success(routeName == finalRouteStack.firstOrNull())
            }
        }
    }

    private fun rootRouteName(result: MethodChannel.Result) {
        val activityInfoStack: List<ActivityInfo> = ActivityInjector.activityInfoStack
        if (activityInfoStack.isEmpty()) {
            return
        }
        val last: ActivityInfo = activityInfoStack.last()
        if (last.channelProvider != null) {
            val provider = last.channelProvider!!
            val channel = provider.navigatorChannel
            CoroutineScope(Dispatchers.Main).launch {
                val routeStack: List<String>? =
                    callMethodSynchronously(channel, "routeNameStack") as? List<String>
                result.success(routeStack?.lastOrNull())
            }
        }
    }

    private fun topRouteName(result: MethodChannel.Result) {
        val activityInfoStack: List<ActivityInfo> = ActivityInjector.activityInfoStack
        if (activityInfoStack.isEmpty()) {
            return
        }
        val last: ActivityInfo = activityInfoStack.first()
        if (last.channelProvider == null) {
            result.success(last.routeName)
        } else {
            val provider = last.channelProvider!!
            val channel = provider.navigatorChannel
            CoroutineScope(Dispatchers.Main).launch {
                val routeStack: List<String>? =
                    callMethodSynchronously(channel, "routeNameStack") as? List<String>
                result.success(routeStack?.lastOrNull())
            }
        }
    }

    private fun routeNameStack(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.Main).launch {
            collectRouteNamesFromChannels { finalRouteStack ->
                Log.e("FlutterMeteor", "collectRouteNamesFromChannels------$finalRouteStack")
                result.success(finalRouteStack)
            }
        }
    }

    private fun topRouteIsNative(result: MethodChannel.Result) {
        val activityInfoStack: List<ActivityInfo> = ActivityInjector.activityInfoStack
        result.success(activityInfoStack.firstOrNull()?.channelProvider == null)
    }

    suspend fun collectRouteNamesFromChannels(result: (List<String>) -> Unit) {
        val activityInfoStack = ActivityInjector.activityInfoStack
        val routeNameStack = mutableListOf<String>()

        if (activityInfoStack.isEmpty()) {
            result(emptyList())
            return
        }
        for (info in activityInfoStack) {
            val provider = info.channelProvider
            if (provider != null) {
                val channel = provider.navigatorChannel
                val routeStack: List<String>? =
                    callMethodSynchronously(
                        channel,
                        "routeNameStack"
                    ) as? List<String>
                routeNameStack.addAll((routeStack ?: emptyList<String>()).asReversed())
            } else {
                routeNameStack.add(info.routeName)
            }
        }
        result(routeNameStack.reversed())
    }


    suspend fun callMethodSynchronously(channel: MethodChannel, method: String): Any? =
        withContext(Dispatchers.Main.immediate) {
            // 创建一个 Deferred 对象用于保存异步操作的结果
            val resultDeferred = CompletableDeferred<Any?>()

            // 调用 invokeMethod 并将回调结果放入 Deferred 中
            channel.invokeMethod(method, null, object : MethodChannel.Result {
                override fun success(result: Any?) {
                    resultDeferred.complete(result)
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    resultDeferred.complete(null)
                }

                override fun notImplemented() {
                    resultDeferred.complete(null)
                }
            })

            // 等待结果并返回
            try {
                resultDeferred.await()
            } catch (e: CancellationException) {
                // 处理取消的情况
                println("Call was cancelled.")
                null
            } catch (e: Exception) {
                // 处理其他异常情况
                println("An error occurred: ${e.message}")
                null
            }
        }


}

