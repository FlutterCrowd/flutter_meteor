package cn.itbox.fluttermeteor.core

import android.app.Activity
import android.app.Application
import android.os.Bundle
import android.util.Log
import cn.itbox.fluttermeteor.engine.EngineInjector
import java.lang.ref.WeakReference

data class ActivityInfo(
    var avtivity:WeakReference<Activity>,
    var isRoot:Boolean,
    var routeName: String,
)

internal object ActivityInjector {

    private val activityList = mutableListOf<ActivityInfo>()

    val rootActivity get() = activityList.firstOrNull()?.avtivity?.get()

    val currentActivity get() = activityList.lastOrNull()?.avtivity?.get()

    val lastActivityRouteName get() = activityList.lastOrNull()?.routeName

    fun inject(application: Application) {
        application.registerActivityLifecycleCallbacks(ActivityLifecycle())
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

    private class ActivityLifecycle : Application.ActivityLifecycleCallbacks {

        override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
            val intent = activity.intent
            val name = intent.getStringExtra("routeName")
            val initialRoute = intent.getStringExtra("initialRoute")
            val isRoot = initialRoute != null
            val rootName = name ?: (initialRoute ?: "")
            activityList.add(ActivityInfo(WeakReference(activity),isRoot,rootName))
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