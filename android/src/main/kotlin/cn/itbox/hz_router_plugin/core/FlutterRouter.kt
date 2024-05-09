package cn.itbox.hz_router_plugin.core

import android.app.Activity
import android.content.Intent

object FlutterRouter {

    private var _delegate: FlutterRouterDelegate? = null

    internal val delegate get() = _delegate

    fun init(delegate: FlutterRouterDelegate) {
        this._delegate = delegate
    }

    fun open(activity: Activity, options: FlutterRouterRouteOptions) {
        val activityClass = options.activityClass ?: FlutterRouterActivity::class.java
        val intent = Intent(activity, activityClass)
        intent.putExtra("routeName", options.routeName)
        intent.putExtra("arguments", options.arguments)
        activity.startActivityForResult(intent, options.requestCode)
    }


}