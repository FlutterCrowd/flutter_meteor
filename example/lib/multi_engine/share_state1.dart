import 'package:flutter/material.dart';
import 'package:flutter_meteor/navigator/navigator.dart';
import 'package:provider/provider.dart';

import 'multi_engine_state.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalStateService = Provider.of<GlobalStateService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("First Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Shared State: ${globalStateService.sharedState}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                globalStateService.updateState("Updated from First Screen");
              },
              child: Text("Update State"),
            ),
            ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamed(
                  "shareState2",
                  withNewEngine: true,
                );
              },
              child: Text("打开新引擎shareState2"),
            ),
            ElevatedButton(
              onPressed: () {
                MeteorNavigator.pop();
              },
              child: Text("返回"),
            ),
          ],
        ),
      ),
    );
  }
}
