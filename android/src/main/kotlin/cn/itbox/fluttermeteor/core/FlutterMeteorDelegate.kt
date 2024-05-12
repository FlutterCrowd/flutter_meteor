package cn.itbox.fluttermeteor.core

import android.app.Activity

interface FlutterMeteorDelegate {

    fun onPushNativePage(routeName: String, arguments: Any?)

    fun onPushFlutterPage(activity: Activity, options: FlutterMeteorRouteOptions)
}