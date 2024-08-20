package cn.itbox.hz_router_plugin_example

import FlutterMeteorRouteManager.startActivity
import android.annotation.SuppressLint
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Toast
import cn.itbox.fluttermeteor.core.FlutterMeteor
import cn.itbox.fluttermeteor.core.FlutterMeteorRouteOptions
import cn.itbox.fluttermeteor.event_bus.MeteorEventBus
import cn.itbox.fluttermeteor.event_bus.MeteorEventBusListener
import cn.itbox.fluttermeteor.navigator.FMPushOptions
import cn.itbox.fluttermeteor.navigator.FMPopOptions
import cn.itbox.fluttermeteor.navigator.FlutterMeteorRouterCallBack

class NativeActivity : AppCompatActivity() {
    @SuppressLint("MissingInflatedId")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_native)

        val button = findViewById<View>(R.id.button)
        button.setOnClickListener {
            val options = FlutterMeteorRouteOptions.Builder()
                .initialRoute("multiEnginePage")
                .requestCode(200)
                .build()
            FlutterMeteor.open(this, options)
        }

        val root = findViewById<View>(R.id.root)
        root.setOnClickListener {
            FlutterMeteor.popToRoot()
//            startActivity(Intent(this, MainActivity::class.java))
        }

        val test = findViewById<View>(R.id.test)
        test.setOnClickListener {
            startActivity("test")
        }

        val newPush = findViewById<View>(R.id.newPush)
        newPush.setOnClickListener {
            val option = FMPushOptions(
                withNewEngine = true,
                isOpaque = false,
                openNative = false,
                arguments = null,
            )
            option.callBack = object :FlutterMeteorRouterCallBack{
                override fun invoke(response: Any?) {
                    Log.e("OnMethodCall","-------> $response")
                }
            }
            cn.itbox.fluttermeteor.navigator.FlutterMeteorNavigator.push(
                routeName = "multiEnginePage",
                option
            )
        }

        val newPop = findViewById<View>(R.id.newPop)
        newPop.setOnClickListener {
            val option = FMPopOptions(
                arguments = null,
            )
            option.callBack = object : FlutterMeteorRouterCallBack {
                override fun invoke(response: Any?) {
                    Log.e("OnMethodCall","-------> $response")
                }
            }
            cn.itbox.fluttermeteor.navigator.FlutterMeteorNavigator.pop(option)
        }

        val newPopUntil = findViewById<View>(R.id.newPopUntil)
        newPopUntil.setOnClickListener {
            cn.itbox.fluttermeteor.navigator.FlutterMeteorNavigator.popUntil("rootPage")
        }

        val newPopToRoot = findViewById<View>(R.id.newPopToRoot)
        newPopToRoot.setOnClickListener {
            cn.itbox.fluttermeteor.navigator.FlutterMeteorNavigator.popToRoot()
        }

        val newPushReplace = findViewById<View>(R.id.newPushReplace)
        newPushReplace.setOnClickListener {
            val option = FMPushOptions(
                withNewEngine = true,
                isOpaque = false,
                openNative = false,
                arguments = null,
            )
            option.callBack = object :FlutterMeteorRouterCallBack{
                override fun invoke(response: Any?) {
                    Log.e("OnMethodCall","-------> $response")
                }
            }
            cn.itbox.fluttermeteor.navigator.FlutterMeteorNavigator.pushToReplacement("test",option)
        }

        val newPushRemoveUntil = findViewById<View>(R.id.newPushRemoveUntil)
        newPushRemoveUntil.setOnClickListener {
            val option = FMPushOptions(
                withNewEngine = true,
                isOpaque = false,
                openNative = false,
                arguments = null,
            )
            option.callBack = object :FlutterMeteorRouterCallBack{
                override fun invoke(response: Any?) {
                    Log.e("OnMethodCall","-------> $response")
                }
            }
            cn.itbox.fluttermeteor.navigator.FlutterMeteorNavigator.pushToAndRemoveUntil("test","rootPage",option)
        }

        MeteorEventBus.addListener("eventName",null, listener = object :MeteorEventBusListener{
            override fun invoke(p1: Map<String, Any?>?) {
                println("得到了结果---》$p1")
            }

        })
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 200 && resultCode == RESULT_OK) {
            val name1 = data?.getStringExtra("name1")
            Toast.makeText(this, "name1=$name1, ", Toast.LENGTH_SHORT).show()
        }
    }
}