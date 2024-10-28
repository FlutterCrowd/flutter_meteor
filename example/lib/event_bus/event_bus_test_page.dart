import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class EventBusTestPage extends StatefulWidget {
  const EventBusTestPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EventBusTestPageState();
  }
}

class _EventBusTestPageState extends State<EventBusTestPage> {
  String _eventData1 = '';
  Map _eventData2 = {};
  @override
  void initState() {
    super.initState();
    MeteorEventBus.addListener(
      eventName: 'eventName1',
      listener: (data) {
        if (mounted) {
          setState(() {
            _eventData1 = data;
          });
        }
      },
    );

    MeteorEventBus.addListener(
      eventName: 'eventName2',
      listener: (data) {
        if (mounted) {
          setState(() {
            _eventData2 = data;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('多引擎EventBus测试')),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text('第一条消息：$_eventData1'),
          ),
          Center(
            child: Text('第二条消息：$_eventData2'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              MeteorEventBus.commit(eventName: 'eventName1', data: '这是一个字符串');
            },
            child: const Text('点我发送第一条消息'),
          ),
          ElevatedButton(
            onPressed: () {
              MeteorEventBus.commit(eventName: 'eventName2', data: {'key': '这是一个Map'});
            },
            child: const Text('点我发送第二条消息'),
          ),
          ElevatedButton(
            onPressed: () {
              MeteorNavigator.pop();
            },
            child: const Text('点我就返回'),
          ),
          ElevatedButton(
            onPressed: () {
              MeteorNavigator.pushNamed(
                'eventBusTestPage',
                pageType: PageType.newEngine,
              );
            },
            child: const Text('打开新引擎'),
          ),
        ],
      ),
    );
  }
}
