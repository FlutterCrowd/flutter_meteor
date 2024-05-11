import 'package:flutter/material.dart';
import 'package:hz_router/hz_router.dart';

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
        child: GestureDetector(
          onTap: () {
            HzNavigator.dismiss();
          },
          child: Container(
            width: 200,
            height: 200,
            color: Colors.yellow,
            child: const Text('我是透明弹窗, 点我就返回'),
          ),
        ),
      ),
    );
  }
}
