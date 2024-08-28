import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class RouteTypePage extends StatelessWidget {
  const RouteTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    final widget = ListView(
      children: [
        ElevatedButton(
          onPressed: () async {
            MeteorNavigator.pushNamed("multiEnginePage");
          },
          child: const Center(
            child: Text('打开flutter页面'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed(
              "push_native",
              pageType: MeteorPageType.native,
            );
          },
          child: const Center(
            child: Text('打开原生页面'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed(
              "multiEnginePage",
              pageType: MeteorPageType.newEngine,
            );
          },
          child: const Center(
            child: Text('打开新引擎'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed(
              "popWindowPage",
              isOpaque: false,
              pageType: MeteorPageType.newEngine,
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
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed(
              "dialogWindowPage",
              isOpaque: false,
            );
          },
          child: const Center(
            child: Text('弹出一个弹窗-dialog'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed(
              "bottomSheetPage",
              pageType: MeteorPageType.newEngine,
              isOpaque: false,
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
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed('materialPageRoute');
          },
          child: const Center(
            child: Text('materialPageRoute'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed('cupertinoPageRoute');
          },
          child: const Center(
            child: Text('cupertinoPageRoute'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed("customPageRoute");
          },
          child: const Center(
            child: Text('customPageRoute'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed("standardPageRoute_ltr");
          },
          child: const Center(
            child: Text('standardPageRoute_ltr'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed("standardPageRoute_rtl");
          },
          child: const Center(
            child: Text('standardPageRoute_rtl'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed("standardPageRoute_top");
          },
          child: const Center(
            child: Text('standardPageRoute_top'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed("standardPageRoute_bottom");
          },
          child: const Center(
            child: Text('standardPageRoute_bottom'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed("standardPageRoute_fadeIn");
          },
          child: const Center(
            child: Text('standardPageRoute_fadeIn'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed(
              "webViewPage",
              arguments: {'url': 'https://www.baidu.com'},
            );
          },
          child: const Center(
            child: Text('webViewPage'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            MeteorNavigator.pushNamed(
              "UnknownPage",
            );
          },
          child: const Center(
            child: Text('Unknown page'),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('导航测试'),
      ),
      body: Stack(
        children: [
          widget,
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: PerformanceOverlay.allEnabled(),
          // )
        ],
      ),
    );
  }
}
