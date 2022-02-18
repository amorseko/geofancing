import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/bloc/login_bloc.dart';
import 'package:geofancing/src/utility/colors.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:flutter/material.dart';
import 'package:geofancing/src/widgets/Strings.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/utility/utils.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geofancing/src/bloc/request/req_do_login.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/bloc/get_config_features_bloc.dart' as featureBloc;
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _isHidePassword = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
//  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final _usernameController = TextEditingController();
  final _passController = TextEditingController();

  final DoLoginBloc bloc = DoLoginBloc();

  Widget _logo(BuildContext context){
    return new Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
      child: Image.asset(
        'assets/images/icon_toyoga.png',
        width: MediaQuery.of(context).size.width/2,
      ),
      alignment: FractionalOffset.topCenter,
      decoration: BoxDecoration(color: Colors.transparent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: CorpToyogaColor,
        centerTitle: true,
        title: TextWidget(
          txt: "Login",
        ),
      ),
      body: ProgressDialog(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0,0.0,30.0,10.0),
              child: _formLogin(context),
            ),
          ),
        ),
        inAsyncCall: _isLoading,
      ),
    );
  }

  Widget _formLogin(BuildContext context){
    return new Container(
      child: Column(
        children: <Widget>[
          _logo(context),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 20.0, horizontal: 0.0),
            child: TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                  labelText: "username", suffixIcon: Icon(Icons.face )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 5.0, horizontal: 0.0),
            child: TextFormField(
              controller: _passController,
              obscureText: _isHidePassword,
              decoration: InputDecoration(
                  labelText: allTranslations.text('txt_pass'),
                  suffixIcon: IconButton(
                      icon: _isHidePassword
                          ? Icon(Icons.vpn_key)
                          : Icon(Icons.remove_red_eye),
                      onPressed: () {
                        setState(() {
                          if (_isHidePassword) {
                            _isHidePassword = false;
                          } else {
                            _isHidePassword = true;
                          }
                        });
                      })),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 70.0, 40.0, 0.0),
              child: ButtonTheme(
                child: new RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: TextWidget(
                    color: Colors.white,
                    txt: allTranslations.text('btn_login'),
                    txtSize: 14.0,
                  ),
                  elevation: 4.0,
                  color: CorpToyogaColor,
                  splashColor: Colors.blueAccent,
                  onPressed: () {
                    _onSubmitLogin(context);
                  },
                ),
                height: 50.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 20.0, horizontal: 0.0),

          ),


        ],
      ),

    );
  }

  _onSubmitLogin(BuildContext context) {
    setState(() {
      _isLoading = true;
    });




    SharedPreferencesHelper.setUsername(_usernameController.text);
//    String firebaseToken = await _firebaseMessaging.getToken();
//    print(firebaseToken);
    if(_usernameController.text == "" || _passController.text == "") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please fill username or password !")));
      _isLoading = false;
    } else {
      ReqDoLogin request = ReqDoLogin(
          username: _usernameController.text,
          password: _passController.text);
      bloc.fetchDoLogin(
          request.toMap(),
              (status, message, code) => {
            _openMainMenu(status, message, code),
          });
    }

  }

  _openForgotPassword(){
//    routeToWidget(context, ForgotPasswordPage());
  }

  _openMainMenu(status, message, code) async{
    setState(() {
      _isLoading = false;
    });
//    print("data nya : " + code);
    if (status) {
      print("Status Login");
      await featureBloc.bloc.configGetFeature((model){
        SharedPreferencesHelper.setFeature(json.encode(model.toJson()));
      });
      Navigator.pushNamedAndRemoveUntil(context, "/main_page", (_) => false);
    } else if (message == 'User Not Found') {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));;
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
    }
  }

}