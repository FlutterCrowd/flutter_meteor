package cn.itbox.fluttermeteor

import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec

class FlutterMeteorChannelProvider(messenger: BinaryMessenger) {
    companion object {
        const val navigatorMethodChannelName = "itbox.meteor.navigatorChannel"
        const val routerMethodChannelName = "itbox.meteor.routerChannel"
        const val eventBusMessageChannelName = "itbox.meteor.multiEnginEventChannel"
    }

    private val _navigatorChannel = MethodChannel(messenger, navigatorMethodChannelName)
    val navigatorChannel: MethodChannel
        get() = _navigatorChannel

//    private val _routerChannel = MethodChannel(messenger, routerMethodChannelName)
//    val routerChannel: MethodChannel
//        get() = _routerChannel

    private val _eventBusChannel = BasicMessageChannel(messenger, eventBusMessageChannelName, StandardMessageCodec())
    val eventBusChannel: BasicMessageChannel<Any>
        get() = _eventBusChannel

}
