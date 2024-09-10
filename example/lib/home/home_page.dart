import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final widget = ListView(
      children: [
        const SizedBox(
          height: 50,
        ),
        ElevatedButton(
          onPressed: () async {
            MeteorNavigator.pushNamed("multiEnginePage");
          },
          child: const Center(
            child: Text('多引擎导航测试'),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            MeteorNavigator.pushNamed("routeTypePage");
          },
          child: const Center(
            child: Text('路由测试'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed(
              'eventBusTestPage',
              withNewEngine: true,
            );
          },
          child: const Center(
            child: Text('测试EventBus'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed(
              "sharedCacheTestPage",
            );
          },
          child: const Center(
            child: Text('共享内存'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed(
              "shareStatePage1",
            );
          },
          child: const Center(
            child: Text('共享状态'),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed(
              "globalSingletonStatePage",
            );
          },
          child: const Center(
            child: Text('全局单利对象'),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
      ),
      body: Stack(
        children: [
          widget,
        ],
      ),
    );
  }
}
