import 'package:flutter/material.dart';
import 'package:hz_router/hz_router.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final widget = Column(
      children: [
        Expanded(child: Container()),
        GestureDetector(
          onTap: () {
            HzNavigator.pushNamed("home");
          },
          child: const Center(
            child: Text('首页'),
          ),
        ),
        GestureDetector(
          onTap: () {
            HzNavigator.pop();
          },
          child: const Center(
            child: Text('返回上一页'),
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
