import 'dart:async';
import 'dart:io';
import 'package:geofancing/src/widgets/ButtonWidgetLoading.dart';
import 'package:flutter/material.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';

class OfflinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OfflinePageState();
  }
}

class _OfflinePageState extends State<OfflinePage> {
  final ButtonWidgetLoadController _btnRetryController = new ButtonWidgetLoadController();

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Align(
                  alignment: AlignmentDirectional.center,
                  child: Image.asset(
                    "assets/images/img_no_network.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom : 32, left: 21, right: 21),
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: ButtonWidgetLoad(
                child: TextWidget(
                  txt: "RETRY",
                  color: Colors.white,
                  txtSize: 14,
                  fontFamily: 'Bold',
                ),
                width: MediaQuery.of(context).size.width,
                height: 50,
                borderRadius: 15.0,
                color: Colors.redAccent[400],
                successColor: Colors.redAccent[400],
                controller: _btnRetryController,
                onPressed: () => _navigationPage()
              ),
            ),
          )
        ],
      ),
    );
  }

  _navigationPage() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Navigator.pop(context);
        // Navigator.of(context, rootNavigator: true).pop(context);
        Navigator.of(context).pushReplacementNamed('/splashscreen');
      }
    } on SocketException catch (_) {
      Navigator.of(context).pushReplacementNamed('/splashscreen');
    }
  }
}

