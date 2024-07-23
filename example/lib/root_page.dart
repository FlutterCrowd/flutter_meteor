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
            MeteorNavigator.pushNamed("home");
          },
          child: const Center(
            child: Text('首页'),
          ),
        ),
        GestureDetector(
          onTap: () {
            MeteorNavigator.pop({'params': '回传'});
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
