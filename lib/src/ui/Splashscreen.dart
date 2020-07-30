import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geofancing/src/widgets/Strings.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';

import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/bloc/language_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final langBloc = LanguageBloc();

  startTime() async {
    var _duration = new Duration(seconds: 4);

    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {

//    Navigator.of(context).pushReplacementNamed('/prelogin_menu');


    DateTime now = await NTP.now();
    DateTime _LocalTime = DateTime.now();
    String Localtime = DateFormat('y-MM-d').format(_LocalTime);
    String dFormat = DateFormat('y-MM-d').format(now);
    print('NTP DateTime : ' + dFormat + " LocalTime : " + Localtime);


    if(dFormat != Localtime) {
      showAlertDialog(context, "Your time is not syncron please open the settings !");
    } else {
      SharedPreferencesHelper.getDoLogin().then((onValue) {
        if (onValue.isNotEmpty) {

          Navigator.of(context).pushReplacementNamed('/main_page');
        } else {
          Navigator.of(context).pushReplacementNamed('/login_menu');
        }
      });
    }


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLang();
  }



  getLang(){
    var data = {
      "app_id": appid
    };
    langBloc.getLang(data, (model){
      var result = model;
      print(result['data']);
      SharedPreferencesHelper.setLanguage(json.encode(result['data'])).then((value) async{
        await allTranslations.init();
        startTime();
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset("assets/images/icon_toyoga.png", width: MediaQuery.of(context).size.width/2,),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, message) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: ()=> exit(0),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );


    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}