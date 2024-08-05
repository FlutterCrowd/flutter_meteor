import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class BottomSheetPage extends StatelessWidget {
  const BottomSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      // color: Colors.transparent,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              print('点我就返回');
              MeteorNavigator.pop();
            },
            child: Container(
              width: 200,
              height: 200,
              color: Colors.yellow,
              alignment: Alignment.center,
              child: const Text('我是透明底部弹窗, 点我就返回'),
            ),
          ),
          GestureDetector(
            onTap: () {
              MeteorNavigator.pushNamed('multiEnginePage2');
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
    );
  }
}
