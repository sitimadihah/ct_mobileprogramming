import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'user.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final String orderid, val;
  PaymentScreen({this.user, this.orderid, this.val});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            'Payment',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          iconTheme: new IconThemeData(color: Colors.black),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl:
                    'http://saujanaeclipse.com/fastingHealth/php/payment.php?email=' +
                        widget.user.email +
                        '&mobile=' +
                        widget.user.phone +
                        '&name=' +
                        widget.user.name +
                        '&amount=' +
                        widget.val +
                        '&orderid=' +
                        widget.orderid,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }
}
