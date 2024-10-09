import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class MultiEnginePage2 extends StatefulWidget {
  const MultiEnginePage2({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MultiEnginePageState();
  }
}

class _MultiEnginePageState extends State<MultiEnginePage2> {
  // final methodChannel = const ;
  // final HzRouterPlugin _hzRouterPlugin = HzRouterPlugin(needNewChannel: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MultiEnginePage2'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pop({'name1': 'I' 'm bob, I from Flutter, 哈哈'});
              },
              child: const Text(
                '返回上一个页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamed(
                  'multiEnginePage3',
                  arguments: {'name1': 'I' 'm bob, I from Flutter, 哈哈'},
                );
              },
              child: const Text(
                '在当前引擎打开一个flutter页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamed(
                  'multiEnginePage3',
                  arguments: {'name1': 'I' 'm bob, I from Flutter, 哈哈'},
                  withNewEngine: true,
                );
              },
              child: const Text(
                '在新引擎打开一个flutter页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamed(
                  'native_page2',
                  openNative: true,
                  arguments: {'name1': 'I' 'm bob, I from Flutter, 哈哈'},
                );
              },
              child: const Text(
                '打开一个原生页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamed(
                  "native_page2",
                  isOpaque: false,
                  withNewEngine: true,
                  present: true,
                );
                // MeteorNavigator.pushNamed("test", openNative: true,, present: true, isOpaque: false);
              },
              child: const Text(
                '模态方式打开一个原生页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamed(
                  "multiEnginePage3",
                  isOpaque: false,
                  withNewEngine: true,
                  present: true,
                );
                // MeteorNavigator.pushNamed("test", openNative: true,, present: true, isOpaque: false);
              },
              child: const Text(
                '模态方式打开一个新引擎',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushReplacementNamed('multiEnginePage3');
              },
              child: const Text(
                '在当前引擎打开flutter并替换当前flutter页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushReplacementNamed(
                  'multiEnginePage3',
                  withNewEngine: true,
                );
              },
              child: const Text(
                '通过新引擎打开flutter并替换当前flutter页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushReplacementNamed(
                  'native_page2',
                  arguments: {},
                  openNative: true,
                );
              },
              child: const Text(
                '打开Native页面并替换当前flutter页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamedAndRemoveUntil(
                  'multiEnginePage3',
                  'multiEnginePage',
                  arguments: {},
                );
              },
              child: const Text(
                '打开Flutter并移除当前栈中指定Flutter页面之前页面（包括Native）',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamedAndRemoveUntil(
                  'multiEnginePage3',
                  'multiEnginePage',
                  arguments: {},
                  withNewEngine: true,
                );
              },
              child: const Text(
                '通过新引擎打开Flutter页面并移除当前栈中指定Flutter页面之前页面（包括Native）',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamedAndRemoveUntil(
                  'multiEnginePage3',
                  'native_page1',
                  arguments: {},
                  openNative: true,
                );
              },
              child: const Text(
                '打开Flutter页面并移除当前栈中到指定Native页面之前页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamedAndRemoveUntil(
                  'native_page2',
                  'multiEnginePage',
                  arguments: {},
                  openNative: true,
                );
              },
              child: const Text(
                '打开Native页面并移除当前栈中到指定flutter页面之前页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamedAndRemoveUntil(
                  'native_page2',
                  'native_page1',
                  arguments: {},
                  openNative: true,
                );
              },
              child: const Text(
                '打开Native页面并移除当前栈中到指定Native页面之前页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamedAndRemoveUntilRoot(
                  'multiEnginePage3',
                  arguments: {},
                );
              },
              child: const Text(
                '打开flutter新页面并移除跟视图之前的所有页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamedAndRemoveUntilRoot(
                  'multiEnginePage3',
                  arguments: {},
                  withNewEngine: true,
                );
              },
              child: const Text(
                '通过新引擎打开flutter页面r并移除跟视图之前的所有页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamedAndRemoveUntilRoot(
                  'native_page1',
                  arguments: {},
                  openNative: true,
                );
              },
              child: const Text(
                '打开Native并移除跟视图之前的所有页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.popUntil('multiEnginePage');
              },
              child: const Text(
                '返回指定的最近的一个同名flutter页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.popUntil('multiEnginePage', isFarthest: true);
              },
              child: const Text(
                '返回指定的最远的一个同名flutter页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.popUntil('native_page1');
              },
              child: const Text(
                '返回指定的最近的同名Native页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.popUntil('native_page1', isFarthest: true);
              },
              child: const Text(
                '返回指定的最远的同名Native页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.popToRoot();
              },
              child: const Text(
                '返回根页面',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorEventBus.addListener(
                  eventName: 'eventName',
                  listener: (data) {
                    print('收到来自EventBus的eventName消息data: $data');
                  },
                );
              },
              child: const Text(
                '注册一个跨引擎EventBus的listener',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorEventBus.commit(eventName: 'eventName', data: {'key': 'value'});
              },
              child: const Text(
                '发送一个跨引擎的EventBus消息',
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                debugPrint('开始打印');
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
                debugPrint('结束打印');
              },
              child: const Text(
                '打印当前路由栈相关的信息',
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
