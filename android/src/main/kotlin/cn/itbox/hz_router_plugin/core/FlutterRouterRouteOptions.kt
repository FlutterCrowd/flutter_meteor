package cn.itbox.hz_router_plugin.core

import org.json.JSONObject

data class FlutterRouterRouteOptions(
    val entryPoint: String?,
    val activityClass: Class<out FlutterRouterActivity>?,
    val routeName: String,
    val arguments: String?,
    val requestCode: Int,
) {
    class Builder {
        private var entryPoint: String? = null
        private var activityClass: Class<out FlutterRouterActivity>? = null
        private var routeName: String? = null
        private var arguments: String? = null
        private var requestCode: Int = 0

        fun activityClass(activityClass: Class<out FlutterRouterActivity>): Builder {
            this.activityClass = activityClass
            return this
        }

        fun entryPoint(entryPoint: String): Builder {
            this.entryPoint = entryPoint
            return this
        }

        fun routeName(routeName: String): Builder {
            this.routeName = routeName
            return this
        }

        fun arguments(arguments: Map<String, Any>): Builder {
            val json = JSONObject(arguments).toString()
            this.arguments = json
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
            return FlutterRouterRouteOptions(entryPoint, activityClass, routeName, arguments, requestCode)
        }
    }
}