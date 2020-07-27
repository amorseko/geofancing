import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geofancing/src/bloc/request/do_req_changepass.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/utility/colors.dart';
import 'package:geofancing/src/utility/sharedpreferences.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/bloc/changepass_bloc.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool _isHideOldPassword = true;
  final _oldPasswordController = TextEditingController();
  bool _isHideNewPassword = true;
  final _newPasswordController = TextEditingController();
  bool _isHideReNewPassword = true;
  final _reNewPassController = TextEditingController();
  String _idUser;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.white),
        title: TextWidget(txt: allTranslations.text("txt_changepassword"), color: colorTitle()),
        backgroundColor: coorporateColor,
        elevation: 0,
      ),
      body: ProgressDialog(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                  child: TextFormField(
                    controller: _oldPasswordController,
                    obscureText: _isHideOldPassword,
                    decoration: InputDecoration(
                      labelText: allTranslations.text("txt_old_pass"),
                      suffixIcon: IconButton(
                        icon: _isHideOldPassword ? Icon(Icons.vpn_key) : Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            if(_isHideOldPassword) {
                              _isHideOldPassword = false;
                            } else {
                              _isHideOldPassword =true;
                            }
                          });
                        },
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                  child: TextFormField(
                    controller : _newPasswordController,
                    obscureText: _isHideNewPassword,
                    decoration: InputDecoration(
                      labelText: allTranslations.text("txt_new_pass"),
                      suffixIcon: IconButton(
                        icon: _isHideNewPassword ? Icon(Icons.vpn_key) : Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            if(_isHideNewPassword) {
                              _isHideNewPassword = false;
                            } else {
                              _isHideNewPassword = true;
                            }
                          });
                        },
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                  child: TextFormField(
                    controller: _reNewPassController,
                    obscureText: _isHideReNewPassword,
                    decoration: InputDecoration(
                      labelText: allTranslations.text("txt_renew_pass"),
                      suffixIcon: IconButton(
                        icon: _isHideReNewPassword ? Icon(Icons.vpn_key) : Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            if(_isHideReNewPassword) {
                              _isHideReNewPassword = false;
                            } else {
                              _isHideReNewPassword = true;
                            }
                          });
                        },
                      )
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(top : 20),
                    child: ButtonTheme(
                      child: new RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: TextWidget(
                          color: Colors.white,
                          txt: allTranslations.text("txt_ubah"),
                          txtSize: 14.0,
                        ),
                        elevation: 4.0,
                        color: coorporateColor,
                        splashColor: Colors.blueAccent,
                        onPressed: () {
                          _changePassword();
                        },
                      ),
                      height: 50.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        inAsyncCall: _isLoading,
      ),
    );
  }

  _changePassword() {
    setState(() {
      _isLoading = false;
    });

    if(_newPasswordController != "") {
      SharedPreferencesHelper.getDoLogin().then((onValue) {
        final memberModels = MemberModels.fromJson(json.decode(onValue));
        setState(() {
          _idUser = memberModels.data.id_user;
        });
        _isLoading = true;
        ReqChangePass request = ReqChangePass(
            password_old: _oldPasswordController.text,
            password_new: _newPasswordController.text,
            id_user: _idUser);
            bloc.actForgotPass(request.toMap(),
        (status, message) => {showErrorMessage(context, message, status)});
      });
    } else {
      showErrorMessage(context, "Password tidak sama", false);
    }
  }

  void showErrorMessage(BuildContext context, String message, bool status){
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
            height: MediaQuery.of(context).size.width / 2.5,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      new BorderRadius.all(const Radius.circular(30.0))),
                  child: Container(
                      width: MediaQuery.of(context).size.width * (3 / 2),
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Column(
                              children: <Widget>[
                                Text(status == true ? allTranslations.text("msg_password") : message,
                                  style: TextStyle(
                                      fontSize: 18
                                  ),),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    if(status == true){
                                      Navigator.pushNamedAndRemoveUntil(context, "/main_page", (_) => false);
                                    }else{
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Container(
                                      width:
                                      MediaQuery.of(context).size.width /
                                          2,
                                      height: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.all(
                                              const Radius.circular(30.0)),
                                          color: coorporateColor),
                                      child: Text("OK",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          );
        });
  }

  _verifyChangePassword(bool status, String message) {
    print(message);
    print(status);
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
    setState(() {
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _reNewPassController.clear();
      _isLoading = false;
    });
  }
}