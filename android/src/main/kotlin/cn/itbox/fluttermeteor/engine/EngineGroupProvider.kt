package cn.itbox.fluttermeteor.engine

import android.content.Context
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.embedding.engine.dart.DartExecutor

internal object EngineGroupProvider {

    private var _engineGroup: FlutterEngineGroup? = null

    fun obtainEngineGroup(context: Context): FlutterEngineGroup {
        if (_engineGroup == null) {
            _engineGroup = FlutterEngineGroup(context.applicationContext)
        }
        return _engineGroup!!
    }
}