import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DiaryPage extends StatefulWidget {
  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool _isPageLoading;
  @override
  void initState() {
    super.initState();
    _isPageLoading = true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.teal,
          title: Text(
            'Add data to diary',
            style: GoogleFonts.montserrat(
                fontSize: 25
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: 'https://analysis-fbbb4.web.app/',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController c){
                _controller.complete(c);
              },
              onPageFinished: (finish){
                setState(() {
                  _isPageLoading = false;
                });
              },
            ),
            _isPageLoading ? Container(
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator(),
            ) : Container()
          ],
        )
    );
  }
}
