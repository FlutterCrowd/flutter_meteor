import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class MultiEnginPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MultiEnginPageState();
  }
}

class _MultiEnginPageState extends State<MultiEnginPage2> {
  @override
  void initState() {
    super.initState();
    // _hzRouterPlugin.setCustomMethodCallHandler(customMethodCallHandler: (method, arguments) {
    //   print(method);
    //   print(arguments);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('多引擎打开2'),
      ),
      body: Column(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.pushNamed("test2", openNative: true);
              },
              child: const Text(
                'present原生页面',
                style: TextStyle(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.pushNamed("multi_engin2", openNative: true);
              },
              child: const Text(
                'push原生页面',
                style: TextStyle(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.pop({'params': '回传'});
              },
              child: const Text(
                '返回原生',
                style: TextStyle(
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.popToRoot();
              },
              child: const Text(
                '返回根页面',
                style: TextStyle(
                  backgroundColor: Colors.yellow,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.pushNamed("multi_engin");
              },
              child: const Text(
                '下一个flutter页面',
                style: TextStyle(
                  backgroundColor: Colors.yellow,
                ),
              ),
            ),
          ),
          const SizedBox(
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
                    backgroundColor: Colors.yellow,
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
