import 'package:SmartHajj/BottomNavigationBar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SnapToken extends StatefulWidget {
  final String paymentUrl;

  const SnapToken({Key? key, required this.paymentUrl}) : super(key: key);

  @override
  _SnapTokenState createState() => _SnapTokenState();
}

class _SnapTokenState extends State<SnapToken> {
  @override
  Widget build(BuildContext context) {
    String? message;
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel("FlutterChannel",
          onMessageReceived: (JavaScriptMessage message) {
        print("Message received: ${message.message}");
        if (message.message == 'success') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.rightSlide,
            title: 'Berhasil!',
            desc: 'Proses transaksi anda Sukses!',
            btnOkOnPress: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => BottomNavigation()));
            },
          )..show();
        }
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            print('onPageStarted: $url');
          },
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl.toString()));
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: const Text('SmartHajj'))),
      body: WebViewWidget(controller: controller),
    );
  }
}
