package cn.itbox.fluttermeteor.router

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import androidx.fragment.app.Fragment

typealias FMRouterBuilder = (arguments: Map<String, Any>?) -> Intent
typealias FMRouterSearchBlock = (activity: Activity?) -> Unit
object FlutterMeteorRouter {

    private val routes = mutableMapOf<String, FMRouterBuilder>()

    fun insertRouter(routeName: String, routerBuilder: FMRouterBuilder) {
        routes[routeName] = routerBuilder
    }

    fun routerBuilder(routeName: String): FMRouterBuilder? {
        return routes[routeName]
    }

    fun startActivity(routeName: String?, arguments: Map<String, Any>?, context: Context) {
        if (routeName == null) {
            return
        }
        val intentBuilder: FMRouterBuilder? = routes[routeName]
        val intent: Intent? = intentBuilder?.invoke(arguments)
        intent?.putExtra("routeName", routeName)
        arguments?.forEach { (key, value) ->
            when (value) {
                is Int -> intent?.putExtra(key, value)
                is Long -> intent?.putExtra(key, value)
                is Float -> intent?.putExtra(key, value)
                is Double -> intent?.putExtra(key, value)
                is String -> intent?.putExtra(key, value)
                is Boolean -> intent?.putExtra(key, value)
                is ArrayList<*> -> intent?.putExtra(key, value)
                is HashMap<*, *> -> intent?.putExtra(key, value)
                else -> throw IllegalArgumentException("Unsupported argument type for key $key")
            }
        }
        context.startActivity(intent)
    }
}

object FlutterMeteorRouteManager {

    private val routes = mutableMapOf<String, FMRouterBuilder>()

    fun insertRouter(routeName: String, routerBuilder: FMRouterBuilder) {
        routes[routeName] = routerBuilder
    }

    fun routerBuilder(routeName: String): FMRouterBuilder? {
        return routes[routeName]
    }

    fun fragment(routeName: String?, arguments: Map<String, Any>?): Fragment? {
        if (routeName == null) {
            return null
        }
        val fragmentBuilder: FMRouterBuilder? = routes[routeName]
        val fragment: Fragment? = fragmentBuilder?.invoke(arguments)
        fragment?.arguments = Bundle().apply {
            putString("routeName", routeName)
            arguments?.forEach { (key, value) ->
                when (value) {
                    is Int -> putInt(key, value)
                    is Long -> putLong(key, value)
                    is Float -> putFloat(key, value)
                    is Double -> putDouble(key, value)
                    is String -> putString(key, value)
                    is Boolean -> putBoolean(key, value)
                    else -> throw IllegalArgumentException("Unsupported argument type for key $key")
                }
            }
        }
        return fragment
    }
}
