import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/utility/utils.dart' as Utils;
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/Strings.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/models/members_model.dart';

import 'package:geofancing/src/ui/main/main_page.dart';
import 'package:geofancing/src/ui/main/settings/reset_password_page.dart';
import 'package:geofancing/src/ui/pre_login.dart';


import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _name, id_user;
  bool isLoadingSwitch = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String language = allTranslations.currentLanguage;

  bool _isLoading=true;
  bool isEn = false;

  Widget _bgHeader(BuildContext context){
    return new Container(
      child: Image.asset(
        'assets/images/settings.png',
        width: MediaQuery.of(context).size.width/2,
      ),
      alignment: FractionalOffset.topCenter,
      decoration: BoxDecoration(color: Colors.transparent),
    );
  }
  

  void initState() {
    super.initState();


    _checkLang();
    _initView();
    print(isEn);
  }

  void trans () async{
    setState(() {
      _isLoading=true;
    });
    await allTranslations.setNewLanguage(language == 'id' ? 'en' : 'id');
//    routeToWidget(context, MainPage());

    setState(() {
      language = allTranslations.currentLanguage;
    });

    Timer(const Duration(milliseconds: 1000),(){
      _checkLang();
    });

    Timer(const Duration(milliseconds: 1000),(){
      setState(() {
        _isLoading=false;
      });
    });

  }

  _checkLang(){
    if(language == "id"){
      setState(() {
        isEn=false;
      });
    }else{
      setState(() {
        isEn=true;
      });
    }

    print(isEn);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.white),
        title: TextWidget(txt: "Settings", color: Utils.colorTitle()),
        backgroundColor: CorpToyogaColor,
        elevation: 0,
      ),
      body: ProgressDialog(
        inAsyncCall: _isLoading,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Padding(
              padding:  new EdgeInsets.only(top: 20.0, left: 20, right: 10),
                child: Column(
                  children: <Widget>[
                    _bgHeader(context),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Container(
                              height: 100,
                              width: 400,
                              child: Material(
                                elevation: 4.0,
                                shape: CircleBorder(),
                                color: Colors.redAccent[700],
                                child: ClipRRect(
                                  borderRadius: new BorderRadius.circular(8),
                                  child: Container(
                                    padding: EdgeInsets.all(22),
                                    child: Center(
                                      child: TextWidget(
                                        txtSize: 30,
                                        txt: _name != null ? _name.substring(0, 1) : "",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              child: Column(
                                crossAxisAlignment : CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _name != null ? _name.trim() : "",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 20, color: coorporateColor),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top:10),
                      child: new Divider(
                        color: Colors.black38,
                      ),
                    ),
                    ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        ListTile(
                          title: Text(allTranslations.text("txt_lang"),
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          leading: new Image.asset(
                            "assets/icons/icon_language.png",
                            fit: BoxFit.cover, width: 40,
                          ),
                          trailing: LiteRollingSwitch(
                            //initvalue
                            value:isEn,
                            textOn: "EN",
                            textOff: "ID",
                            colorOn: CorpToyogaColor,
                            colorOff: Colors.red,
                            iconOn: Icons.flag,
                            iconOff: Icons.outlined_flag,
                            textSize: 14.0,
                            onChanged: (bool state) {

                            },
                            onSwipe: (){
                              trans();
                            },
                            onTap: (){
                              trans();
                            },

                          ),
                        ),
                        ListTile(
                          title: Text(allTranslations.text("txt_changepassword"),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          leading: new Image.asset(
                            "assets/icons/icons_resetpassword.png",
                            fit: BoxFit.cover, width: 40,),
                          onTap: () =>
                          {
                            Utils.routeToWidget(context, new ResetPasswordPage())

                          },
                        ),
                        ListTile(
                          title: Text(allTranslations.text("btn_logout"),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                            leading: new Image.asset(
                              "assets/icons/icons_exit.png", fit: BoxFit.cover,
                              width: 40,),
                            onTap: () =>
                            {
                              _logout()
                            }
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: new Divider(
                        color: Colors.black38,
                      ),
                    )
                  ],
                ),
            )
          ],
        ),

      ),
    );
  }

  _initView() {
    SharedPreferencesHelper.getDoLogin().then((member){
      final memberModels = MemberModels.fromJson(json.decode(member));
      setState(() {
        _name = memberModels.data.nama_user;
        id_user = memberModels.data.id_user;
        _isLoading = false;
      });
    });
  }

  _logout() {
    SharedPreferencesHelper.clearAllPreference();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        PreLoginActivity()), (Route<dynamic> route) => false);
  }

}