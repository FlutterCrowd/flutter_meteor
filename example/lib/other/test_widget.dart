import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MultiEnginPageState();
  }
}

class _MultiEnginPageState extends State<TestPage> {
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
                       SharedCachePlugin.setString('stringKey', 'Hello');
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
                      SharedCachePlugin.setBool('boolKey', true);
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
                      SharedCachePlugin.setInt('intKey', 10086);
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
                      SharedCachePlugin.setDouble('doubleKey', 10.01);
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
                      SharedCachePlugin.setList('listKey',[1,2,3,4,5]);
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
                      SharedCachePlugin.setMap('mapKey',{"1":"1","2":"11","3":"111","4":"1111"});
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
                    onTap: () async{
                      String? test = await SharedCachePlugin.getString('stringKey');
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
                      bool? test = await SharedCachePlugin.getBool('boolKey');
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
                    onTap: ()async {
                      int? test = await SharedCachePlugin.getInt('intKey');
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
                    onTap: () async{
                      double? test = await SharedCachePlugin.getDouble('doubleKey');
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
                      List? test = await SharedCachePlugin.getList('listKey');
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
                    onTap: () async{
                      Map<String,dynamic>? test = await SharedCachePlugin.getMap('mapKey');
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
                  MeteorNavigator.pushNamed("multiEnginePage2",
                      withNewEngine: true);
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
