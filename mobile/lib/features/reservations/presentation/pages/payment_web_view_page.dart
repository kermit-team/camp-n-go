import 'dart:developer';

import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String paymentUrl;
  final Function(String) onPaymentResult;

  const PaymentWebViewPage({
    super.key,
    required this.paymentUrl,
    required this.onPaymentResult,
  });

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            log('Navigating to" ${request.url}');
            if (request.url.startsWith('myApp://')) {
              widget.onPaymentResult(request.url);
              serviceLocator<GoRouter>().pop();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return AppBody(
      child: WebViewWidget(controller: _controller),
    );
  }
}
