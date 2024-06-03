import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meteor/channel/channel.dart';

import '../channel/channel_method.dart';

typedef MeteorEventBusListener = void Function(dynamic arguments);

class MeteorEventBus {
  static final MeteorMethodChannel _pluginPlatform = MeteorMethodChannel();

  static MethodChannel get methodChannel => _pluginPlatform.methodChannel;

  static final Map<String, List<MeteorEventBusListener>> _listenerMap = {};

  /// 添加订阅者-接收事件
  static void addListener({required String eventName, required MeteorEventBusListener listener}) {
    _listenerMap[eventName] ??= <MeteorEventBusListener>[];
    _listenerMap[eventName]?.add(listener);
  }

  /// 移除订阅者-结束事件
  /// 当listener 为空时会移除eventName的所有listener，因此慎用
  static void removeListener({required String eventName, MeteorEventBusListener? listener}) {
    var list = _listenerMap[eventName];
    if (eventName.isEmpty || list == null) return;
    if (listener == null) {
      _listenerMap.remove(eventName);
    } else {
      list.remove(listener);
    }
  }

  /// 已加订阅者-发送事件
  /// eventName 事件名称
  /// withMultiEngine 是否发送多引擎，默认true表示支持多引擎
  /// data 传送的数据
  static void commit({required String eventName, bool? withMultiEngine = true, dynamic data}) {
    debugPrint(
        'MeteorEventBus commit eventName:$eventName, data:$data, withMultiEngine:$withMultiEngine');
    if (withMultiEngine == true) {
      /// 多引擎则交给原生处理
      commitToMultiEngine(eventName: eventName, data: data);
    } else {
      /// 如果只支持当前引擎则直接调用
      commitToCurrentEngine(eventName: eventName, data: data);
    }
  }

  static void commitToCurrentEngine({required String eventName, dynamic data}) {
    var list = _listenerMap[eventName];
    debugPrint(
        'MeteorEventBus commitToMultiEngine eventName:$eventName, data:$data, listeners:$list');
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止在订阅者在回调中移除自身带来的下标错位
    if (list.isNotEmpty) {
      for (var i = len; i > -1; --i) {
        MeteorEventBusListener listener = list[i];
        listener.call(data);
      }
    }
  }

  static Future<dynamic> commitToMultiEngine({required String eventName, dynamic data}) async {
    debugPrint('MeteorEventBus commitToMultiEngine eventName:$eventName, data:$data');

    /// 如果支持多引擎则交给原生处理
    Map<String, dynamic> methodArguments = {};
    methodArguments['eventName'] = eventName;
    methodArguments['arguments'] = data;
    final result = await methodChannel.invokeMethod(
        MeteorChannelMethod.multiEngineEventCallMethod, methodArguments);
    debugPrint(result);
    return result;
  }

  static List<MeteorEventBusListener>? listenersForEvent(String eventName) {
    var list = _listenerMap[eventName];
    return list;
  }
}
