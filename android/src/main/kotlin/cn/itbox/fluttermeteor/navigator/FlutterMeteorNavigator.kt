package cn.itbox.fluttermeteor.navigator

import androidx.fragment.app.Fragment

object FlutterMeteorNavigator {

    @JvmStatic
    fun push(routeName: String, options: FMPushOptions? = null) {

    }

    @JvmStatic
    fun present(routeName: String, options: FMPushOptions? = null) {
    }

    @JvmStatic
    fun pushToAndRemoveUntil(routeName: String, untilRouteName: String?, options: FMPushOptions? = null) {
    }

    @JvmStatic
    fun _realPushToAndRemoveUntil(
        routeName: String,
        untilRouteName: String?,
        untilPage: Fragment?,
        options: FMPushOptions? = null
    ) {
    }

    @JvmStatic
    fun pushNamedAndRemoveUntilRoot(routeName: String, options: FMPushOptions? = null) {
    }

    @JvmStatic
    fun pushToReplacement(routeName: String, options: FMPushOptions? = null) {
    }

    @JvmStatic
    fun pop(options: FMPopOptions? = null) {
    }

    @JvmStatic
    fun popUntil(untilRouteName: String?, options: FMPopOptions? = null) {
    }

    private fun _popUntil(untilRouteName: String, untilPage: Fragment?, options: FMPopOptions?) {
    }

    @JvmStatic
    fun popToRoot(options: FMPopOptions? = null) {
    }

    @JvmStatic
    fun dismiss(options: FMPopOptions? = null) {
    }

    /*------------------------router method start--------------------------*/
    @JvmStatic
    fun searchRoute(routeName: String, result: (Fragment?) -> Unit) {
    }

    @JvmStatic
    fun routeExists(routeName: String, result: (Boolean) -> Unit) {
    }

    @JvmStatic
    fun isRoot(routeName: String, result: (Boolean) -> Unit) {
    }

    @JvmStatic
    fun rootRouteName(result: (String?) -> Unit) {
    }

    @JvmStatic
    fun topRouteName(result: (String?) -> Unit) {
    }

    @JvmStatic
    fun routeNameStack(result: (List<String>) -> Unit) {
    }

    @JvmStatic
    fun topRouteIsNative(result: (Boolean) -> Unit) {
    }
}
