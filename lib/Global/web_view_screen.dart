import 'dart:io';

import 'package:flutter/material.dart';
import 'package:heal_u/service/http_service/http_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;
  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url
                .startsWith('${HttpService.API_BASE_URL_BASE}order-success')) {
              print('--------------blocking navigation to $request}');
              Navigator.pop(context, true);
              return NavigationDecision.prevent;
            }
            if (request.url
                .startsWith('${HttpService.API_BASE_URL_BASE}order-failed')) {
              print('--------------blocking navigation to $request}');
              Navigator.pop(context);
              return NavigationDecision.prevent;
            }
            print('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
