import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hz_router/core/hz_navigator.dart';
import 'package:hz_router/plugin/hz_router_plugin.dart';

class MultiEnginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MultiEnginPageState();
  }
}

class _MultiEnginPageState extends State<MultiEnginPage> {
  // final methodChannel = const ;
  HzRouterPlugin _hzRouterPlugin =
      HzRouterPlugin(methodChannel: MethodChannel('cn.itbox.driver/multi_engin'));
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
                _hzRouterPlugin.pop();
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
                if (HzNavigator.isCurrentRouteRoot(context)) {
                  _hzRouterPlugin.pop();
                } else {
                  HzNavigator.pop(context);
                }
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
                _hzRouterPlugin.popToRoot();
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
                HzNavigator.pushNamed(context, routeName: "mine");
              },
              child: Container(
                child: const Text(
                  '下一个flutter页面',
                  style: TextStyle(
                    backgroundColor: Colors.yellow,
                  ),
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
