package cn.itbox.hz_router_plugin

import androidx.annotation.NonNull
import cn.itbox.hz_router_plugin.core.FlutterRouter
import cn.itbox.hz_router_plugin.engine.EngineInjector

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** HzRouterPlugin */
class HzRouterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "cn.itbox.router.multiEngine.methodChannel")
    channel.setMethodCallHandler(this)
    EngineInjector.put(flutterPluginBinding.flutterEngine, channel)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    println("onMethodCall: ${call.method}")
    if (call.method == "push") {
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
}
