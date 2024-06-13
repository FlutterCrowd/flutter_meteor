import 'package:flutter/services.dart';
import 'package:flutter_meteor/channel/channel.dart';
import 'package:flutter_meteor/engine/engine.dart';
import 'package:hz_tools/hz_tools.dart';

import '../channel/channel_method.dart';

typedef MeteorEventBusListener = void Function(dynamic arguments);

class MeteorEventBus {
  // 工厂方法构造函数 - 通过UserModel()获取对象
  factory MeteorEventBus() => _getInstance();

  // instance的getter方法 - 通过UserModel.instance获取对象2
  static MeteorEventBus get instance => _getInstance();

  // 静态变量_instance，存储唯一对象
  static MeteorEventBus? _instance;

  // 获取唯一对象
  static MeteorEventBus _getInstance() {
    _instance ??= MeteorEventBus._internal();
    return _instance!;
  }

  //初始化...
  MeteorEventBus._internal() {
    //初始化其他操作...
    _pluginPlatform = MeteorMethodChannel();
  }

  late MeteorMethodChannel _pluginPlatform;

  MethodChannel get methodChannel => _pluginPlatform.methodChannel;

  final Map<String, List<MeteorEventBusListener>> _listenerMap = {};

  /// 添加订阅者-接收事件
  static void addListener({required String eventName, required MeteorEventBusListener listener}) {
    HzLog.t(
        'MeteorEventBus addListener isMain:${MeteorEngine.isMain} eventName:$eventName, listener:$listener');
    var list = instance._listenerMap[eventName];
    list ??= <MeteorEventBusListener>[];
    list.add(listener);
    instance._listenerMap[eventName] = list;
  }

  /// 移除订阅者-结束事件
  /// 当listener 为空时会移除eventName的所有listener，因此慎用
  static void removeListener({required String eventName, MeteorEventBusListener? listener}) {
    HzLog.t(
        'MeteorEventBus removeListener isMain:${MeteorEngine.isMain} eventName:$eventName, listener:$listener');
    var list = instance._listenerMap[eventName];
    if (eventName.isEmpty || list == null) return;
    if (listener == null) {
      instance._listenerMap.remove(eventName);
    } else {
      list.remove(listener);
    }
  }

  /// 已加订阅者-发送事件
  /// eventName 事件名称
  /// withMultiEngine 是否发送多引擎，默认true表示支持多引擎
  /// data 传送的数据
  static void commit({required String eventName, bool? withMultiEngine = true, dynamic data}) {
    HzLog.t(
        'MeteorEventBus commit isMain:${MeteorEngine.isMain} eventName:$eventName, data:$data, withMultiEngine:$withMultiEngine');
    if (withMultiEngine == true) {
      /// 多引擎则交给原生处理
      commitToMultiEngine(eventName: eventName, data: data);
    } else {
      /// 如果只支持当前引擎则直接调用
      commitToCurrentEngine(eventName: eventName, data: data);
    }
  }

  static void commitToCurrentEngine({required String eventName, dynamic data}) {
    var list = instance._listenerMap[eventName];
    HzLog.t(
        'MeteorEventBus commitToCurrentEngine isMain:${MeteorEngine.isMain} eventName:$eventName, data:$data, listeners:$list');
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
    HzLog.d(
        'MeteorEventBus commitToMultiEngine isMain:${MeteorEngine.isMain} eventName:$eventName, data:$data');

    /// 如果支持多引擎则交给原生处理
    Map<String, dynamic> methodArguments = {};
    methodArguments['eventName'] = eventName;
    methodArguments['arguments'] = data;
    final result = await instance.methodChannel
        .invokeMethod(MeteorChannelMethod.multiEngineEventCallMethod, methodArguments);
    HzLog.t('MeteorEventBus commitToMultiEngine isMain:${MeteorEngine.isMain} result:$result');
    return result;
  }

  static List<MeteorEventBusListener>? listenersForEvent(String eventName) {
    HzLog.t('MeteorEventBus isMain:${MeteorEngine.isMain} allListeners:${instance._listenerMap}');
    var list = instance._listenerMap[eventName];
    HzLog.d('MeteorEventBus isMain:${MeteorEngine.isMain} eventName:$eventName, listeners $list');
    return list;
  }
}
