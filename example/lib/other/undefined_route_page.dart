import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UndefinedRoutePage extends StatefulWidget {
  const UndefinedRoutePage({super.key});
  @override
  State<StatefulWidget> createState() {
    return UndefinedRoutePageState();
  }
}

class UndefinedRoutePageState extends State<UndefinedRoutePage> {
  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(msg: '未找到路由', gravity: ToastGravity.CENTER);
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        MeteorNavigator.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // color: Colors.black.withOpacity(0.6),
        color: Colors.transparent,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            MeteorNavigator.pop();
          },
          child: Text('点击返回'),
        ),
      ),
    );
  }
}
