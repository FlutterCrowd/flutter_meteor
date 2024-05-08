import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hz_router/core/hz_navigator.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage> {
  final methodChannel = const MethodChannel('cn.itbox.driver/mine');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
      ),
      body: Column(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                /// 返回原生页面
                // Navigator.pop(context);
                // _multiEnginPlugin.back();
                methodChannel.invokeMethod('pop');
              },
              child: Container(
                child: const Text(
                  '返回原生页面',
                  style: TextStyle(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                /// 返回原生页面
                // Navigator.pop(context);
                // _multiEnginPlugin.back();
                HzNavigator.pop(context);
              },
              child: Container(
                child: const Text(
                  '返回flutter页面',
                  style: TextStyle(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
            ),
          ),
        ],
        // 创建Flutter引擎实例
      ),
    );
  }
}
