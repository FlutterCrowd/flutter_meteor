import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hz_router/core/hz_navigator.dart';
import 'package:hz_router/plugin/hz_router_plugin.dart';

class MultiEnginPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MultiEnginPageState();
  }
}

class _MultiEnginPageState extends State<MultiEnginPage2> {
  final HzRouterPlugin _hzRouterPlugin =
      HzRouterPlugin(methodChannel: const MethodChannel('cn.itbox.driver/multi_engin'));
  final HzRouterPlugin _hzMainPlugin = HzRouterPlugin();
  // final methodChannel = const MethodChannel('cn.itbox.driver/multi_engin');

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
                _hzMainPlugin.push(routerName: "router");
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
                _hzRouterPlugin.pop();
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
                _hzRouterPlugin.popToRoot();
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
          const SizedBox(
            height: 20,
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
