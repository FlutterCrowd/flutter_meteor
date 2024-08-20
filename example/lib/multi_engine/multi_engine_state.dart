import 'package:flutter/cupertino.dart';
import 'package:flutter_meteor/flutter_meteor.dart';

class GlobalStateService extends ChangeNotifier {
  String eventName = 'GlobalStateChanged';
  GlobalStateService() {
    fetchState();
    MeteorEventBus.addListener(
      eventName: eventName,
      listener: (dynamic data) {
        if (data is String) {
          _updateCurrentEngineState(data);
        }
      },
    );
  }
  String _sharedState = "Initial State";
  String get sharedState => _sharedState;

  // Fetch state from native platform
  Future<void> fetchState() async {
    final String? state = await SharedCache.getString('state');
    _updateCurrentEngineState(state ?? 'Initial State');
  }

  // Update state on both Flutter and native platform
  Future<void> updateState(String newState) async {
    // _updateCurrentEngineState(newState);
    await SharedCache.setString('state', newState);
    MeteorEventBus.commit(eventName: eventName, data: newState);
  }

  void _updateCurrentEngineState(String newState) {
    _sharedState = newState;
    notifyListeners();
  }
}
