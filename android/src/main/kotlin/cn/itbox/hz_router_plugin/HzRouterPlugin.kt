package cn.itbox.hz_router_plugin

import android.app.Activity
import android.content.Intent
import cn.itbox.hz_router_plugin.core.FlutterRouter
import cn.itbox.hz_router_plugin.engine.EngineInjector
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** HzRouterPlugin */
class HzRouterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private var activity: Activity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "cn.itbox.router.multiEngine.methodChannel")
    channel.setMethodCallHandler(this)
    EngineInjector.put(flutterPluginBinding.flutterEngine, channel)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    println("onMethodCall: ${call.method}")
    if (call.method == "pop") {
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
      activity?.setResult(Activity.RESULT_OK, data)
      activity?.finish()
    } else if (call.method == "pushNamed") {
      val arguments = call.arguments
      if (arguments is Map<*, *>) {
        val routeName = arguments["routeName"]?.toString() ?: ""
        val routeArguments = arguments["arguments"]
        FlutterRouter.delegate?.onPushNativePage(routeName, routeArguments)
      }
      result.success(true)
    } else {
      result.notImplemented()
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
