import 'package:flutter/material.dart';
import 'package:hz_router/plugin/hz_router_plugin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final HzRouterPlugin _routerPlugin = HzRouterPlugin(needNewChannel: true);
  // final methodChannel = const MethodChannel('cn.itbox.driver/mine');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
      ),
      body: Column(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                _routerPlugin.push(routerName: "page_router");
              },
              child: const Text(
                '打开原生页面',
                style: TextStyle(
                  backgroundColor: Colors.red,
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
                _routerPlugin.push(routerName: "multi_engin");
              },
              child: const Text(
                '打开新引擎',
                style: TextStyle(
                  backgroundColor: Colors.red,
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
                Navigator.pushNamed(context, "multi_engin");
              },
              child: const Text(
                '打开flutter页面1',
                style: TextStyle(
                  backgroundColor: Colors.red,
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
                Navigator.pushNamed(context, "multi_engin2");
              },
              child: const Text(
                '打开flutter页面2',
                style: TextStyle(
                  backgroundColor: Colors.red,
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
                Navigator.pop(context);
              },
              child: const Text(
                '返回flutter页面',
                style: TextStyle(
                  backgroundColor: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
        // 创建Flutter引擎实例
      ),
    );
  }
}
