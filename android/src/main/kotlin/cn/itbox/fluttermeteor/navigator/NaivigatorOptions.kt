package cn.itbox.fluttermeteor.navigator

// Type alias for callback
typealias FlutterMeteorRouterCallBack = (response: Any?) -> Unit

// FMPushOptions data class
data class FMPushOptions(
    var withNewEngine: Boolean = false,
    var isOpaque: Boolean = false,
    var present: Boolean = false,
    var animated: Boolean = true,
    var arguments: Map<String, Any>? = null,
    var callBack: FlutterMeteorRouterCallBack? = null
)

// FMPopOptions data class
data class FMPopOptions(
    var animated: Boolean = true,
    var canDismiss: Boolean = true,
    var result: Map<String, Any>? = null,
    var callBack: FlutterMeteorRouterCallBack? = null
)

// FMPushParams data class
data class FMPushParams(
    var routeName: String,
    var untilRouteName: String? = null,
    var options: FMPushOptions? = null
)

// FMPopParams data class
data class FMPopParams(
    var untilRouteName: String? = null,
    var options: FMPopOptions? = null
)
