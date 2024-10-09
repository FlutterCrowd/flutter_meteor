import 'package:flutter/services.dart';
import 'package:hz_tools/hz_tools.dart';

typedef MeteorEventBusListener = void Function(dynamic arguments);

class MeteorEventBusListenerItem {
  final String? listenerId;
  final MeteorEventBusListener listener;

  MeteorEventBusListenerItem(this.listenerId, this.listener);
}

class MeteorEventBus {
  final BasicMessageChannel methodChannel =
      const BasicMessageChannel('itbox.meteor.multiEnginEventChannel', StandardMessageCodec());

  // 工厂方法构造函数 - 通过MeteorEventBus()获取对象
  factory MeteorEventBus() => _getInstance();

  // instance的getter方法 - 通过MeteorEventBus.instance获取对象2
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
    // _pluginPlatform = MeteorMethodChannel();

    methodChannel.setMessageHandler(
      (message) async {
        HzLog.d('收到来自原生的通知message:$message');
        receiveEvent(message);
      },
    );
  }

  final Map<String, List<MeteorEventBusListenerItem>> _listenerMap = {};

  /// 添加订阅者-开始事件
  /// eventName 事件名称
  /// listenerId 可选，监听者id，用于移除监听者
  /// listener 监听者
  static void addListener(
      {required String eventName, String? listenerId, required MeteorEventBusListener listener}) {
    // HzLog.t(
    // 'MeteorEventBus addListener isMain:${MeteorEngine.isMain} eventName:$eventName, listener:$listener');
    var list = instance._listenerMap[eventName];
    list ??= <MeteorEventBusListenerItem>[];
    list.add(MeteorEventBusListenerItem(listenerId, listener));
    instance._listenerMap[eventName] = list;
  }

  ///  移除订阅者-结束事件
  ///  listenerId 可选，监听者id，用于移除监听者
  ///  listener 可选，监听者
  ///  备注： 如果listenerId和listener都为空，则移除eventName下的所有监听者
  static void removeListener(
      {required String eventName, String? listenerId, MeteorEventBusListener? listener}) {
    // HzLog.t(
    // 'MeteorEventBus removeListener isMain:${MeteorEngine.isMain} eventName:$eventName, listener:$listener');
    var list = instance._listenerMap[eventName];
    if (eventName.isEmpty || list == null) return;

    if (listenerId == null && listener == null) {
      list.clear();
    } else {
      if (listenerId != null) {
        list.removeWhere(
          (element) => element.listenerId == listenerId,
        );
      }
      if (listener != null) {
        list.removeWhere(
          (element) => element.listener == listener,
        );
      }
    }
    instance._listenerMap[eventName] = list;
  }

  /// 已加订阅者-发送事件
  /// eventName 事件名称
  /// withMultiEngine 是否发送多引擎，默认true表示支持多引擎
  /// data 传送的数据
  static void commit({required String eventName, bool? withMultiEngine = true, dynamic data}) {
    // HzLog.t(
    // 'MeteorEventBus commit isMain:${MeteorEngine.isMain} eventName:$eventName, data:$data, withMultiEngine:$withMultiEngine');
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
    // HzLog.t(
    // 'MeteorEventBus commitToCurrentEngine isMain:${MeteorEngine.isMain} eventName:$eventName, data:$data, listeners:$list');
    if (list == null) return;
    int len = list.length - 1;
    //反向遍历，防止在订阅者在回调中移除自身带来的下标错位
    if (list.isNotEmpty) {
      for (var i = len; i > -1; --i) {
        MeteorEventBusListener listener = list[i].listener;
        listener.call(data);
      }
    }
  }

  static Future<dynamic> commitToMultiEngine({required String eventName, dynamic data}) async {
    // HzLog.d(
    //     'MeteorEventBus commitToMultiEngine isMain:${MeteorEngine.isMain} eventName:$eventName, data:$data');

    /// 如果支持多引擎则交给原生处理
    Map<String, dynamic> methodArguments = {};
    methodArguments['eventName'] = eventName;
    methodArguments['data'] = data;
    // final result = await instance.methodChannel
    //     .invokeMethod(MeteorChannelMethod.multiEngineEventCallMethod, methodArguments);
    final result = await instance.methodChannel.send(methodArguments);
    // HzLog.t('MeteorEventBus commitToMultiEngine isMain:${MeteorEngine.isMain} result:$result');
    return result;
  }

  static void receiveEvent(dynamic event) {
    if (event is Map) {
      final eventMap = event;
      final eventName = event['eventName'];
      // HzLog.t('MeteorEventBus isMain:${MeteorEngine.isMain} allListeners:${instance._listenerMap}');
      var list = instance._listenerMap[eventName];
      list?.forEach((listenerItem) {
        listenerItem.listener.call(eventMap['data']);
      });
      // HzLog.d('MeteorEventBus isMain:${MeteorEngine.isMain} eventName:$eventName, listeners $list');
    }
  }
}
