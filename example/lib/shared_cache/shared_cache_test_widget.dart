import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class SharedCacheTestPage extends StatefulWidget {
  const SharedCacheTestPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MultiEnginPageState();
  }
}

class _MultiEnginPageState extends State<SharedCacheTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('测试页面'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  GestureDetector(
                    onTap: () {
                      SharedMemoryCache.setString('stringKey', 'Hello');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: const Text(
                        '存储String-Hello',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      SharedMemoryCache.setBool('boolKey', true);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: const Text(
                        '存储Bool-true',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      SharedMemoryCache.setInt('intKey', 10086);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: const Text(
                        '存储Int-10086',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      SharedMemoryCache.setDouble('doubleKey', 10.01);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: const Text(
                        '存储Double-10.10',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      SharedMemoryCache.setList('listKey', [1, 2, 3, 4, 5]);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: const Text(
                        '存储List-[1,2,3]',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      SharedMemoryCache.setMap(
                          'mapKey', {"1": "1", "2": "11", "3": "111", "4": "1111"});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: const Text(
                        '存储Map-{"1":"1","2":"2","3":"?"}',
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  GestureDetector(
                    onTap: () async {
                      String? test = await SharedMemoryCache.getString('stringKey');
                      print("取出:---> $test");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: const Text(
                        '取出String-Hello',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      bool? test = await SharedMemoryCache.getBool('boolKey');
                      print("取出:---> $test");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: const Text(
                        '取出Bool-true',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      int? test = await SharedMemoryCache.getInt('intKey');
                      print("取出:---> $test");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: const Text(
                        '取出Int-10086',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      double? test = await SharedMemoryCache.getDouble('doubleKey');
                      print("取出:---> $test");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: const Text(
                        '取出Double-10.10',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      List? test = await SharedMemoryCache.getList('listKey');
                      print("取出:---> $test");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: const Text(
                        '取出List-[1,2,3]',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Map<String, dynamic>? test = await SharedMemoryCache.getMap('mapKey');
                      print("取出:---> $test");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.blueGrey,
                      child: const Text(
                        '取出Map-{"1":"1","2":"2","3":"?"}',
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  MeteorNavigator.pushNamed("multiEnginePage2", pageType: PageType.newEngine);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.blueGrey,
                  child: const Text(
                    '打开新引擎',
                  ),
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  MeteorEventBus.commit(
                    eventName: 'eventName',
                    data: {'key': '嘟嘟噜'},
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.blueGrey,
                  child: const Text(
                    '发送消息',
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
