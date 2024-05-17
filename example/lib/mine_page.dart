import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage> {
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
                MeteorNavigator.pop({'params': '回传'});
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
                MeteorNavigator.pop({'params': '回传'});
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
          SizedBox(
            height: 20,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                /// 返回原生页面
                MeteorNavigator.popToRoot();
              },
              child: const Text(
                '返回根视图',
                style: TextStyle(
                  backgroundColor: Colors.green,
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
