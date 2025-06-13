import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';

import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class DetailPaymentPage extends StatefulWidget {
  final String paymentUrl;
  final String successPaymentUrl;
  final String? title;
  final Function()? onSuccess;
  const DetailPaymentPage(
      {this.title, required this.paymentUrl, super.key, required this.successPaymentUrl, this.onSuccess});

  @override
  State<DetailPaymentPage> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<DetailPaymentPage> {
  WebViewController? controller;
  @override
  void initState() {
    // late final PlatformWebViewControllerCreationParams params;
    // if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    //   params = WebKitWebViewControllerCreationParams(
    //     allowsInlineMediaPlayback: true,
    //     mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    //     // limitsNavigationsToAppBoundDomains: true,
    //   );
    // } else {
    //   params = const PlatformWebViewControllerCreationParams();
    // }

    // controller = WebViewController.fromPlatformCreationParams(params);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onUrlChange: (change) {
            log('onUrlChange - ${change.url}');
          },
          onPageStarted: (String url) {
            log('onPageStarted - $url');
          },
          onPageFinished: (String url) {
            log('onPageFinished - $url');
            switch (url) {
              case '': // error
              // case 'https://sezapp.arendos.kz/api/v1/payment/subscribe/2/success': // success
              //   Future.delayed(
              //       const Duration(
              //         seconds: 2,
              //       ), () {
              //     context.router.pop();
              //   });
              //   setState(() {});
              default:
              // if (url.contains(widget.successPaymentUrl)) {
              // Future.delayed(
              //     const Duration(
              //       seconds: 2,
              //     ), () {
              //   context.router.maybePop();
              //   widget.onSuccess?.call();
              // });
              // setState(() {});
            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: Container(
          margin: const EdgeInsets.symmetric(vertical: 13),
          child: InkWell(
            onTap: () {
              Future.delayed(const Duration(seconds: 1), () {
                // Replace 'AnotherPageRoute' with the route name or method you use to navigate
                context.router.replaceAll([const LauncherRoute(), LoansRoute()]);
              });
            },
            child: SvgPicture.asset(Assets.icons.backButton.path),
          ),
        ),
        title: const Text(
          'Оформление займа',
          style: AppTextStyles.fs18w600,
        ),
        centerTitle: true,
      ),
      body: controller != null ? WebViewWidget(controller: controller!) : const SizedBox(),
    );
  }
}
