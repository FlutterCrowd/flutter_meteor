import 'package:flutter/material.dart';
import 'package:hz_router/hz_router.dart';

class MultiEnginPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MultiEnginPageState();
  }
}

class _MultiEnginPageState extends State<MultiEnginPage2> {
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
                HzNavigator.pushNamed(context, routeName: "routeName");
              },
              child: Container(
                child: const Text(
                  '打开原生页面',
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
                HzNavigator.pop(context);
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
                HzNavigator.popToRoot(context);
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
                HzNavigator.pushNamed(context, routeName: "multi_engin");
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
                HzNavigator.pop(context);
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
