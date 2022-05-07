import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vikunja_app/models/user.dart';
import 'package:vikunja_app/api/client.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWithWebView extends StatefulWidget {
  String frontEndUrl;

  LoginWithWebView(this.frontEndUrl);

  @override
  State<StatefulWidget> createState() => LoginWithWebViewState();
}

class LoginWithWebViewState extends State<LoginWithWebView> {

  WebView webView;
  WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    webView = WebView(
      initialUrl: widget.frontEndUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onPageFinished: (value) => _handlePageFinished(value),
      onWebViewCreated: (controller) {
        webViewController = controller;
        webViewController.runJavascript("localStorage.clear(); location.href=location.href;");
        },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(),
      body: webView
    ),
    onWillPop: () {_handlePageFinished(""); return Future.value(false);},);
  }

  void _handlePageFinished(String pageLocation) async {
    log("handlePageFinished");
    if(webViewController != null) {
      String localStorage = await webViewController
          .runJavascriptReturningResult("JSON.stringify(localStorage);");
      //String documentLocation = await webViewController.runJavascriptReturningResult("JSON.stringify(document.location);");
      if (localStorage != "null") {
        localStorage = localStorage.replaceAll("\\", "");
        localStorage = localStorage.substring(1, localStorage.length - 1);
        var json = jsonDecode(localStorage);
        if (json["API_URL"] != null && json["token"] != null) {
          BaseTokenPair baseTokenPair = BaseTokenPair(
              json["API_URL"], json["token"]);
          Navigator.pop(context, baseTokenPair);
        }
      }
    }
  }

}