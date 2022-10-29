import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tokokueku/screens/menu_utama.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Pembayaran extends StatefulWidget {
  const Pembayaran({required this.orderId, super.key});
  final String orderId;

  @override
  State<Pembayaran> createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  Future<bool> toHomeScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MenuUtama(),
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pembayaran"),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: WebView(
          initialUrl: "https://farizan.my.id/pay/${widget.orderId}",
          javascriptMode: JavascriptMode.unrestricted,
          zoomEnabled: false,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url
                .startsWith('https://farizan.my.id/back-to-mobile')) {
              toHomeScreen();
              return NavigationDecision.prevent;
            }
            //Any other url works
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
