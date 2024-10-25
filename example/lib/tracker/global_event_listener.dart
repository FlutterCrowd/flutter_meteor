// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
//
// class GlobalEventListener extends StatefulWidget {
//   final Widget child;
//   final void Function(PointerEvent event) onEvent;
//
//   const GlobalEventListener({
//     Key? key,
//     required this.child,
//     required this.onEvent,
//   }) : super(key: key);

//   @override
//   State<GlobalEventListener> createState() => _GlobalEventListenerState();
// }
//
// class _GlobalEventListenerState extends State<GlobalEventListener> with WidgetsBindingObserver {
//   // 注册监听器
//   @override
//   void initState() {
//     super.initState();
//     GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
//   }
//
//   // 取消监听器
//   @override
//   void dispose() {
//     GestureBinding.instance.pointerRouter.removeGlobalRoute(_handlePointerEvent);
//     super.dispose();
//   }
//
//   // 处理手势事件
//   // void _handlePointerEvent(PointerEvent event) {
//   //   widget.onEvent(event); // 将事件回调给使用者
//   // }
//   void _handlePointerEvent(PointerEvent event) {
//     if (event is PointerDownEvent) {
//       print("PointerDownEvent: 手指按下");
//     } else if (event is PointerMoveEvent) {
//       print("PointerMoveEvent: 手指移动");
//     } else if (event is PointerUpEvent) {
//       print("PointerUpEvent: 手指抬起");
//       widget.onEvent(event); // 将事件回调给使用者
//     } else if (event is PointerCancelEvent) {
//       print("PointerCancelEvent: 事件取消");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.child; // 返回子组件
//   }
// }

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GlobalEventListener extends StatefulWidget {
  final Widget child;
  final void Function(PointerEvent event) onEvent;

  const GlobalEventListener({
    Key? key,
    required this.child,
    required this.onEvent,
  }) : super(key: key);
  @override
  _GlobalEventListenerState createState() => _GlobalEventListenerState();
}

class _GlobalEventListenerState extends State<GlobalEventListener> {
  @override
  void initState() {
    super.initState();
    // 绑定全局监听器
    GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);
  }

  @override
  void dispose() {
    // 取消全局监听器
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_handlePointerEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _handlePointerEvent(PointerEvent event) {
    if (event is PointerDownEvent) {
      // 执行命中测试，找到对应的 RenderObject
      final hitTestResult = HitTestResult();
      GestureBinding.instance.hitTestInView(hitTestResult, event.position, event.viewId);

      // final targetRenderObject = hitTestResult.path.first.target;
      // if (targetRenderObject is RenderObject) {
      //   final widget = _findWidgetFromRenderObject(targetRenderObject);
      //   if (widget != null) {
      //     print("命中 Widget: ${widget.runtimeType}");
      //   }
      //
      //   final route = _findRouteFromContext(targetRenderObject);
      //   if (route != null) {
      //     print("命中页面 Route: ${route.settings.name}");
      //   }
      // }
      for (final hit in hitTestResult.path) {
        final targetRenderObject = hit.target;
        if (targetRenderObject is RenderObject) {
          final widget = _findWidgetFromRenderObject(targetRenderObject);
          if (widget != null) {
            // print("命中 Widget: ${widget.runtimeType}");
            // 判断点击的是 ElevatedButton 还是 GestureDetector
            if (widget is ElevatedButton) {
              print("命中 Widget: ElevatedButton");
            } else if (widget is GestureDetector) {
              print("命中 Widget: GestureDetector");
            } else {
              // print("命中 Widget: ${widget.runtimeType}");
            }
          }

          final route = _findRouteFromContext(targetRenderObject);
          if (route != null) {
            print("命中页面 Route: ${route.settings.name}");
          }
        }
      }
    }
  }

  // 通过 RenderObject 找到对应的 Widget
  Widget? _findWidgetFromRenderObject(RenderObject renderObject) {
    if (renderObject.debugCreator != null) {
      final debugCreator = renderObject.debugCreator;
      if (debugCreator is DebugCreator) {
        final element = debugCreator.element;
        return element.widget;
      }
    }
    return null;
  }

  // 通过 RenderObject 的 context 找到对应的 Route 页面
  ModalRoute? _findRouteFromContext(RenderObject renderObject) {
    if (renderObject.debugCreator != null) {
      final debugCreator = renderObject.debugCreator;
      if (debugCreator is DebugCreator) {
        final element = debugCreator.element;
        return ModalRoute.of(element);
      }
    }
    return null;
  }
}
