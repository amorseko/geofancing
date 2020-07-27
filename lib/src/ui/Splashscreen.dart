import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;


import 'package:flutter/material.dart';
import 'package:geofancing/src/widgets/Strings.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';

import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/bloc/language_bloc.dart';

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

  void navigationPage() {

//    Navigator.of(context).pushReplacementNamed('/prelogin_menu');
    SharedPreferencesHelper.getDoLogin().then((onValue) {
      if (onValue.isNotEmpty) {

        Navigator.of(context).pushReplacementNamed('/main_page');
      } else {
        Navigator.of(context).pushReplacementNamed('/login_menu');
      }
    });
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
}