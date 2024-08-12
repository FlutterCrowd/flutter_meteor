package cn.itbox.fluttermeteor

import android.os.Build
import androidx.annotation.RequiresApi

import cn.itbox.fluttermeteor.engine.EngineInjector
import cn.itbox.fluttermeteor.event_bus.FlutterMeteorEventBus
import cn.itbox.fluttermeteor.navigator.NavigatorMethodHandler

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding


/** HzRouterPlugin */
class FlutterMeteorPlugin : FlutterPlugin, ActivityAware {

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
//    private lateinit var channel: MethodChannel
//
//    private var activity: Activity? = null
    private  val flutterMeteorNavigator: NavigatorMethodHandler = NavigatorMethodHandler()
//    private  val flutterMeteorRouter: FlutterMeteorRouter = FlutterMeteorRouter()


    @RequiresApi(Build.VERSION_CODES.N)
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
//        channel = MethodChannel(
//            flutterPluginBinding.binaryMessenger,
//            "itbox.meteor.navigatorChannel"
//        )
//        channel.setMethodCallHandler(this)
//        println("开始注册插件")
//        EngineInjector.put(flutterPluginBinding.flutterEngine, channel)

        val provider = FlutterMeteorChannelProvider(flutterPluginBinding.binaryMessenger)
        provider.navigatorChannel.setMethodCallHandler(flutterMeteorNavigator)
        provider.eventBusChannel.setMessageHandler { message, reply ->
            println("Received message from Flutter: $message")
            FlutterMeteorEventBus.receiveMessageFromFlutter(message)
            reply.reply("Android received your message: $message")
        }
        EngineInjector.put(flutterPluginBinding.flutterEngine, provider)
    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        EngineInjector.remove(binding.flutterEngine)
//        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        flutterMeteorNavigator.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        flutterMeteorNavigator.activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        flutterMeteorNavigator.activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        flutterMeteorNavigator.activity = null
    }

}

