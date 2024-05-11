import 'package:flutter/material.dart';
import 'package:hz_router/hz_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
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
                HzNavigator.pushNamed("page_router");
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
                HzNavigator.pushNamed("multi_engin2", withNewEngine: true);
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
