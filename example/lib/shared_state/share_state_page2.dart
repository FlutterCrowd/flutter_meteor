import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';
import 'package:provider/provider.dart';

import 'multi_engine_state.dart';

class ShareStatePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalStateService = Provider.of<GlobalStateService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Shared State: ${globalStateService.sharedState}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                globalStateService.updateState("Updated from Second Screen");
              },
              child: Text("Update State"),
            ),
            ElevatedButton(
              onPressed: () {
                MeteorNavigator.pushNamed(
                  "shareStatePage1",
                  pageType: MeteorPageType.newEngine,
                );
              },
              child: Text("打开新引擎"),
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
