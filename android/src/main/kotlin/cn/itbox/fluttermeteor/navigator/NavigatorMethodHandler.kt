package cn.itbox.fluttermeteor.navigator

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class NavigatorMethodHandler : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        println("onMethodCall: ${call.method}")
        when (call.method) {
            "pushNamed" -> handlePushNamed(call, result)
            "pop" -> handlePop(call, result)
            "popUntil" -> {
                val routeName = call.argument<String>("routeName")
                handlePopUntil(routeName)
            }
            "popToRoot" -> handlePopToRoot(result)
            "pushReplacementNamed" -> pushReplacementNamed(call, result)
            "pushNamedAndRemoveUntil" -> pushNamedAndRemoveUntil(call, result)
            "pushNamedAndRemoveUntilRoot" -> pushNamedAndRemoveUntilRoot(call, result)
            //--------------------路由相关方法---------------------
            "rootRouteName" -> rootRouteName(result)
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
            "topRouteName" -> topRouteName(result)
            "routeNameStack" -> routeNameStack(result)
            "topRouteIsNative" -> topRouteIsNative(result)
            else -> result.notImplemented()
        }
    }

    /**
     * push新页面
     */
    private fun handlePushNamed(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments
        if (arguments is Map<*, *>) {
            val pageTypeInt = arguments["pageType"] as? Int ?: 1
            val isOpaque = arguments["isOpaque"] == true
            val routeName = arguments["routeName"]?.toString() ?: ""
            val routeArguments = arguments["arguments"]
            val option = MeteorPushOptions(
                pageType = MeteorPageType.fromType(pageTypeInt),
                isOpaque = isOpaque,
                arguments = routeArguments,
            )
            option.callBack = object : FlutterMeteorRouterCallBack {
                override fun invoke(response: Any?) {
                    result.success(response)
                }
            }
            FlutterMeteorNavigator.push(
                routeName, option
            )
        }
    }

    /**
     * 退出当前activity
     */
    private fun handlePop(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments
        if (arguments is Map<*, *>) {
            val routeArguments = arguments["arguments"]
            val option = MeteorPopOptions(
                arguments = routeArguments,
            )
            option.callBack = object : FlutterMeteorRouterCallBack {
                override fun invoke(response: Any?) {
                    result.success(response)
                }
            }
            FlutterMeteorNavigator.pop(option)
        }else{
            FlutterMeteorNavigator.pop(null)
        }
    }

    /**
     * 回退到指定路由
     */
    private fun handlePopUntil(routeName: String?) {
        if (routeName != null) {
            FlutterMeteorNavigator.popUntil(routeName)
        }
    }

    /**
     * 回退到根路由
     */
    private fun handlePopToRoot(result: MethodChannel.Result) {
        result.success(true).also { FlutterMeteorNavigator.popToRoot() }
    }

    /**
     * 移除栈顶路由并push新页面
     */
    private fun pushReplacementNamed(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments
        if (arguments is Map<*, *>) {
            val pageTypeInt = arguments["pageType"] as? Int ?: 1
            val isOpaque = arguments["isOpaque"] == true
            val routeName = arguments["routeName"]?.toString() ?: ""
            val routeArguments = arguments["arguments"]
            val option = MeteorPushOptions(
                pageType = MeteorPageType.fromType(pageTypeInt),
                isOpaque = isOpaque,
                arguments = routeArguments,
            )
            option.callBack = object : FlutterMeteorRouterCallBack {
                override fun invoke(response: Any?) {
                    result.success(response)
                }
            }
            FlutterMeteorNavigator.pushToReplacement(
                routeName, option
            )
        }
    }

    /**
     * 回退到根路由然后push页面
     */
    private fun pushNamedAndRemoveUntilRoot(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments
        if (arguments is Map<*, *>) {
            val pageTypeInt = arguments["pageType"] as? Int ?: 1
            val isOpaque = arguments["isOpaque"] == true
            val routeName = arguments["routeName"]?.toString() ?: ""
            val routeArguments = arguments["arguments"]
            val option = MeteorPushOptions(
                pageType = MeteorPageType.fromType(pageTypeInt),
                isOpaque = isOpaque,
                arguments = routeArguments,
            )
            option.callBack = object : FlutterMeteorRouterCallBack {
                override fun invoke(response: Any?) {
                    result.success(response)
                }
            }
            FlutterMeteorNavigator.pushNamedAndRemoveUntilRoot(routeName,option)
        }
    }

    private fun pushNamedAndRemoveUntil(call: MethodCall, result: MethodChannel.Result) {
        val untilName = call.argument<String>("untilRouteName")
        if (untilName != null) {
            val arguments = call.arguments
            if (arguments is Map<*, *>) {
                val pageTypeInt = arguments["pageType"] as? Int ?: 1
                val isOpaque = arguments["isOpaque"] == true
                val routeName = arguments["routeName"]?.toString() ?: ""
                val routeArguments = arguments["arguments"]
                val option = MeteorPushOptions(
                    pageType = MeteorPageType.fromType(pageTypeInt),
                    isOpaque = isOpaque,
                    arguments = routeArguments,
                )
                option.callBack = object : FlutterMeteorRouterCallBack {
                    override fun invoke(response: Any?) {
                        result.success(response)
                    }
                }
                FlutterMeteorNavigator.pushToAndRemoveUntil(routeName,untilName,option)
            }
        }
    }

    /*------------------------router method start--------------------------*/

    /**
     * 判断路由是否存在
     */
    private fun routeExists(routeName: String, result: MethodChannel.Result) {
        FlutterMeteorNavigator.routeExists(routeName) { exists ->
            result.success(exists)
        }
    }

    /**
     * 判断是否为根路由
     */
    private fun isRoot(routeName: String, result: MethodChannel.Result) {
        FlutterMeteorNavigator.isRoot(routeName) { isRoot ->
            result.success(isRoot)
        }
    }

    /**
     * 获取根路由名称
     */
    private fun rootRouteName(result: MethodChannel.Result) {
        FlutterMeteorNavigator.rootRouteName { rootName ->
            result.success(rootName)
        }
    }

    /**
     * 获取顶部路由名称
     */
    private fun topRouteName(result: MethodChannel.Result) {
        FlutterMeteorNavigator.topRouteName { name ->
            result.success(name)
        }
    }

    /**
     * 获取路由栈
     */
    private fun routeNameStack(result: MethodChannel.Result) {
        FlutterMeteorNavigator.routeNameStack { stack ->
            result.success(stack)
        }
    }

    /**
     * 当前栈顶是否为原生页面
     */
    private fun topRouteIsNative(result: MethodChannel.Result) {
        FlutterMeteorNavigator.topRouteIsNative { isNative ->
            result.success(isNative)
        }
    }

}

