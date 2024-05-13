package cn.itbox.hz_router_plugin_example

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Toast
import cn.itbox.fluttermeteor.core.FlutterMeteor
import cn.itbox.fluttermeteor.core.FlutterMeteorRouteOptions

class NativeActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_native)

        val button = findViewById<View>(R.id.button)
        button.setOnClickListener {
            val options = FlutterMeteorRouteOptions.Builder()
                .initialRoute("multi_engin")
                .requestCode(200)
                .build()
            FlutterMeteor.open(this, options)
        }

        val root = findViewById<View>(R.id.root)
        root.setOnClickListener {
            FlutterMeteor.popToRoot()
//            startActivity(Intent(this, MainActivity::class.java))
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 200 && resultCode == RESULT_OK) {
            val name1 = data?.getStringExtra("name1")
            Toast.makeText(this, "name1=$name1, ", Toast.LENGTH_SHORT).show()
        }
    }
}