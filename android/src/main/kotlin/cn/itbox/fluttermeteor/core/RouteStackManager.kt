package cn.itbox.fluttermeteor.core

data class RouterInfo(val name: String, val isNative: Boolean,val hasChild:Boolean)

object RouteStackManager {
    //当前顶部路由
    private var topRoute: RouterInfo? = null
    //当前是否为主引擎
    private var isMainEngine: Boolean = true
    //当前路由栈
    private val routeStack = mutableListOf<RouterInfo>()

    /**
     * 注入原生路由
     */
    fun injectNativeRouteInfo(){

    }

    /**
     * 注入flutter路由
     */
    fun injectFlutterRouteInfo(){

    }

    /**
     * 根据路由名称pushUntil
     */
    fun pushUntil(){

    }

    /**
     * 获取最顶部路由是否为原生
     */
    fun topRouteIsNative():Boolean{
        return false
    }
}