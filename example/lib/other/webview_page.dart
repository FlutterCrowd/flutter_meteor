import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef ProgressCallback = void Function(int progress);

class WebViewPage extends StatefulWidget {
  const WebViewPage({
    super.key,
    required this.url,
    this.title,
    this.showLoading = true,
    this.showProgress = true,
    this.backgroundColor,
    this.javaScriptMode,
    this.onNavigationRequest,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.onWebResourceError,
    this.onUrlChange,
    this.onHttpAuthRequest,
    this.onHttpError,
  });

  final String url;
  final String? title;
  final bool showProgress;
  final bool showLoading;
  final Color? backgroundColor;
  final JavaScriptMode? javaScriptMode;
  final FutureOr<NavigationDecision> Function(NavigationRequest request)? onNavigationRequest;
  final void Function(String url)? onPageStarted;
  final void Function(String url)? onPageFinished;
  final void Function(int progress)? onProgress;
  final void Function(WebResourceError error)? onWebResourceError;
  final void Function(UrlChange change)? onUrlChange;
  final void Function(HttpAuthRequest request)? onHttpAuthRequest;
  final void Function(HttpResponseError error)? onHttpError;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _webViewController; //WebView控制类
  final ValueNotifier<double> _progressNotifier = ValueNotifier(0.0);
  // ValueListenable<double> get valueListenable => _progressNotifier;
  final ValueNotifier<bool> _loadingNotifier = ValueNotifier(true);
  @override
  void initState() {
    super.initState();
    _setupController();
  }

  @override
  void dispose() {
    _loadingNotifier.dispose();
    _progressNotifier.dispose();
    super.dispose();
  }

  void _setupController() {
    _webViewController = WebViewController();
    _webViewController.setBackgroundColor(
      widget.backgroundColor ?? const Color(0xFFF7F7F7),
    );
    _webViewController.setJavaScriptMode(
      widget.javaScriptMode ?? JavaScriptMode.unrestricted,
    );
    _webViewController.loadRequest(Uri.parse(widget.url));
    _webViewController.setNavigationDelegate(_navigationDelegate());
  }

  NavigationDelegate _navigationDelegate() {
    return NavigationDelegate(
      onNavigationRequest: widget.onNavigationRequest ??
          (NavigationRequest request) {
            if (request.url.startsWith('http')) {
              return NavigationDecision.navigate;
            } else {
              return NavigationDecision.prevent;
            }
          },
      onProgress: (progress) {
        _progressNotifier.value = progress / 100.0;
        widget.onProgress?.call(progress);
      },
      onPageStarted: (url) {
        _loadingNotifier.value = true;
        widget.onPageStarted?.call(url);
      },
      onPageFinished: (url) {
        _loadingNotifier.value = false;
        widget.onPageFinished?.call(url);
      },
      onUrlChange: widget.onUrlChange,
      onHttpAuthRequest: widget.onHttpAuthRequest,
      onHttpError: (error) {
        if (kDebugMode) {
          print('Webview laoding error: $error');
        }
        _loadingNotifier.value = false;
        widget.onHttpError?.call(error);
      },
      onWebResourceError: widget.onWebResourceError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _webViewController,
          ),
          if (widget.showProgress)
            ValueListenableBuilder(
              valueListenable: _progressNotifier,
              builder: (ctx, progress, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: progress >= 1.0
                      ? const SizedBox()
                      : _buildProgressBar(
                          progress,
                          context,
                        ),
                );
              },
            ),
          if (widget.showLoading)
            ValueListenableBuilder(
              valueListenable: _loadingNotifier,
              builder: (ctx, loading, child) {
                return loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const SizedBox();
              },
            )
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress, BuildContext context) {
    return SizedBox(
      height: 1,
      child: LinearProgressIndicator(
        backgroundColor: Colors.blueAccent.withOpacity(0),
        value: progress,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.lightBlue),
      ),
    );
  }
}
