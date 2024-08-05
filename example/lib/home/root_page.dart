import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final widget = ListView(
      children: [
        Expanded(child: Container()),
        GestureDetector(
          onTap: () async {
            MeteorNavigator.pushNamed("multiEnginePage2");
          },
          child: const Center(
            child: Text('下一flutter页面'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed(
              "push_native",
              openNative: true,
            );
          },
          child: const Center(
            child: Text('下一个原生页面'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed(
              "multiEnginePage2",
              withNewEngine: true,
            );
          },
          child: const Center(
            child: Text('打开新引擎'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed(
              "popWindowPage",
              newEngineOpaque: false,
              withNewEngine: true,
              present: true,
            );
          },
          child: const Center(
            child: Text('弹出一个弹窗-新引擎'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed(
              "dialogWindowPage",
              newEngineOpaque: false,
            );
          },
          child: const Center(
            child: Text('弹出一个弹窗-dialog'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed(
              "bottomSheetPage",
              withNewEngine: true,
              newEngineOpaque: false,
              present: true,
            );
          },
          child: const Center(
            child: Text('弹出一个底部弹窗'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed('materialPageRoute');
          },
          child: const Center(
            child: Text('materialPageRoute'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed('cupertinoPageRoute');
          },
          child: const Center(
            child: Text('cupertinoPageRoute'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed("customPageRoute");
          },
          child: const Center(
            child: Text('customPageRoute'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed("standardPageRoute_ltr");
          },
          child: const Center(
            child: Text('standardPageRoute_ltr'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed("standardPageRoute_rtl");
          },
          child: const Center(
            child: Text('standardPageRoute_rtl'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed("standardPageRoute_top");
          },
          child: const Center(
            child: Text('standardPageRoute_top'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed("standardPageRoute_bottom");
          },
          child: const Center(
            child: Text('standardPageRoute_bottom'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed("standardPageRoute_fadeIn");
          },
          child: const Center(
            child: Text('standardPageRoute_fadeIn'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed(
              "webViewPage",
              arguments: {'url': 'https://www.baidu.com'},
            );
          },
          child: const Center(
            child: Text('webViewPage'),
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('ROOT'),
      ),
      body: widget,
    );
  }
}
