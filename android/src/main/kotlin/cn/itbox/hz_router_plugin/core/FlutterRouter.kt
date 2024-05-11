package cn.itbox.hz_router_plugin.core

import android.app.Activity
import android.app.Application
import android.content.Intent
import cn.itbox.hz_router_plugin.engine.EngineInjector

object FlutterRouter {

    private var _delegate: FlutterRouterDelegate? = null

    internal val delegate get() = _delegate

    fun init(application: Application, delegate: FlutterRouterDelegate) {
        this._delegate = delegate
        ActivityInjector.inject(application)
    }

    fun open(activity: Activity, options: FlutterRouterRouteOptions) {
        if (_delegate == null) {
            throw IllegalStateException("delegate is null")
        }
        _delegate?.onPushFlutterPage(activity, options)
    }

    fun popToRoot() {
        ActivityInjector.finishToRoot()
        EngineInjector.getMainChannel()?.invokeMethod("popToRoot", null)
    }

}