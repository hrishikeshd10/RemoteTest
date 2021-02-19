import 'package:flutter/material.dart';
import 'package:my_neighbourhood_online/widget/base_canvas.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FullWebViewPage extends StatefulWidget {
  final String fullViewURL;

  const FullWebViewPage({Key key, this.fullViewURL}) : super(key: key);
  @override
  _FullWebViewPageState createState() => _FullWebViewPageState();
}

class _FullWebViewPageState extends State<FullWebViewPage> {
  num position = 1;

  final key = UniqueKey();

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  loadErrorWidget(WebResourceError error) {
    setState(() {
      position = 2;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Inside URl");
    print(widget.fullViewURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseCanvas(
        child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
            child: IndexedStack(index: position, children: <Widget>[
              Center(
                child: WebView(
                    key: key,
                    onPageFinished: doneLoading,
                    onPageStarted: startLoading,
                    onWebResourceError: loadErrorWidget,
                    initialUrl: widget.fullViewURL,
                    // 'https://kuula.co/share/collection/7PR8n?fs=1&vr=1&sd=1&initload=0&thumbs=1&info=0&logo=1',
                    javascriptMode: JavascriptMode.unrestricted),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Loading your 360 View...",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "OOPS !!",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Could not load the 360 View... try again later!!",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ])),
      ),
    );
  }
}
