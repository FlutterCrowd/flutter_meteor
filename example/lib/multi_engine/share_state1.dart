import 'package:flutter/material.dart';
import 'package:flutter_meteor/flutter_meteor.dart';
import 'package:hz_router_plugin_example/main.dart';
import 'package:provider/provider.dart';

import 'multi_engine_state.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalStateService = Provider.of<GlobalStateService>(context);
    final MeteorStringProvider stringProvider = Provider.of<MeteorStringProvider>(context);
    final MeteorBoolProvider boolProvider = Provider.of<MeteorBoolProvider>(context);
    final MeteorDoubleProvider doubleProvider = Provider.of<MeteorDoubleProvider>(context);
    final MeteorIntProvider intProvider = Provider.of<MeteorIntProvider>(context);
    final MeteorListProvider listProvider = Provider.of<MeteorListProvider>(context);
    final MeteorMapProvider mapProvider = Provider.of<MeteorMapProvider>(context);
    final MeteorModelProvider<UserInfo> modelProvider =
        Provider.of<MeteorModelProvider<UserInfo>>(context);
    final MeteorBytesProvider bytesProvider = Provider.of<MeteorBytesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("First Screen"),
      ),
      body: Center(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
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
            ElevatedButton(
              onPressed: () {
                stringProvider.updateState('新的字符串');
              },
              child: Text("点击更新多引擎共享String：${stringProvider.sharedState ?? '旧的'}"),
            ),
            ElevatedButton(
              onPressed: () {
                boolProvider.updateState(true);
              },
              child: Text("点击更新多引擎共享Bool：${boolProvider.sharedState ?? false}"),
            ),
            ElevatedButton(
              onPressed: () {
                intProvider.updateState(123);
              },
              child: Text("点击更新多引擎共享Int：${intProvider.sharedState ?? 0}"),
            ),
            ElevatedButton(
              onPressed: () {
                doubleProvider.updateState(2.0);
              },
              child: Text("点击更新多引擎共享Double：${doubleProvider.sharedState ?? 1.0}"),
            ),
            ElevatedButton(
              onPressed: () {
                listProvider.updateState([1, 2, 3]);
              },
              child: Text("点击更新多引擎共享List：${listProvider.sharedState ?? []}"),
            ),
            ElevatedButton(
              onPressed: () {
                mapProvider.updateState({'key': 'value'});
              },
              child: Text("点击更新多引擎共享Map：${mapProvider.sharedState ?? {}}"),
            ),
            ElevatedButton(
              onPressed: () {
                modelProvider.updateWithModel(UserInfo(
                  name: 'name1',
                  phone: '18123248832',
                  gender: 2,
                ));
              },
              child: Text("点击更新多引擎共享Map：${modelProvider.model.toJson()}"),
            ),
            ElevatedButton(
              onPressed: () {
                bytesProvider.updateState([12314, 14124, 1214]);
              },
              child: Text("点击更新多引擎共享bytes：${bytesProvider.sharedState ?? []}"),
            ),
          ],
        ),
      ),
    );
  }
}
