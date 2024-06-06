package cn.itbox.fluttermeteor

import android.app.Activity
import android.content.Intent
import cn.itbox.fluttermeteor.core.FlutterMeteor
import cn.itbox.fluttermeteor.core.FlutterMeteorRouteOptions
import cn.itbox.fluttermeteor.engine.EngineInjector
import io.flutter.embedding.android.FlutterActivityLaunchConfigs
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** HzRouterPlugin */
class FlutterMeteorPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "itbox.meteor.channel"
        )
        channel.setMethodCallHandler(this)
        EngineInjector.put(flutterPluginBinding.flutterEngine, channel)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        println("onMethodCall: ${call.method}")
        when (call.method) {
            "pushNamed" -> {
                val arguments = call.arguments
                if (arguments is Map<*, *>) {
                    val withNewEngine = arguments["withNewEngine"] == true
                    val newEngineOpaque = arguments["newEngineOpaque"] == true
                    val openNative = arguments["openNative"] == true
                    val routeName = arguments["routeName"]?.toString() ?: ""
                    val routeArguments = arguments["arguments"]
                    if (withNewEngine) {
                        val argumentsMap = if (routeArguments is Map<*, *>) routeArguments else null
                        activity?.also { theActivity ->
                            val args = argumentsMap?.filter { it. value != null }
                                ?.map { it.key.toString() to it.value!! }?.toMap()
                            val builder = FlutterMeteorRouteOptions.Builder().initialRoute(routeName)
                            if (args != null) {
                                builder.arguments(args)
                            }
                            builder.backgroundMode(if (newEngineOpaque) FlutterActivityLaunchConfigs.BackgroundMode.opaque else FlutterActivityLaunchConfigs.BackgroundMode.transparent)
                            FlutterMeteor.delegate?.onPushFlutterPage(theActivity, builder.build())
                        }
                    } else if (openNative) {
                        FlutterMeteor.delegate?.onPushNativePage(routeName, routeArguments)
                    }
                }
                result.success(true)
            }
            "pop" -> {
                result.success(true)
                val arguments = call.arguments
                val data = Intent()
                if (arguments is Map<*, *>) {
                    arguments.forEach {
                        val key = it.key.toString()
                        when (val value = it.value) {
                            is Int -> data.putExtra(key, value)
                            is Double -> data.putExtra(key, value)
                            is Boolean -> data.putExtra(key, value)
                            is String -> data.putExtra(key, value)
                            is List<*> -> data.putExtra(key, ArrayList(value))
                            is Map<*, *> -> data.putExtra(key, HashMap(value))
                        }
                    }
                }
                activity?.setResult(if (arguments == null) Activity.RESULT_CANCELED else Activity.RESULT_OK, data)
                activity?.finish()
            }
            "popToRoot" -> {
                result.success(true).also { FlutterMeteor.popToRoot() }
            }
            "cn.itbox.multiEnginEvent" -> { // MeteorEventBus
                EngineInjector.allChannels().forEach {
                    it.invokeMethod(call.method, call.arguments)
                }
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        EngineInjector.remove(binding.flutterEngine)
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
