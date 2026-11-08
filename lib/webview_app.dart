import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key, required this.url});

  static const String routeName = '/webview';

  final String url;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String _pageTitle = "Loading...";

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String _) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String _) async {
            String? title = await _controller.getTitle();
            if (mounted) {
              setState(() {
                _isLoading = false;
                _pageTitle = title ?? "Bamboo";
              });
            }
          },
          onWebResourceError: (WebResourceError _) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _pageTitle = "Error";
              });
            }

            Get.snackbar(
              "Error",
              "Could not load page. Please try again.",
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          onNavigationRequest: (NavigationRequest _) =>
              NavigationDecision.navigate,
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoading ? "Loading..." : _pageTitle,
            style: const TextStyle(fontSize: 16)),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))),
            )
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
