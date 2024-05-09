package cn.itbox.hz_router_plugin.core

interface FlutterRouterDelegate {

    fun onPushNativePage(routeName: String, arguments: Any?)
}