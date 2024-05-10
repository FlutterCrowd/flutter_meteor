package cn.itbox.hz_router_plugin_example

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Toast
import cn.itbox.hz_router_plugin.core.FlutterRouter
import cn.itbox.hz_router_plugin.core.FlutterRouterRouteOptions

class NativeActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_native)

        val button = findViewById<View>(R.id.button)
        button.setOnClickListener {
            val options = FlutterRouterRouteOptions.Builder()
                .routeName("multi_engin")
                .requestCode(200)
                .build()
            FlutterRouter.open(this, options)
        }

        val root = findViewById<View>(R.id.root)
        root.setOnClickListener {
            FlutterRouter.popToRoot()
//            startActivity(Intent(this, MainActivity::class.java))
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        Toast.makeText(this, "$requestCode, ", Toast.LENGTH_SHORT).show()
    }
}