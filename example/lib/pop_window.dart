import 'package:flutter/material.dart';

class PopWindowPage extends StatelessWidget {
  const PopWindowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 300,
        height: 200,
        color: Colors.yellow,
        child: const Text('我是透明弹窗'),
      ),
    );
  }
}
