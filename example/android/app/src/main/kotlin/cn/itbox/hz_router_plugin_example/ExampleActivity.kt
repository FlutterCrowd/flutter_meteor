package cn.itbox.hz_router_plugin_example

import FlutterMeteorRouteManager.startActivity
import android.annotation.SuppressLint
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import cn.itbox.fluttermeteor.core.FlutterMeteor
import cn.itbox.fluttermeteor.core.FlutterMeteorRouteOptions

class ExampleActivity : AppCompatActivity() {
    @SuppressLint("MissingInflatedId", "CutPasteId")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_example)

        val routeName = intent.getStringExtra("routeName")
        val key1 = intent.getStringExtra("key1")
        val key2 = intent.getIntExtra("key2", -1)

        // Use the received data as needed

        val test = findViewById<View>(R.id.test)
        test.setOnClickListener {
            startActivity("test")
        }

        val flutter = findViewById<View>(R.id.flutter)
        flutter.setOnClickListener {
            val options = FlutterMeteorRouteOptions.Builder()
                .initialRoute("multiEnginePage2")
                .requestCode(200)
                .build()
            FlutterMeteor.open(this, options)
        }

        val button = findViewById<View>(R.id.second)
        button.setOnClickListener {
            startActivity("test")
        }
    }
}
