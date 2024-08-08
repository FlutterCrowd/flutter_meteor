package cn.itbox.fluttermeteor.router

import android.app.Activity
import android.content.Intent


typealias FMRouterBuilder = (arguments: Map<String, Any>?) -> Intent
typealias FMRouterSearchBlock = (activity: Activity?) -> Unit
object FlutterMeteorRouteManager {

    private val routes = mutableMapOf<String, FMRouterBuilder>()

    fun insertRouter(routeName: String, routerBuilder: FMRouterBuilder) {
        routes[routeName] = routerBuilder
    }

    fun routerBuilder(routeName: String): FMRouterBuilder? {
        return routes[routeName]
    }

    fun createActivity(routeName: String?, arguments: Map<String, Any>?) : Intent? {
        if (routeName == null) {
            return null
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
        return  intent
    }
}
