import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class MultiEnginPage2 extends StatefulWidget {
  const MultiEnginPage2({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MultiEnginPageState();
  }
}

class _MultiEnginPageState extends State<MultiEnginPage2> {
  // late MeteorEventBusListener listener;
  // MeteorEventBusListener listener2 = (arguments) {
  //   print('native_event2, arguments:$arguments');
  //   MeteorNavigator.pushNamed('multiEnginePage');
  // };
  @override
  void initState() {
    super.initState();
    MeteorEventBusListener listener = (arguments) {
      print('native_event, arguments:$arguments');
      MeteorNavigator.pushNamed('multiEnginePage');
    };
    MeteorEventBusListener listener2 = (arguments) {
      print('native_event2, arguments:$arguments');
      MeteorNavigator.pushNamed('multiEnginePage');
    };
    MeteorEventBus.addListener(eventName: 'native_event', listener: listener);
    MeteorEventBus.addListener(eventName: 'native_event1', listener: listener2);
  }

  @override
  void dispose() {
    // MeteorEventBus.removeListener(eventName: 'native_event', listener: listener);
    // MeteorEventBus.removeListener(eventName: 'native_event1', listener: listener2);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('多引擎打开2'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                MeteorNavigator.pushNamed("push_native", openNative: true, present: true);
              },
              child: const Text(
                'present原生页面',
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
                MeteorNavigator.pushNamed("push_native", openNative: true);
              },
              child: const Text(
                'push原生页面',
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
                MeteorNavigator.pushNamed("multiEnginePage2",
                    openNative: true, withNewEngine: true);
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
                MeteorNavigator.pop({'params': '回传'});
              },
              child: const Text(
                '返回上一个页面',
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
                MeteorNavigator.popToRoot();
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
                MeteorNavigator.pushNamed("multiEnginePage");
              },
              child: const Text(
                '下一个flutter页面',
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
                MeteorNavigator.pushNamedAndRemoveUntil('multiEnginePage', 'test');
              },
              child: const Text(
                'pushNamedAndRemoveUntil',
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
                MeteorNavigator.pushReplacementNamed('multiEnginePage');
              },
              child: const Text(
                'pushReplacementNamed',
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
                MeteorNavigator.pushReplacementNamed('multiEnginePage2');
              },
              child: const Text(
                'pushReplacementNamed',
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
                MeteorEventBus.commit(eventName: 'native_event', data: '这是数据');
              },
              child: const Text(
                '发送个事件',
                style: TextStyle(
                  backgroundColor: Colors.yellow,
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
