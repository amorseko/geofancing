import 'package:flutter/material.dart';
import 'package:geofancing/src/ui/login_page.dart';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/bloc/bloc-provider.dart';

class PreLoginActivity extends StatefulWidget {
  @override
  _PreLoginActivityState createState() => _PreLoginActivityState();
}

class _PreLoginActivityState extends State<PreLoginActivity> {


  Widget _logo(BuildContext context){
    return new Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
      child: Image.asset(
        'assets/images/icon_toyoga.png',
        width: MediaQuery.of(context).size.width/2,
      ),
      alignment: FractionalOffset.topCenter,
      decoration: BoxDecoration(color: Colors.transparent),
    );
  }

  Widget buttonComponet(BuildContext context) {
    return new Positioned(
      bottom: MediaQuery.of(context).size.height / 10,
      left: 0.5,
      right: 0.5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ButtonTheme(
              child: new RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: TextWidget(
                  color: Colors.white,
                  txt: allTranslations.text("btn_login"),
                  txtSize: 18.0,
                ),
                color: CorpToyogaColor,
                splashColor: Colors.blueGrey,
                onPressed: () {
                  _openLoginForm(context);
                },
              ),
              height: 50.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: ButtonTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: new RaisedButton(
                  child: TextWidget(
                    color: Colors.white,
                    txt: allTranslations.text("btn_register"),
                    txtSize: 18.0,
                  ),
                  color: CorpSecondToyoga,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    //_openRegisterForm(context);
                  },
                ),
                height: 50.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _logo(context),
          buttonComponet(context)
        ],
      ),
    );
  }

  _openLoginForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return BlocProvider(
          child: LoginPage(),
        );
      }),
    );
  }


}