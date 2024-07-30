import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final widget = Column(
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
            MeteorNavigator.pushNamed("push_native", openNative: true);
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
            MeteorNavigator.pushNamed("multiEnginePage2", withNewEngine: true);
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
            MeteorNavigator.pushNamed("popWindowPage",
                withNewEngine: true, newEngineOpaque: false, present: true);
          },
          child: const Center(
            child: Text('弹出一个弹窗'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pushNamed("bottomSheetPage",
                withNewEngine: true, newEngineOpaque: false, present: true);
          },
          child: const Center(
            child: Text('弹出一个底部弹窗'),
          ),
        ),
        Expanded(child: Container()),
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
