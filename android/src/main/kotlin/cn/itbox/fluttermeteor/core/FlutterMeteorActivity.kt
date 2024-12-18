package cn.itbox.fluttermeteor.core

import android.content.Context
import android.graphics.Color
import cn.itbox.fluttermeteor.engine.EngineBindings
import cn.itbox.fluttermeteor.engine.EngineInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.FlutterEngine
import org.json.JSONObject

open class FlutterMeteorActivity : FlutterActivity() {

    private val engineBindings by lazy {
        val initialRoute = intent.getStringExtra("initialRoute")
        val entryPoint = intent.getStringExtra("entryPoint") ?: "main"
        val routeArgsString = intent.getStringExtra("routeArgs")
        var routeArgs: String? = null
        if (routeArgsString != null) {
            // 解析 JSON 字符串为 JSONObject
            val jsonObject = JSONObject(routeArgsString)
            jsonObject.put("isMain", isMainEntry)
            routeArgs = jsonObject.toString()
        } else {
            val map = mapOf(
                "isMain" to isMainEntry
            )
            val jsonObject = JSONObject(map)
            routeArgs = jsonObject.toString()
        }
        val args = if (routeArgs.isNullOrEmpty()) emptyList() else listOf(routeArgs)
        EngineBindings(this,  initialRoute, entryPoint, args, 0)
    }
    private val isMainEntry: Boolean get() {
        val routeArgs = intent.getStringExtra("routeArgs")
        return routeArgs.isNullOrEmpty()
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

    override fun onResume() {
        super.onResume()
        val message = mapOf(
            "event" to "onContainerVisible"
        )
        val channelProvider = ActivityInjector.channelProvider(this.hashCode())
        channelProvider?.observerChannel?.send(message)
    }

    override fun onPause() {
        super.onPause()
        val message = mapOf(
            "event" to "onContainerInvisible"
        )
        val channelProvider = ActivityInjector.channelProvider(this.hashCode())
        channelProvider?.observerChannel?.send(message)
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