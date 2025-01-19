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
            if (request.url
                .startsWith('http://localhost:4200/payment/success')) {
              context.go(
                AppRoutes.paymentSuccess.route,
              );
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith('your-app://payment-failure')) {
              final uri = Uri.parse(request.url);
              final errorCode = uri.queryParameters['errorCode'];

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
      scrollable: false,
      enablePadding: false,
      child: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
