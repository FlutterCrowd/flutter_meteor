import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class BackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MultiEnginPageState();
  }
}

class _MultiEnginPageState extends State<BackPage> {
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
          const SizedBox(
            height: 50,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.pop({'name1': 'I' 'm bob, I from Flutter, 哈哈'});
              },
              child: const Text(
                'pop',
                style: TextStyle(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.popUntil('multi_engin2');
              },
              child: const Text(
                'popUntil multi_engin2',
                style: TextStyle(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.popUntil('null');
              },
              child: const Text(
                'popUntil null',
                style: TextStyle(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.pushNamedAndRemoveUntil(
                  'multi_engin2',
                  'home',
                );
              },
              child: const Text(
                'pushNamedAndRemoveUntil multi_engin2 home',
                style: TextStyle(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.pushNamedAndRemoveUntil(
                  'multi_engin2',
                  'null',
                );
              },
              child: const Text(
                'pushNamedAndRemoveUntil multi_engin2 null',
                style: TextStyle(
                  backgroundColor: Colors.green,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.pushNamedAndRemoveUntilRoot(
                  'multi_engin2',
                );
              },
              child: const Text(
                'pushNamedAndRemoveUntilRoot multi_engin2',
                style: TextStyle(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.pushReplacementNamed('multi_engin2');
              },
              child: const Text(
                'pushReplacementNamed multi_engin2',
                style: TextStyle(
                  backgroundColor: Colors.yellow,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                debugPrint('MeteorNavigator routeStack: ${MeteorNavigator.routeStack}');
                debugPrint('MeteorNavigator routeNameStack: ${MeteorNavigator.routeNameStack}');
                debugPrint('MeteorNavigator topRoute: ${MeteorNavigator.topRoute}');
                debugPrint('MeteorNavigator topRouteName: ${MeteorNavigator.topRouteName}');
                debugPrint('MeteorNavigator rootRoute: ${MeteorNavigator.rootRoute}');
                debugPrint('MeteorNavigator rootRouteName: ${MeteorNavigator.rootRouteName}');
                debugPrint('MeteorNavigator isRoot: ${MeteorNavigator.isRoot('rootPage')}');
                debugPrint('MeteorNavigator isCurrentRoot: ${MeteorNavigator.isCurrentRoot()}');
                debugPrint(
                    'MeteorNavigator routeExists:${MeteorNavigator.routeExists('multi_engin2')}');
              },
              child: const Text(
                '打印当前路由',
                style: TextStyle(
                  backgroundColor: Colors.yellow,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
        // 创建Flutter引擎实例
      ),
    );
  }
}
