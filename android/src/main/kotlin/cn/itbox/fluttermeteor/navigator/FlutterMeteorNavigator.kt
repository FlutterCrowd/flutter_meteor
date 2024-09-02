package cn.itbox.fluttermeteor.navigator

import android.app.Activity
import android.content.Intent
import android.util.Log
import cn.itbox.fluttermeteor.core.ActivityInfo
import cn.itbox.fluttermeteor.core.ActivityInjector
import cn.itbox.fluttermeteor.core.FlutterMeteor
import cn.itbox.fluttermeteor.core.FlutterMeteorRouteOptions
import cn.itbox.fluttermeteor.engine.EngineInjector
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlin.coroutines.cancellation.CancellationException

object FlutterMeteorNavigator {
    private val TAG = "FlutterMeteorNavigator"

    @JvmStatic
    fun push(routeName: String, options: MeteorPushOptions? = null) {
        if(options != null){
            val pageType = options.pageType
            val isOpaque = options.isOpaque
            val routeArguments = options.arguments
            if (pageType == MeteorPageType.NEW_ENGINE) {
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
                    handleCallback(options,true)
                }
            } else if (pageType == MeteorPageType.NATIVE) {
                FlutterMeteor.delegate?.onPushNativePage(routeName, routeArguments)
                handleCallback(options,true)
            }else{
                handleCallback(options,false)
                throw Exception("未指定新页面弹出方式")
            }
        }
    }

    @JvmStatic
    fun pop(options: MeteorPopOptions? = null) {
        if(options != null){
            val arguments = options.arguments
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
        }
        ActivityInjector.currentActivity?.finish()
    }

    @JvmStatic
    fun popUntil(untilRouteName: String?, options: MeteorPopOptions? = null) {
        if(untilRouteName != null){
            CoroutineScope(Dispatchers.Main).launch {
                handlePopUntil(untilRouteName)
            }
        }
    }

    @JvmStatic
    fun popUntilFirst(untilRouteName: String?) {
        if(untilRouteName != null){
            CoroutineScope(Dispatchers.Main).launch {
                handlePopUntilFirst(untilRouteName)
            }
        }
    }

    @JvmStatic
    fun popToRoot() {
//        FlutterMeteor.popToRoot()
        ActivityInjector.finishToRoot()
        val provider =  EngineInjector.firstChannelProvider()
        provider?.navigatorChannel?.invokeMethod("popToRoot", null)
    }

    @JvmStatic
    fun pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: MeteorPushOptions? = null) {
        if (untilRouteName != null) {
            CoroutineScope(Dispatchers.Main).launch {
                handlePopUntil(untilRouteName)
            }
        }
        push(routeName, options)
    }

    @JvmStatic
    fun pushNamedAndRemoveUntilRoot(routeName: String, options: MeteorPushOptions? = null) {
        FlutterMeteor.popToRoot()
        push(routeName, options)
    }

    @JvmStatic
    fun pushToReplacement(routeName: String, options: MeteorPushOptions? = null) {
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
            push(routeName, options)
        }
    }

    @JvmStatic
    fun dismiss(options: MeteorPopOptions? = null) {
    }

    /*------------------------router method start--------------------------*/

    @JvmStatic
    fun searchRoute(routeName: String) {
    }

    @JvmStatic
    fun routeExists(routeName: String, isExists: (Boolean) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            collectRouteNamesFromChannels { finalRouteStack ->
                isExists(finalRouteStack.contains(routeName))
            }
        }
    }

    @JvmStatic
    fun isRoot(routeName: String, isRoot: (Boolean) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            collectRouteNamesFromChannels { finalRouteStack ->
                isRoot(routeName == finalRouteStack.firstOrNull())
            }
        }
    }

    @JvmStatic
    fun rootRouteName(rootName: (String?) -> Unit) {
        val activityInfoStack: List<ActivityInfo> = ActivityInjector.activityInfoStack
        if (activityInfoStack.isEmpty()) {
            rootName(null)
        }
        val last: ActivityInfo = activityInfoStack.last()
        if (last.channelProvider != null) {
            val provider = last.channelProvider!!
            val channel = provider.navigatorChannel
            CoroutineScope(Dispatchers.Main).launch {
                val routeStack: List<String>? =
                    callMethodSynchronously(channel, "routeNameStack") as? List<String>
                rootName(routeStack?.lastOrNull())
            }
        }else{
            rootName(last.routeName)
        }
    }

    @JvmStatic
    fun topRouteName(name: (String?) -> Unit) {
        val activityInfoStack: List<ActivityInfo> = ActivityInjector.activityInfoStack
        if (activityInfoStack.isEmpty()) {
            name(null)
        }
        val last: ActivityInfo = activityInfoStack.first()
        if (last.channelProvider == null) {
            name(last.routeName)
        } else {
            val provider = last.channelProvider!!
            val channel = provider.navigatorChannel
            CoroutineScope(Dispatchers.Main).launch {
                val routeStack: List<String>? =
                    callMethodSynchronously(channel, "routeNameStack") as? List<String>
                name(routeStack?.lastOrNull())
            }
        }
    }

    @JvmStatic
    fun routeNameStack(stack: (List<String>) -> Unit) {
        CoroutineScope(Dispatchers.Main).launch {
            collectRouteNamesFromChannels { finalRouteStack ->
                Log.i(TAG, "当前路由栈：------>$finalRouteStack")
                stack(finalRouteStack)
            }
        }
    }

    @JvmStatic
    fun topRouteIsNative(isNative: (Boolean) -> Unit) {
        val activityInfoStack: List<ActivityInfo> = ActivityInjector.activityInfoStack
        isNative(activityInfoStack.firstOrNull()?.channelProvider == null)
    }

    @JvmStatic
    fun handleCallback(options: BaseOptions, response: Any?) {
        options.callBack?.invoke(response)
    }

    /**
     * 遍历路由栈
     */
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

    /**
     * 出栈到最靠前的某个相同路由
     */
    private suspend fun handlePopUntilFirst(routeName: String) {
        val activityInfoStack = ActivityInjector.activityInfoStack.reversed()
        var firstInfo: ActivityInfo? = null

        if (activityInfoStack.isEmpty()) {
            return
        }

        for (activityInfo in activityInfoStack) {
            val provider = activityInfo.channelProvider
            if (provider != null) {
                val channel = provider.navigatorChannel
                val routeStack: List<String>? =
                    callMethodSynchronously(channel, "routeNameStack") as? List<String>
                Log.e(TAG,"popUntil-search:----> $routeStack")
                if (!routeStack.isNullOrEmpty()) {
                    if (routeStack.contains(routeName)) {
                        firstInfo = activityInfo
                        return
                    }
                }
            } else {
                if (routeName == activityInfo.routeName) {
                    firstInfo = activityInfo
                    return
                }
            }
        }
        if(firstInfo != null){
            val index = ActivityInjector.activityInfoStack.indexOf(firstInfo)

            val elementsAfterFirstInfo = ActivityInjector.activityInfoStack.subList(index + 1, activityInfoStack.size)

            for (info in elementsAfterFirstInfo) {
                ActivityInjector.remove(info.avtivity.get()!!)
            }
            val provider = firstInfo.channelProvider
            if(provider != null){
                val channel = provider.navigatorChannel
                channel.invokeMethod("popUntil", mutableMapOf<String, Any>("routeName" to routeName))
            }
        }
    }

    /**
     * 出栈到指定路由
     */
    private suspend fun handlePopUntil(routeName: String) {
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
                Log.e(TAG,"popUntil-search:----> $routeStack")
                if (!routeStack.isNullOrEmpty()) {
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

    /**
     * 同步调用channel
     */
    private suspend fun callMethodSynchronously(channel: MethodChannel, method: String): Any? =
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
