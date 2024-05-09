package cn.itbox.hz_router_plugin.core

import android.content.Context
import cn.itbox.hz_router_plugin.engine.EngineBindings
import cn.itbox.hz_router_plugin.engine.EngineInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

open class FlutterRouterActivity : FlutterActivity() {

    private val engineBindings by lazy {
        val routeName = intent.getStringExtra("routeName")
        val arguments = intent.getStringExtra("arguments") ?: ""
        val isMainEntry = isMainEntry
        val entryPoint = if (isMainEntry) "main" else "childEntry"
        val theArgs = if (isMainEntry) null else listOf(arguments)
        EngineBindings(this,  routeName, entryPoint, theArgs, 0)
    }

    val isMainEntry: Boolean get() {
        val routeName = intent.getStringExtra("routeName")
        return routeName.isNullOrEmpty()
    }

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        engineBindings.attach()
        if (isMainEntry) {
            EngineInjector.setMainEngine(engineBindings.engine)
        }
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return engineBindings.engine
    }

    override fun onDestroy() {
        super.onDestroy()
        engineBindings.detach()
    }
}