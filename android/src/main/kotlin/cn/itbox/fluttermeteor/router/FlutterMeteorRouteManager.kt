import android.app.Activity
import android.content.Intent
import java.lang.IllegalArgumentException

// Typealias for a function that takes optional arguments and returns an Intent
typealias FMRouterBuilder = (arguments: Map<String, Any>?) -> Intent

object FlutterMeteorRouteManager {

    private val routes = mutableMapOf<String, FMRouterBuilder>()

    // Method to register a route
    fun insertRouter(routeName: String, routerBuilder: FMRouterBuilder) {
        routes[routeName] = routerBuilder
    }

    // Method to get the router builder for a specific route
    fun routerBuilder(routeName: String): FMRouterBuilder? {
        return routes[routeName]
    }

    // Method to create an Intent for a given route
    fun createActivityIntent(routeName: String?, arguments: Map<String, Any>?): Intent? {
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
        return intent
    }

    // Extension function to start an activity from the current activity
    fun Activity.startActivity(routeName: String, arguments: Map<String, Any>? = null) {
        val intent = createActivityIntent(routeName, arguments)
        intent?.let { startActivity(it) }
    }
}

// Example usage:

// Register routes