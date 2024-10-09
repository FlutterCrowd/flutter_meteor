package cn.itbox.hz_router_plugin_example

import android.app.Activity
import android.app.ActivityOptions
import android.content.Intent
import android.os.Bundle
import cn.itbox.fluttermeteor.core.FlutterMeteor
import cn.itbox.fluttermeteor.core.FlutterMeteorDelegate
import cn.itbox.fluttermeteor.core.FlutterMeteorRouteOptions
import io.flutter.app.FlutterApplication

/**
 * Author: 冯祖焱
 * Date: 2024/5/9 23:15
 * Description:
 **/
class App : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()

        registerRouter()

        FlutterMeteor.init(this, object : FlutterMeteorDelegate {
            override fun onPushNativePage(routeName: String, arguments: Any?) {

                if (FlutterMeteorRouteManager.routerBuilder(routeName) != null) {
                    val  intent = FlutterMeteorRouteManager.createActivityIntent(routeName, arguments as Map<String, Any>?)
                    startActivity(intent)
                    return
                }

                val intent = Intent(applicationContext, NativeActivity::class.java)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                intent.putExtra("routeName",routeName)
                startActivity(intent)
            }

            override fun onPushFlutterPage(activity: Activity, options: FlutterMeteorRouteOptions) {
                val activityClass = if (options.isTransparent) TransparentActivity::class.java else MainActivity::class.java
                val intent = Intent(activity, activityClass)
                intent.putExtras(options.toBundle())
                activity.startActivityForResult(intent, options.requestCode)
                if (options.isTransparent) {
                    activity.overridePendingTransition(0, 0)
                }
            }
        })
    }

    private fun registerRouter() {
        FlutterMeteorRouteManager.insertRouter("test") { arguments ->
            val intent = Intent(applicationContext, ExampleActivity::class.java).apply {
                putExtra("EXTRA_MESSAGE", "Hello, SecondActivity!")
                putExtra("EXTRA_NUMBER", 123)
            }
            arguments?.forEach { (key, value) ->
                when (value) {
                    is Int -> intent.putExtra(key, value)
                    is Long -> intent.putExtra(key, value)
                    is Float -> intent.putExtra(key, value)
                    is Double -> intent.putExtra(key, value)
                    is String -> intent.putExtra(key, value)
                    is Boolean -> intent.putExtra(key, value)
                    is ArrayList<*> -> intent.putExtra(key, value)
                    is HashMap<*, *> -> intent.putExtra(key, value)
                    else -> throw IllegalArgumentException("Unsupported argument type for key $key")
                }
            }
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            intent
        }

        FlutterMeteorRouteManager.insertRouter("second") { arguments ->
            val intent = Intent(applicationContext, SecondActivity::class.java).apply {
                putExtra("EXTRA_MESSAGE", "Hello, SecondActivity!")
                putExtra("EXTRA_NUMBER", 123)
            }
            arguments?.forEach { (key, value) ->
                when (value) {
                    is Int -> intent.putExtra(key, value)
                    is Long -> intent.putExtra(key, value)
                    is Float -> intent.putExtra(key, value)
                    is Double -> intent.putExtra(key, value)
                    is String -> intent.putExtra(key, value)
                    is Boolean -> intent.putExtra(key, value)
                    is ArrayList<*> -> intent.putExtra(key, value)
                    is HashMap<*, *> -> intent.putExtra(key, value)
                    else -> throw IllegalArgumentException("Unsupported argument type for key $key")
                }
            }
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            intent
        }

        FlutterMeteorRouteManager.insertRouter("push_native") { arguments ->
            val intent = Intent(applicationContext, NativeActivity::class.java)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            // Set up additional intent extras based on arguments
            arguments?.forEach { (key, value) ->
                when (value) {
                    is Int -> intent.putExtra(key, value)
                    is Long -> intent.putExtra(key, value)
                    is Float -> intent.putExtra(key, value)
                    is Double -> intent.putExtra(key, value)
                    is String -> intent.putExtra(key, value)
                    is Boolean -> intent.putExtra(key, value)
                    is ArrayList<*> -> intent.putExtra(key, value)
                    is HashMap<*, *> -> intent.putExtra(key, value)
                    else -> throw IllegalArgumentException("Unsupported argument type for key $key")
                }
            }
            intent
        }

    }

}