package cn.itbox.fluttermeteor.core

import android.app.Activity
import android.app.Application
import android.os.Bundle
import android.util.Log
import cn.itbox.fluttermeteor.engine.EngineInjector
import cn.itbox.fluttermeteor.FlutterMeteorChannelProvider
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference
import java.nio.channels.spi.AsynchronousChannelProvider

data class ActivityInfo(
    var avtivity:WeakReference<Activity>,
    var isRoot:Boolean,
    var routeName: String,
    var channelProvider: FlutterMeteorChannelProvider?,
    var hashCode: Int,
)

internal object ActivityInjector {

    private val activityList = mutableListOf<ActivityInfo>()

    val rootActivity get() = activityList.firstOrNull()?.avtivity?.get()

    val currentActivity get() = activityList.lastOrNull()?.avtivity?.get()

    val lastActivityRouteName get() = activityList.lastOrNull()?.routeName

    val activityInfoStack get() = activityList.reversed()

    fun inject(application: Application) {
        application.registerActivityLifecycleCallbacks(ActivityLifecycle())
    }

    fun attachChannel(hashCode: Int, channelProvider: FlutterMeteorChannelProvider?){
        for(info in activityList){
            if(hashCode == info.hashCode){
                info.channelProvider = channelProvider
            }
        }
    }

    fun finishToRoot() {
        activityList.forEachIndexed { index, weakReference ->
            if (index > 0) {
                weakReference.avtivity.get()?.finish()
            }
        }
    }

    fun popActivity(name:String){
        if(activityList.isNotEmpty()){
            for(activity in activityList.reversed()){
                if(activity.isRoot){
                    if(name != activity.routeName){
                        activity.avtivity.get()?.finish()
                        EngineInjector.removeLast()
                    }else{
                        break
                    }
                }else{
                    if(activity.routeName == ""){//mainactivity
                        break
                    }
                    if(name != activity.routeName){
                        activity.avtivity.get()?.finish()
                    }else{
                        break
                    }
                }
            }
        }
    }

    fun popTop(){
        currentActivity?.finish()
        activityList.removeLast()
        EngineInjector.removeLast()
    }

    fun remove(activity: Activity){
        activityList.forEachIndexed { index, weakReference ->
            if (activity.hashCode() == weakReference.avtivity.get().hashCode()) {
                weakReference.avtivity.get()?.finish()
                activityList.removeAt(index)
                return
            }
        }
    }

    private class ActivityLifecycle : Application.ActivityLifecycleCallbacks {

        override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
            val intent = activity.intent
            val name = intent.getStringExtra("routeName")
            val initialRoute = intent.getStringExtra("initialRoute")
            val isRoot = initialRoute != null
            val rootName = name ?: (initialRoute ?: "")
            Log.e("FlutterMeteor","onActivityCreated------$name<---<----$initialRoute---->-->${activity}")
            activityList.add(ActivityInfo(WeakReference(activity),isRoot,rootName,null,activity.hashCode()))
        }

        override fun onActivityStarted(activity: Activity) {
        }

        override fun onActivityResumed(activity: Activity) {
        }

        override fun onActivityPaused(activity: Activity) {
        }

        override fun onActivityStopped(activity: Activity) {
        }

        override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
        }

        override fun onActivityDestroyed(activity: Activity) {
            activityList.removeAll {
                val activityObject = it.avtivity.get()
                activityObject == null || activityObject == activity
            }
        }
    }

}