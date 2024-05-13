package cn.itbox.hz_router_plugin_example

import android.app.Activity
import android.content.Intent
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
        FlutterMeteor.init(this, object : FlutterMeteorDelegate {
            override fun onPushNativePage(routeName: String, arguments: Any?) {
                println("routeName: $routeName, arguments: $arguments")
                val intent = Intent(applicationContext, NativeActivity::class.java)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
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


}