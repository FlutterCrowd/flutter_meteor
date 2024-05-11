package cn.itbox.hz_router_plugin.core

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode
import org.json.JSONObject

data class FlutterRouterRouteOptions(
    val backgroundMode: BackgroundMode,
//    val activityClass: Class<out FlutterRouterActivity>?,
    val routeName: String,
    val arguments: Map<String, Any>?,
    val requestCode: Int,
) {

    val isTransparent get() = backgroundMode == BackgroundMode.transparent

    fun toBundle(): Bundle {
        val bundle = Bundle()
        bundle.putString("backgroundMode", backgroundMode.name)
        bundle.putString("routeName", routeName)
        val routeArgs = mapOf("routeName" to routeName, "routeArguments" to arguments)
        bundle.putString("routeArgs", JSONObject(routeArgs).toString())
        return bundle
    }

    class Builder {
        private var backgroundMode: BackgroundMode = BackgroundMode.opaque
//        private var activityClass: Class<out FlutterRouterActivity>? = null
        private var routeName: String? = null
        private var arguments: Map<String, Any>? = null
        private var requestCode: Int = 0

        fun backgroundMode(backgroundMode: BackgroundMode): Builder {
            this.backgroundMode = backgroundMode
            return this
        }

//        fun activityClass(activityClass: Class<out FlutterRouterActivity>): Builder {
//            this.activityClass = activityClass
//            return this
//        }

        fun routeName(routeName: String): Builder {
            this.routeName = routeName
            return this
        }

        fun arguments(arguments: Map<String, Any>): Builder {
            this.arguments = arguments
            return this
        }

        fun requestCode(requestCode: Int): Builder {
            this.requestCode = requestCode
            return this
        }

        fun build(): FlutterRouterRouteOptions {
            val routeName = routeName
            if (routeName.isNullOrEmpty()) {
                throw IllegalArgumentException("pageName can not be null.")
            }

            return FlutterRouterRouteOptions(backgroundMode, routeName, arguments, requestCode)
        }
    }
}