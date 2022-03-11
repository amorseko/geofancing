import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geofancing/src/ui/login_page.dart';
import 'package:geofancing/src/ui/main/main_page.dart';
import 'package:geofancing/src/ui/main/pekerjaan/pekerjaan.dart';
import 'package:geofancing/src/ui/pre_login.dart';
import 'package:geofancing/src/ui/Splashscreen.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/ui/main/additional_page/offline_page.dart';
import 'package:geofancing/src/ui/Splashscreen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Helvetica'),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SplashScreen(),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: allTranslations.supportedLocales(),
      routes: <String, WidgetBuilder>{
        '/main_page': (BuildContext context) => new MainPage(),
        '/prelogin_menu': (BuildContext context) => new PreLoginActivity(),
        '/login_menu': (BuildContext context) => new LoginPage(),
        '/pekerjaan_page': (BuildContext context) => new PekerjaanPage(),
        '/offline_page': (BuildContext context) => new OfflinePage(),
        '/splashscreen': (BuildContext context) => new SplashScreen(),
      },
    );
  }
}
