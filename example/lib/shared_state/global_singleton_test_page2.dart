import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';
import 'package:hz_router_plugin_example/shared_state/global_singleton_object.dart';

class GlobalSingletonStatePage2 extends StatefulWidget {
  const GlobalSingletonStatePage2({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GlobalSingletonState();
  }
}

class _GlobalSingletonState extends State<GlobalSingletonStatePage2> {
  @override
  void initState() {
    super.initState();
    bool isOnline = GlobalUserStateManager().isOnline;
    print('是否在线1：$isOnline');
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (timeStamp) {
    //     bool isOnline2 = GlobalUserStateManager().isOnline;
    //     print('是否在线2：$isOnline2');
    //     if (mounted) {
    //       setState(() {
    //         bool isOnline3 = GlobalUserStateManager().isOnline;
    //         print('是否在线3：$isOnline3');
    //       });
    //     }
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    bool isOnline4 = GlobalUserStateManager().isOnline;
    print('是否在线4：$isOnline4');
    return Scaffold(
      appBar: AppBar(
        title: const Text("全局单利2"),
      ),
      body: Center(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text("在线状态: ${isOnline4 ? '在线' : '不在线'}"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                GlobalUserStateManager().isOnline = !GlobalUserStateManager().isOnline;
                print('在线状态: ${GlobalUserStateManager().isOnline ? '在线' : '不在线'}');
                if (mounted) {
                  setState(() {});
                }
              },
              child: Text(isOnline4 ? '开始下线' : '开始上线'),
            ),
            ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamed('globalSingletonStatePage', pageType: PageType.newEngine);
              },
              child: const Text('打开新引擎'),
            ),
            ElevatedButton(
              onPressed: () {
                if (mounted) {
                  setState(() {});
                }
              },
              child: const Text('刷新'),
            ),
            ElevatedButton(
              onPressed: () {
                MeteorNavigator.pop();
              },
              child: const Text('返回上一个'),
            ),
            ElevatedButton(
              onPressed: () {
                MeteorNavigator.popToRoot();
              },
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }
}
