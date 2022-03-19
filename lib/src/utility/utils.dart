import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:geofancing/src/bloc/bloc-provider.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

colorTitle(){
  return Colors.white;
}
findData(array, search){
  return array.where((data)=>data.feature_id==search).toList();
}
Future<String> randomString() async {
  const chars = "abcdefghijklmnopqrstuvwxyz";
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < 4; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return result.toUpperCase();
}

Future setPotrait() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Future<Widget> routeToWidget(BuildContext context, Widget widget) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) {
      return BlocProvider(
        child: widget,
      );
    }),
  );
}

showToast(BuildContext context, String message) {
  return Scaffold.of(context).showSnackBar(new SnackBar(
    content: new Text(message),
  ));
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return false;
  else
    return true;
}

String formatDateFormStandart(String value, String format) {
  var datetime = DateTime.parse(value);
  return DateFormat(format).format(datetime);
}

//Use yyyymmdd
String formatDate(String value, String format) {
  print(value);
  value = value + 'T132700';
  var datetime = DateTime.parse(value);
  return DateFormat(format).format(datetime);
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

String mmmTomm(String mmm) {
  String mm;
  switch (mmm) {
    case "JAN":
      mm = "01";
      break;
    case "FEB":
      mm = "02";
      break;
    case "MAR":
      mm = "03";
      break;
    case "APR":
      mm = "04";
      break;
    case "MAY":
      mm = "05";
      break;
    case "JUN":
      mm = "06";
      break;
    case "JUL":
      mm = "07";
      break;
    case "AUG":
      mm = "08";
      break;
    case "SEP":
      mm = "01";
      break;
    case "OCT":
      mm = "10";
      break;
    case "NOV":
      mm = "11";
      break;
    case "DEC":
      mm = "12";
      break;
  }
  return mm;
}

String mmmmTomm(String mmm) {
  String mm;
  switch (mmm) {
    case "January":
      mm = "01";
      break;
    case "February":
      mm = "02";
      break;
    case "March":
      mm = "03";
      break;
    case "April":
      mm = "04";
      break;
    case "May":
      mm = "05";
      break;
    case "June":
      mm = "06";
      break;
    case "July":
      mm = "07";
      break;
    case "August":
      mm = "08";
      break;
    case "September":
      mm = "01";
      break;
    case "October":
      mm = "10";
      break;
    case "November":
      mm = "11";
      break;
    case "December":
      mm = "12";
      break;
  }
  return mm;
}


Future<void> MakeCall(BuildContext context, String phoneNumb) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(phoneNumb),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Call'),
            onPressed: () {
              UrlLauncher.launch("tel://" + phoneNumb);
            },
          ),
        ],
      );
    },
  );
}


cupertinoAlertDialog(BuildContext context, String title, String content,
    List<FlatButton> buttonAct) {
  showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: TextWidget(
            txt: title,
          ),
          content: TextWidget(
            txt: content,
          ),
          actions: buttonAct.map((f) => f).toList(),
        );
      });
}

Widget dataNotFound(BuildContext context) {
  return Center(
    child: Image.asset(
      'assets/images/not_found.png',
      height: MediaQuery.of(context).size.height / 3,
    ),
  );
}
