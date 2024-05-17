import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class PopWindowPage extends StatelessWidget {
  const PopWindowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        // color: Colors.black.withOpacity(0.6),
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                MeteorNavigator.dismiss();
              },
              child: Container(
                width: 200,
                height: 200,
                color: Colors.yellow,
                child: const Text('我是透明弹窗, 点我就返回'),
              ),
            ),
            GestureDetector(
              onTap: () {
                MeteorNavigator.pushNamed('multi_engin2');
              },
              child: Container(
                width: 200,
                height: 200,
                color: Colors.yellow,
                child: const Text('下一页'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
