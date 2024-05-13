package cn.itbox.fluttermeteor.core

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivityLaunchConfigs.BackgroundMode
import org.json.JSONObject

data class FlutterMeteorRouteOptions(
    val backgroundMode: BackgroundMode,
    val initialRoute: String,
    val arguments: Map<String, Any>?,
    val requestCode: Int,
) {

    val isTransparent get() = backgroundMode == BackgroundMode.transparent

    fun toBundle(): Bundle {
        val bundle = Bundle()
        bundle.putString("background_mode", backgroundMode.name)
        bundle.putString("initialRoute", initialRoute)
        val routeArgs = mapOf("initialRoute" to initialRoute, "routeArguments" to arguments)
        bundle.putString("routeArgs", JSONObject(routeArgs).toString())
        return bundle
    }

    class Builder {
        private var backgroundMode: BackgroundMode = BackgroundMode.opaque
        private var initialRoute: String? = null
        private var arguments: Map<String, Any>? = null
        private var requestCode: Int = 0

        fun backgroundMode(backgroundMode: BackgroundMode): Builder {
            this.backgroundMode = backgroundMode
            return this
        }

        fun initialRoute(initialRoute: String): Builder {
            this.initialRoute = initialRoute
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

        fun build(): FlutterMeteorRouteOptions {
            val initialRoute = initialRoute
            if (initialRoute.isNullOrEmpty()) {
                throw IllegalArgumentException("pageName can not be null.")
            }

            return FlutterMeteorRouteOptions(backgroundMode, initialRoute, arguments, requestCode)
        }
    }
}