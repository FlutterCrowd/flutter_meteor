import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// 全局埋点管理器
class EventTracker {
  static EventTracker? _instance;
  final List<Map<String, dynamic>> _eventCache = []; // 缓存事件
  Timer? _uploadTimer;

  EventTracker._internal() {
    _startEventListener();
    _startUploadTimer();
  }

  // 单例模式，确保埋点管理器全局唯一
  static void initialize() {
    _instance ??= EventTracker._internal();
  }

  // 监听所有触摸事件
  void _startEventListener() {
    GestureBinding.instance.pointerRouter.addGlobalRoute((PointerEvent event) {
      if (event is PointerDownEvent) {
        _trackEvent('click', event.position);
      } else if (event is PointerMoveEvent) {
        _trackEvent('swipe', event.position);
      }
    });
  }

  // 捕获并存储事件
  void _trackEvent(String eventType, Offset position) {
    final event = {
      'event_type': eventType,
      'position': position.toString(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'page': ModalRoute.of(_instance!.context!)?.settings.name,
    };
    _eventCache.add(event);
    print('Event captured: $event');
  }

  // 启动定时器，定期上报数据
  void _startUploadTimer() {
    _uploadTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      _uploadEvents();
    });
  }

  // 模拟上报数据到服务器
  void _uploadEvents() {
    if (_eventCache.isNotEmpty) {
      print('Uploading ${_eventCache.length} events to server');
      _eventCache.clear();
    }
  }

  // 清理定时器
  void dispose() {
    _uploadTimer?.cancel();
  }

  // 上下文引用，便于获取页面名称等信息
  BuildContext? context;
}

// 全局导航观察器，用于监听页面切换事件
class PageRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    EventTracker._instance?.context = null;
    print('Pushed to ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    EventTracker._instance?.context = null;
    print('Popped from ${route.settings.name}');
  }
}
