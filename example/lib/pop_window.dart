import 'package:flutter/material.dart';

class PopWindowPage extends StatelessWidget {
  const PopWindowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black.withOpacity(0.6),
        alignment: Alignment.center,
        child: Container(
          width: 200,
          height: 200,
          color: Colors.yellow,
          child: const Text('我是透明弹窗'),
        ),
      ),
    );
  }
}
