import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class MultiEnginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MultiEnginPageState();
  }
}

class _MultiEnginPageState extends State<MultiEnginPage> {
  // final methodChannel = const ;
  // final HzRouterPlugin _hzRouterPlugin = HzRouterPlugin(needNewChannel: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('多引擎打开'),
      ),
      body: Column(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.pop({'name1': 'I' 'm bob, I from Flutter, 哈哈'});
              },
              child: Container(
                child: const Text(
                  '返回上一个Native',
                  style: TextStyle(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.pop({'params': '回传'});
              },
              child: Container(
                child: const Text(
                  '返回上一个flutter',
                  style: TextStyle(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.popToRoot();
              },
              child: Container(
                child: const Text(
                  '返回根页面',
                  style: TextStyle(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.pushNamed("mine");
              },
              child: const Text(
                '下一个flutter页面',
                style: TextStyle(
                  backgroundColor: Colors.yellow,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
        // 创建Flutter引擎实例
      ),
    );
  }
}
