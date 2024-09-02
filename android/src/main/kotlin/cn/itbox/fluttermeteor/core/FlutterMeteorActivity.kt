package cn.itbox.fluttermeteor.core

import android.content.Context
import android.graphics.Color
import cn.itbox.fluttermeteor.engine.EngineBindings
import cn.itbox.fluttermeteor.engine.EngineInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine

open class FlutterMeteorActivity : FlutterActivity() {

    private val engineBindings by lazy {
        val initialRoute = intent.getStringExtra("initialRoute")
        val entryPoint = intent.getStringExtra("entryPoint") ?: "main"
        val routeArgs = intent.getStringExtra("routeArgs")
        val args = if (routeArgs.isNullOrEmpty()) null else listOf(routeArgs)
        EngineBindings(this,  initialRoute, entryPoint, args, 0)
    }

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        engineBindings.attach()
//        val backgroundMode = intent.getStringExtra("backgroundMode")
        println("backgroundMode: $backgroundMode")
        if (backgroundMode == FlutterActivityLaunchConfigs.BackgroundMode.transparent) {
            window.statusBarColor = Color.TRANSPARENT
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        val channelProvider = EngineInjector.getChannelProvider(flutterEngine)
        ActivityInjector.attachChannel(this.hashCode(), channelProvider)

        println("开始关联channel------>${this.hashCode()}")
        super.configureFlutterEngine(flutterEngine)
    }


    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        println("engineBindings.engine: ${engineBindings.engine}")
        return engineBindings.engine
    }

    override fun onDestroy() {
        super.onDestroy()
        engineBindings.detach()
    }
}