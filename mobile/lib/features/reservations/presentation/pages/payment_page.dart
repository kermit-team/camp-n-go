import 'dart:async';

import 'package:campngo/config/routes/app_routes.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String paymentUrl;

  const PaymentPage({
    super.key,
    required this.paymentUrl,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController _controller;
  final Completer<WebViewController> _webViewControllerCompleter =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('your-app://payment-success')) {
              //todo: Extract information from the URL (e.g., payment ID)
              final uri = Uri.parse(request.url);
              final paymentId = uri.queryParameters['paymentId'];
              // Navigate to the success page with the payment ID
              context.go(
                AppRoutes.paymentSuccess.route,
                extra: {'paymentId': paymentId},
              );
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith('your-app://payment-failure')) {
              //todo: Extract information from the URL (e.g., error code)
              final uri = Uri.parse(request.url);
              final errorCode = uri.queryParameters['errorCode'];
              //todo: Navigate to the failure page with the error code
              context.go(
                AppRoutes.paymentFailure.route,
                extra: {'errorCode': errorCode},
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
    _webViewControllerCompleter.complete(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AppBody(
      titleText: LocaleKeys.payment.tr(),
      child: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
