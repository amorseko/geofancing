import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/utility/colors.dart';
import 'package:geofancing/src/utility/sharedpreferences.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/Strings.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geofancing/src/ui/main/absen/absensi_page.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}






class _MainPageState extends State<MainPage> {

  String _fullName;
  bool _isLoading = true;


  @override
  void initState() {
    // TODO: implement initState
//  super.initState();
    super.initState();
    setPotrait();
    new Timer(const Duration(milliseconds: 150), () {
      _initview();
    });

  }

  Widget _buildCustomCover(Size screenSize){
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: screenSize.height / 4,
        width: screenSize.width ,
        color: primaryColor,
        child: Image(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/bg_header.jpg"),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      child: Container(
        height: 100,
        width: 100,
        child: Material(
          elevation: 4.0,
          shape: CircleBorder(),
          color: primaryColor,
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.all(22),
              child: Center(
                child: TextWidget(
                  txtSize: 30,
                  txt: _fullName != null ? _fullName.substring(0, 1) : "",
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
    );

    return Text(
      _fullName == null ? " " : _fullName,
      style: _nameTextStyle,
    );
  }


  Widget _boxMenu(BuildContext context){
    return Container(
//      margin: EdgeInsets.fromLTRB(25, 20, 25, 25),
        width: MediaQuery.of(context).size.width,
        child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
//          primary: false,
            crossAxisCount: 2,
            childAspectRatio: 1.0/0.7,
            padding: const EdgeInsets.all(10),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: [
//              {
//                "icon": "assets/icons/icons_peserta.png",
//                "title": allTranslations.text('btn_absen'),
//                "type": "page",
//                "page": "",
//                "status": true,
//                "color":0xFF74b9ff
//              },
//              {
//                "icon": "assets/icons/ic_date.png",
//                "title": allTranslations.text('btn_report'),
//                "type": "page",
//                "page": "",
//                "status": "",
//                "color":0xFFfd79a8
//              },
//              {
//                "icon": "assets/icons/ic_date.png",
//                "title": allTranslations.text('btn_report'),
//                "type": "page",
//                "page": "",
//                "status": "",
//                "color":0xFFfd79a8
//              },
              {
                "icon": "assets/icons/icons_peserta.png",
                "title": allTranslations.text('btn_absen'),
                "type": "page",
                "page": AbsensiPage(),
                "status": true,
                "color":0xFF74b9ff
              },
              {
                "icon": "assets/icons/icons_riwayat.png",
                "title": allTranslations.text('btn_report'),
                "type": "page",
                "page": "",
                "status": true,
                "color":0xFFfd79a8
              }
            ].where((menu) => menu['status'] == true).map((listMenu) {
              return GestureDetector(
                  onTap: () {
                    if (listMenu['type'] == 'call') {
                      MakeCall(context, listMenu['page']);
                    } else if (listMenu['type'] == 'url') {
//                      _fetchGuideBook();
                    } else {
                      routeToWidget(context, listMenu['page']).then((value) {
                        setPotrait();
                      });
                    }
                  },
                  child: Card(
                      color: Color(listMenu["color"]),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Image.asset(
                              listMenu['icon'],
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height / 15,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextWidget(
                              txt: listMenu['title'],
                              txtSize: 12,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )));
            }).toList())
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: ProgressDialog(
          inAsyncCall: _isLoading,
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                _buildCustomCover(screenSize),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0, right: 10.0),
                    child: Align(
                      alignment: FractionalOffset.topRight,
                      child: RawMaterialButton(
                        elevation: 10,
                        shape: new CircleBorder(),
                        child: Image(
                          image: AssetImage("assets/icons/icon_settings.png"),
                          height: 30,
                        ),
                        padding: EdgeInsets.all(5),
                        fillColor: Colors.white,
                        onPressed: (){
//                          routeToWidget(context, new SettingsPage());
                        },
                      ),
                    ),
                  )
                ),
                SafeArea(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: screenSize.height / 7),
                      _buildProfileImage(),
                      SizedBox(height: 10),
                      _buildFullName(),
                      _boxMenu(context)
                    ],
                  ),
                ),
              ],
            )
          )
        )
    );
  }

  _initview() async {
    SharedPreferencesHelper.getDoLogin().then((member) {
      final memberModels = MemberModels.fromJson(json.decode(member));
      setState(() {
        _fullName =  memberModels.data.nama_user;
      });
    });

    setState(() {
      _isLoading = false;
    });
  }
}