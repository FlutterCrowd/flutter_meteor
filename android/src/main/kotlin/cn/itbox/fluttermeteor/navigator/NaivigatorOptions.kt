package cn.itbox.fluttermeteor.navigator

// Type alias for callback
typealias FlutterMeteorRouterCallBack = (response: Any?) -> Unit

open class BaseOptions(
    open var callBack: FlutterMeteorRouterCallBack? = null
)

enum class MeteorPageType(val type: Int) {
    FLUTTER(0),
    NATIVE(1),
    NEW_ENGINE(2);
    companion object {
        fun fromType(type: Int): MeteorPageType {
            return values().firstOrNull { it.type == type } ?: FLUTTER
        }
    }
}

// FMPushOptions data class
class MeteorPushOptions(
    var pageType: MeteorPageType = MeteorPageType.NATIVE,
    var isOpaque: Boolean = false,
    var present: Boolean = false,
    var animated: Boolean = true,
    var arguments: Any? = null
) : BaseOptions()

// FMPopOptions data class
class MeteorPopOptions(
    var animated: Boolean = true,
    var canDismiss: Boolean = true,
    var arguments: Any? = null,
    var result: Map<String, Any>? = null,
) : BaseOptions()

// FMPushParams data class