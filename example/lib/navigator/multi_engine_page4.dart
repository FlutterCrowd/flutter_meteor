import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class MultiEnginePage4 extends StatefulWidget {
  const MultiEnginePage4({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MultiEnginePageState();
  }
}

class _MultiEnginePageState extends State<MultiEnginePage4> {
  // final methodChannel = const ;
  // final HzRouterPlugin _hzRouterPlugin = HzRouterPlugin(needNewChannel: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MultiEnginePage4'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                MeteorNavigator.pop();
              },
              child: const Text(
                '返回上一页',
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
                  'multiEnginePage5',
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
                  'multiEnginePage5',
                  arguments: {'name1': 'I' 'm bob, I from Flutter, 哈哈'},
                  pageType: PageType.newEngine,
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
                  'native_page4',
                  pageType: PageType.native,
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
                  "native_page4",
                  isOpaque: false,
                  pageType: PageType.native,
                  present: true,
                );
                // MeteorNavigator.pushNamed("test", pageType: PageType.native,, present: true, isOpaque: false);
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
                  "multiEnginePage5",
                  isOpaque: false,
                  pageType: PageType.newEngine,
                  present: true,
                );
                // MeteorNavigator.pushNamed("test", pageType: PageType.native,, present: true, isOpaque: false);
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
                MeteorNavigator.pushReplacementNamed('multiEnginePage5');
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
                  'multiEnginePage5',
                  pageType: PageType.newEngine,
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
                  'native_page4',
                  arguments: {},
                  pageType: PageType.native,
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
                  'multiEnginePage5',
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
                  'multiEnginePage5',
                  'multiEnginePage',
                  arguments: {},
                  pageType: PageType.newEngine,
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
                  'multiEnginePage5',
                  'native_page1',
                  arguments: {},
                  pageType: PageType.native,
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
                  'native_page4',
                  'multiEnginePage',
                  arguments: {},
                  pageType: PageType.native,
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
                  'native_page4',
                  'native_page1',
                  arguments: {},
                  pageType: PageType.native,
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
                  'multiEnginePage5',
                  arguments: {},
                );
              },
              child: const Text(
                'pushNamedAndRemoveUntilRoot multiEnginePage5',
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
                  'multiEnginePage5',
                  arguments: {},
                  pageType: PageType.newEngine,
                );
              },
              child: const Text(
                'pushNamedAndRemoveUntilRoot newEngine multiEnginePage5',
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
                  'native_page4',
                  arguments: {},
                  pageType: PageType.native,
                );
              },
              child: const Text(
                'pushNamedAndRemoveUntilRoot native_page4',
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
                    'MeteorNavigator routeExists multiEnginePage5:${await MeteorNavigator.routeExists('multiEnginePage5')}');
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
