package cn.itbox.fluttermeteor.core

import android.content.Context
import android.graphics.Color
import cn.itbox.fluttermeteor.engine.EngineBindings
import cn.itbox.fluttermeteor.engine.EngineInjector
import cn.itbox.fluttermeteor.core.ActivityInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine

open class FlutterMeteorActivity : FlutterActivity() {

    private val engineBindings by lazy {
        val initialRoute = intent.getStringExtra("initialRoute")
        val routeArgs = intent.getStringExtra("routeArgs")
        val isMainEntry = isMainEntry
        val entryPoint = if (isMainEntry) "main" else "childEntry"
        val theArgs = if (isMainEntry) null else listOf(routeArgs)
        EngineBindings(this,  initialRoute, entryPoint, theArgs, 0)
    }

    val isMainEntry: Boolean get() {
        val routeArgs = intent.getStringExtra("routeArgs")
        return routeArgs.isNullOrEmpty()
    }

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        engineBindings.attach()
        if (isMainEntry) {
            println("是主引擎")
            EngineInjector.setMainEngine(engineBindings.engine)
        }

//        val backgroundMode = intent.getStringExtra("backgroundMode")
        println("backgroundMode: $backgroundMode")
        if (backgroundMode == FlutterActivityLaunchConfigs.BackgroundMode.transparent) {
            window.statusBarColor = Color.TRANSPARENT
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        val channel = EngineInjector.getChannel(flutterEngine)
        if(channel != null){
            ActivityInjector.attachChannel(this.hashCode(),channel)
        }
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