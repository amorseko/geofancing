import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geofancing/src/bloc/get_config_features_bloc.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/ui/pre_login.dart';
import 'package:geofancing/src/widgets/Strings.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';

import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/bloc/language_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:trust_location/trust_location.dart';
import 'package:geofancing/src/bloc/bloc_checkuser.dart';
import 'package:geofancing/src/utility/network_status_service.dart';
import 'package:geofancing/src/widgets/network_aware_widget.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final langBloc = LanguageBloc();
  final CheckUserBloc = ChangePassBloc();
  final configBloc  = ConfigGetFeaturesBloc();

  startTime() async {
    var _duration = new Duration(seconds: 4);

    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        DateTime now = await NTP.now();
        DateTime _LocalTime = DateTime.now();
        String Localtime = DateFormat('y-MM-d').format(_LocalTime);
        String dFormat = DateFormat('y-MM-d').format(now);
        bool isMockLocation = await TrustLocation.isMockLocation;

        if (isMockLocation == true) {
          showAlertDialog(context, allTranslations.text("txt_ilegal_program"));
        }

        if (dFormat != Localtime) {
          showAlertDialog(
              context, "Your time is not syncron please open the settings !");
        } else {
          SharedPreferencesHelper.getDoLogin().then((onValue) {
            print(onValue);

            if (onValue.isNotEmpty) {
              final memberModels = MemberModels.fromJson(json.decode(onValue));
              var data = {
                "id_user": memberModels.data.id_user,
                "username": memberModels.data.username,
              };
              CheckUserBloc.actForgotPass(data, (status, message) {
                print(message);
                if (message == "not avail") {
                  _logout();
                }
              });

              configBloc.configGetFeature((model){
                SharedPreferencesHelper.setFeature(json.encode(model.toJson()));
              });
              Navigator.of(context).pushReplacementNamed('/main_page');
            } else {
              Navigator.of(context).pushReplacementNamed('/login_menu');
            }
          });
        }
      }
    } on SocketException catch (_) {
      Navigator.of(context).pushReplacementNamed('/offline_page');
    }

  }

  _logout() {
    SharedPreferencesHelper.clearAllPreference();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => PreLoginActivity()),
        (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asyncGetLang();
  }


  void asyncGetLang() async {
    await getLang();
  }

  getLang() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var data = {"app_id": appid};
        try {
          langBloc.getLang(data, (model) {
            var result = model;
            if(result['data'] == null) {
              Navigator.of(context).pushReplacementNamed('/offline_page');
            } else {
              print(result['data']);
              SharedPreferencesHelper.setLanguage(json.encode(result['data']))
                  .then((value) async {
                await allTranslations.init();
                startTime();
              });
            }

          });
        } catch (_) {
          Navigator.of(context).pushReplacementNamed('/offline_page');
        }

      }
    } on SocketException catch (_) {
      Navigator.of(context).pushReplacementNamed('/offline_page');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset(
            "assets/images/icon_toyoga.png",
            width: MediaQuery.of(context).size.width / 2,
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () => exit(0),
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
