package cn.itbox.fluttermeteor.router

import android.util.Log
import cn.itbox.fluttermeteor.core.ActivityInjector
import cn.itbox.fluttermeteor.engine.EngineInjector
import cn.itbox.fluttermeteor.FlutterMeteorChannelProvider
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.atomic.AtomicInteger


class  FlutterMeteorRouter: MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        println("onMethodCall: ${call.method}")
        when (call.method) {
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
            else -> result.notImplemented()
        }
    }

    companion object {
        fun routeExists(routeName: String, result: MethodChannel.Result) {

            collectRouteNamesFromChannels { finalRouteStack ->
                result.success(finalRouteStack.contains(routeName))
            }
        }

        fun isRoot(routeName: String, result: MethodChannel.Result) {
            collectRouteNamesFromChannels { finalRouteStack ->
                result.success(routeName == finalRouteStack.firstOrNull())
            }
        }

        fun rootRouteName(result: MethodChannel.Result) {
            val provider: FlutterMeteorChannelProvider? = EngineInjector.firstChannelProvider()
            val routerChannel = provider?.routerChannel
            if(routerChannel != null) {
                handleSingleChannelResult(routerChannel, "routeNameStack") { routeStack ->
                    result.success(routeStack.firstOrNull() ?: "")
                }
            } else {
                result.error("FlutterMeteor","routerChannel is null","")
            }
        }

        fun topRouteName(result: MethodChannel.Result) {
            val provider = EngineInjector.lastChannelProvider()
            val routerChannel = provider?.routerChannel
            if (routerChannel != null) {
                handleSingleChannelResult(routerChannel, "routeNameStack") { routeStack ->
                    val activityRouteName = ActivityInjector.lastActivityRouteName
                    result.success(
                        when {
                            routeStack.isEmpty() -> null
                            activityRouteName != null && activityRouteName.isNotEmpty() && !routeStack.contains(activityRouteName) -> activityRouteName
                            else -> routeStack.last()
                        }
                    )
                }
            } else {
                result.error("FlutterMeteor","routerChannel is null","")
            }

        }

        fun routeNameStack(result: MethodChannel.Result) {
            collectRouteNamesFromChannels { finalRouteStack ->
                Log.e("FlutterMeteor", "collectRouteNamesFromChannels------$finalRouteStack")
                result.success(finalRouteStack)
            }
        }

        fun topRouteIsNative(result: MethodChannel.Result) {
            val provider = EngineInjector.firstChannelProvider()
            if (provider != null) {
                handleSingleChannelResult(provider.routerChannel, "routeNameStack") { routeStack ->
                    val activityRouteName = ActivityInjector.lastActivityRouteName
                    result.success(
                        if (routeStack.isNotEmpty() && activityRouteName != null && activityRouteName.isNotEmpty() && !routeStack.contains(activityRouteName)) {
                            true
                        } else {
                            false
                        }
                    )
                }
            } else {
                result.error("provider", "activityRouteName is null", "")

            }
        }

        private fun handleSingleChannelResult(channel: MethodChannel, method: String, callback: (List<String>) -> Unit) {
            channel.invokeMethod(method, null, object : MethodChannel.Result {
                override fun success(result: Any?) {
                    val routeStack = result as? List<String> ?: emptyList()
                    callback(routeStack)
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    callback(emptyList())
                }

                override fun notImplemented() {
                    callback(emptyList())
                }
            })
        }

        private fun collectRouteNamesFromChannels(result: (List<String>) -> Unit) {
            val activityInfoStack = ActivityInjector.activityInfoStack
            val routeNameStack = mutableListOf<Triple<Int, Int, String>>()
            val remainingCalls = AtomicInteger(activityInfoStack.size)

            if (activityInfoStack.isEmpty()) {
                result(emptyList())
                return
            }

            activityInfoStack.forEachIndexed { outerIndex, activityInfo ->
                val provider = activityInfo.channelProvider
                if (provider != null) {
                    val channel = provider.routerChannel
                    if (channel != null) {
                        channel.invokeMethod("routeNameStack", null, object : MethodChannel.Result {
                            override fun success(p0: Any?) {
                                processRouteStack(p0, routeNameStack, outerIndex, remainingCalls, result)
                            }

                            override fun error(p0: String, p1: String?, p2: Any?) {
                                processRouteStack(emptyList<String>(), routeNameStack, outerIndex, remainingCalls, result)
                            }

                            override fun notImplemented() {
                                processRouteStack(emptyList<String>(), routeNameStack, outerIndex, remainingCalls, result)
                            }
                        })
                    } else {
                        synchronized(routeNameStack) {
                            routeNameStack.add(Triple(outerIndex, 0, activityInfo.routeName))
                        }
                        if (remainingCalls.decrementAndGet() == 0) {
                            finalizeRouteStack(routeNameStack, result)
                        }
                    }
                } else {

                }
            }
        }

        private fun processRouteStack(
            routeStack: Any?,
            routeNameStack: MutableList<Triple<Int, Int, String>>,
            outerIndex: Int,
            remainingCalls: AtomicInteger,
            result: (List<String>) -> Unit
        ) {
            val routes = routeStack as? List<String> ?: emptyList()
            synchronized(routeNameStack) {
                routes.reversed().forEachIndexed { innerIndex, routeName ->
                    routeNameStack.add(Triple(outerIndex, innerIndex, routeName))
                }
            }
            if (remainingCalls.decrementAndGet() == 0) {
                finalizeRouteStack(routeNameStack, result)
            }
        }

        private fun finalizeRouteStack(routeNameStack: List<Triple<Int, Int, String>>, result: (List<String>) -> Unit) {
            val sortedRouteNames = routeNameStack
                .sortedWith(compareBy({ it.first }, { it.second }))
                .map { it.third }
            result(sortedRouteNames.reversed())
        }
    }

}

