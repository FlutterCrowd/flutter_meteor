import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class MultiEnginePage3 extends StatefulWidget {
  const MultiEnginePage3({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MultiEnginePageState();
  }
}

class _MultiEnginePageState extends State<MultiEnginePage3> {
  // final methodChannel = const ;
  // final HzRouterPlugin _hzRouterPlugin = HzRouterPlugin(needNewChannel: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MultiEnginePage3'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamed(
                  'multiEnginePage4',
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
                  'multiEnginePage4',
                  arguments: {'name1': 'I' 'm bob, I from Flutter, 哈哈'},
                  pageType: MeteorPageType.newEngine,
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
                  'native_page3',
                  pageType: MeteorPageType.native,
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
                  "native_page3",
                  isOpaque: false,
                  pageType: MeteorPageType.newEngine,
                  present: true,
                );
                // MeteorNavigator.pushNamed("test", pageType: MeteorPageType.native,, present: true, isOpaque: false);
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
                  "multiEnginePage4",
                  isOpaque: false,
                  pageType: MeteorPageType.newEngine,
                  present: true,
                );
                // MeteorNavigator.pushNamed("test", pageType: MeteorPageType.native,, present: true, isOpaque: false);
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
                MeteorNavigator.pushReplacementNamed('multiEnginePage4');
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
                  'multiEnginePage4',
                  pageType: MeteorPageType.newEngine,
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
                  'multiEnginePage4',
                  arguments: {},
                  pageType: MeteorPageType.native,
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
                  'multiEnginePage4',
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
                  'multiEnginePage4',
                  'multiEnginePage',
                  arguments: {},
                  pageType: MeteorPageType.newEngine,
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
                  'multiEnginePage4',
                  'native_page1',
                  arguments: {},
                  pageType: MeteorPageType.native,
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
                  'native_page3',
                  'multiEnginePage',
                  arguments: {},
                  pageType: MeteorPageType.native,
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
                  'native_page3',
                  'native_page1',
                  arguments: {},
                  pageType: MeteorPageType.native,
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
                  'multiEnginePage4',
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
                  'multiEnginePage4',
                  arguments: {},
                  pageType: MeteorPageType.newEngine,
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
                  'native_page3',
                  arguments: {},
                  pageType: MeteorPageType.native,
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
                    'MeteorNavigator routeExists multiEnginePage4:${await MeteorNavigator.routeExists('multiEnginePage4')}');
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
