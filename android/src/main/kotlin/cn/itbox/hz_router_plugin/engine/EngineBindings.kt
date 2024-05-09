package cn.itbox.hz_router_plugin.engine

import android.app.Activity
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.embedding.engine.dart.DartExecutor

class EngineBindings(context: Activity, initialRoute: String?, entrypoint: String, entryPointArgs: List<String>?, val id: Int) {

//    val channel: MethodChannel
    val engine: FlutterEngine

    init {
        // Represents a collection of FlutterEngines who share resources to allow them to be created faster and with less memory
        val engineGroup: FlutterEngineGroup = EngineGroupProvider.obtainEngineGroup(context)
        // The path within the AssetManager where the app will look for assets
        val pathToBundle: String = FlutterInjector.instance().flutterLoader().findAppBundlePath()
        // This has to be lazy to avoid creation before the FlutterEngineGroup
        val dartEntrypoint = DartExecutor.DartEntrypoint(pathToBundle, entrypoint)
        val options = FlutterEngineGroup.Options(context).apply {
            setInitialRoute(initialRoute)
            setDartEntrypoint(dartEntrypoint)
            setDartEntrypointArgs(entryPointArgs)
        }
        // Creates a FlutterEngine in this group and run its DartExecutor with the specified DartEntrypoint
        engine = engineGroup.createAndRunEngine(options) // 创建 FlutterEngine 并执行指定的 DartEntrypoint
//        channel = MethodChannel(engine.dartExecutor.binaryMessenger, "multiple-flutters")
    }

    fun attach() {
//        channel.setMethodCallHandler { call, result ->
//            when (call.method) {
//                "goNative" -> result.success(true).also {
//                    context.startActivity(Intent(context, NativeActivity::class.java))
//                }
//                "incrementCount" -> result.success(true).also { DataModel.data = DataModel.data + 1 }
//                "next" -> result.success(true) //.also { delegate.onNext() }
//                "pop" -> result.success(true).also {
//                    val data = Intent()
//                    if (call.arguments is Map<*, *>) {
//                        val map = call.arguments as Map<*, *>
//                        map.forEach { entry ->
//                            data.putExtra("${entry.key}", entry.value.toString())
//                        }
//                    }
//                    context.setResult(Activity.RESULT_OK, data)
//                    context.finish()
//                }
//                else -> result.notImplemented()
//            }
//        }
    }

    fun detach() {
        engine.destroy() // Cleans up all components within this FlutterEngine and destroys the associated Dart Isolate
//        DataModel.removeObserver(::observer)
//        channel.setMethodCallHandler(null)
    }

//    private fun observer(data: Int): Unit = channel.invokeMethod("setData", data)
}