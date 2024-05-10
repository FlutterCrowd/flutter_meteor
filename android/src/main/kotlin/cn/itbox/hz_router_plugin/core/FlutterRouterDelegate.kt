package cn.itbox.hz_router_plugin.core

import android.app.Activity

interface FlutterRouterDelegate {

    fun onPushNativePage(routeName: String, arguments: Any?)

    fun onPushFlutterPage(activity: Activity, options: FlutterRouterRouteOptions)
}