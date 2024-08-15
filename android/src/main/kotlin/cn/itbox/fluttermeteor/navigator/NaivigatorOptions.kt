package cn.itbox.fluttermeteor.navigator

// Type alias for callback
typealias FlutterMeteorRouterCallBack = (response: Any?) -> Unit

open class BaseOptions(
    open var callBack: FlutterMeteorRouterCallBack? = null
)

// FMPushOptions data class
class FMPushOptions(
    var withNewEngine: Boolean = false,
    var isOpaque: Boolean = false,
    var openNative: Boolean = false,
    var present: Boolean = false,
    var animated: Boolean = true,
    var arguments: Any? = null
) : BaseOptions()

// FMPopOptions data class
class FMPopOptions(
    var animated: Boolean = true,
    var canDismiss: Boolean = true,
    var arguments: Any? = null,
    var result: Map<String, Any>? = null,
) : BaseOptions()

// FMPushParams data class
class FMPushParams(
    var routeName: String,
    var untilRouteName: String? = null,
    var options: FMPushOptions? = null
) : BaseOptions()

// FMPopParams data class
class FMPopParams(
    var untilRouteName: String? = null,
    var options: FMPopOptions? = null
) : BaseOptions()
