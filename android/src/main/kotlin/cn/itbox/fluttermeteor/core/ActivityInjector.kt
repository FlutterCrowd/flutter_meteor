package cn.itbox.fluttermeteor.core

import android.app.Activity
import android.app.Application
import android.os.Bundle
import java.lang.ref.WeakReference

internal object ActivityInjector {

    private val activityList = mutableListOf<WeakReference<Activity>>()

    val rootActivity get() = activityList.firstOrNull()?.get()

    val currentActivity get() = activityList.lastOrNull()?.get()

    fun inject(application: Application) {
        application.registerActivityLifecycleCallbacks(ActivityLifecycle())
    }

    fun finishToRoot() {
        activityList.forEachIndexed { index, weakReference ->
            if (index > 0) {
                weakReference.get()?.finish()
            }
        }
    }

    private class ActivityLifecycle : Application.ActivityLifecycleCallbacks {

        override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
            activityList.add(WeakReference(activity))
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
                val activityObject = it.get()
                activityObject == null || activityObject == activity
            }
        }
    }

}