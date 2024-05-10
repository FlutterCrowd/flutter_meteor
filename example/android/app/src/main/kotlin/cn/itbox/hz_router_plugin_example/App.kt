package cn.itbox.hz_router_plugin_example

import android.content.Intent
import cn.itbox.hz_router_plugin.core.FlutterRouter
import cn.itbox.hz_router_plugin.core.FlutterRouterDelegate
import io.flutter.app.FlutterApplication

/**
 * Author: 冯祖焱
 * Date: 2024/5/9 23:15
 * Description:
 **/
class App : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        FlutterRouter.init( object : FlutterRouterDelegate {
            override fun onPushNativePage(routeName: String, arguments: Any?) {
                println("routeName: $routeName, arguments: $arguments")
                val intent = Intent(applicationContext, NativeActivity::class.java)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
            }
        })
    }


}