package cn.itbox.hz_router_plugin.core

import android.content.Context
import cn.itbox.hz_router_plugin.engine.EngineBindings
import cn.itbox.hz_router_plugin.engine.EngineInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

open class FlutterRouterActivity : FlutterActivity() {

    private val engineBindings by lazy {
        val routeName = intent.getStringExtra("routeName")
        val routeArgs = intent.getStringExtra("routeArgs")
        val isMainEntry = isMainEntry
        val entryPoint = if (isMainEntry) "main" else "childEntry"
        val theArgs = if (isMainEntry) null else listOf(routeArgs)
        EngineBindings(this,  routeName, entryPoint, theArgs, 0)
    }

    val isMainEntry: Boolean get() {
        val routeName = intent.getStringExtra("routeArgs")
        return routeName.isNullOrEmpty()
    }

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        engineBindings.attach()
        if (isMainEntry) {
            EngineInjector.setMainEngine(engineBindings.engine)
        }

//        val backgroundMode = intent.getStringExtra("backgroundMode")
//        println("backgroundMode: $backgroundMode")
//        if (backgroundMode == FlutterActivityLaunchConfigs.BackgroundMode.transparent.name) {
//            window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
//        }
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return engineBindings.engine
    }

    override fun onDestroy() {
        super.onDestroy()
        engineBindings.detach()
    }
}