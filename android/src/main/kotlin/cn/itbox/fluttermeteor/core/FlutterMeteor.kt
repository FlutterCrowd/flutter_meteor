package cn.itbox.fluttermeteor.core

import android.app.Activity
import android.app.Application
import cn.itbox.fluttermeteor.engine.EngineInjector

object FlutterMeteor {

    private var _delegate: FlutterMeteorDelegate? = null

    internal val delegate get() = _delegate

    fun init(application: Application, delegate: FlutterMeteorDelegate) {
        _delegate = delegate
        ActivityInjector.inject(application)
    }

    fun open(activity: Activity, options: FlutterMeteorRouteOptions) {
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