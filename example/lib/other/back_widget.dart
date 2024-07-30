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
            height: 20,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.popUntil('multiEnginePage2');
              },
              child: const Text(
                'popUntil multiEnginePage2',
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
            height: 20,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.pushNamedAndRemoveUntil(
                  'multiEnginePage2',
                  'homePage',
                );
              },
              child: const Text(
                'pushNamedAndRemoveUntil multiEnginePage2 home',
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
                MeteorNavigator.pushNamedAndRemoveUntil(
                  'multiEnginePage2',
                  'null',
                );
              },
              child: const Text(
                'pushNamedAndRemoveUntil multiEnginePage2 null',
                style: TextStyle(
                  backgroundColor: Colors.green,
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
                MeteorNavigator.pushNamedAndRemoveUntilRoot(
                  'multiEnginePage2',
                );
              },
              child: const Text(
                'pushNamedAndRemoveUntilRoot multiEnginePage2',
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
                MeteorNavigator.pushReplacementNamed('multiEnginePage2');
              },
              child: const Text(
                'pushReplacementNamed multiEnginePage2',
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
                MeteorEventBus.addListener(
                    eventName: 'eventName',
                    listener: (data) {
                      debugPrint('来了，他来了');
                    });
                MeteorEventBus.commit(
                  eventName: 'eventName',
                  data: {'kev': 'value'},
                );
              },
              child: const Text(
                '发送EventBus',
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
                MeteorNavigator.popUntil('test');
              },
              child: const Text(
                'popUntil',
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
                MeteorNavigator.popUntil('multiEnginePage2');
              },
              child: const Text(
                'popUntil2',
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
                MeteorNavigator.pushReplacementNamed('test', openNative: true);
              },
              child: const Text(
                'pushAndReplace',
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
                MeteorNavigator.pushNamedAndRemoveUntil('test2', 'multiEnginePage2',
                    openNative: true);
              },
              child: const Text(
                'pushAndRemoveUntil',
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
              onTap: () async {
                debugPrint(
                    'MeteorNavigator routeNameStack: ${await MeteorNavigator.routeNameStack()}');
                debugPrint('MeteorNavigator topRouteName: ${await MeteorNavigator.topRouteName()}');
                debugPrint(
                    'MeteorNavigator rootRouteName: ${await MeteorNavigator.rootRouteName()}');
                debugPrint('MeteorNavigator isRoot: ${await MeteorNavigator.isRoot('rootPage')}');
                debugPrint(
                    'MeteorNavigator isCurrentRoot: ${await MeteorNavigator.isCurrentRoot()}');
                debugPrint(
                    'MeteorNavigator routeExists multiEnginePage2:${await MeteorNavigator.routeExists('multiEnginePage2')}');
                debugPrint(
                    'MeteorNavigator topRouteIsNative:${await MeteorNavigator.topRouteIsNative()}');
                // debugPrint(
                //     'MeteorNavigator routeNameStack1: ${MeteorNavigator.navigatorObserver.routeNameStack}');
                // debugPrint(
                //     'MeteorNavigator topRouteName1: ${MeteorNavigator.navigatorObserver.topRouteName}');
                // debugPrint(
                //     'MeteorNavigator rootRouteName1: ${MeteorNavigator.navigatorObserver.rootRouteName}');
                // debugPrint(
                //     'MeteorNavigator isRoot1: ${MeteorNavigator.navigatorObserver.isRootRoute('multiEnginePage2')}');
                // debugPrint(
                //     'MeteorNavigator isCurrentRoot1: ${MeteorNavigator.navigatorObserver.isCurrentRoot()}');
                // debugPrint(
                //     'MeteorNavigator routeExists1:${MeteorNavigator.navigatorObserver.routeExists('multiEnginePage2')}');
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
