package cn.itbox.hz_router_plugin_example

// SecondActivity.kt
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity

class SecondActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_second)

        // 获取传递的参数
        val message = intent.getStringExtra("EXTRA_MESSAGE")
        val number = intent.getIntExtra("EXTRA_NUMBER", 0)

        // 使用参数
        // ...
    }
}
