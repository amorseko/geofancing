import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:geofancing/src/bloc/absentoday_bloc.dart' as todayBloc;
import 'package:geofancing/src/bloc/request/req_history_absen.dart';
import 'package:geofancing/src/models/absen_model.dart';
import 'package:geofancing/src/ui/main/absen/report_page.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/utility/colors.dart';
import 'package:geofancing/src/utility/sharedpreferences.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/Strings.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geofancing/src/ui/main/absen/absensi_page.dart';
import 'package:geofancing/src/ui/main/settings/settings_page.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}






class _MainPageState extends State<MainPage> {

  String _fullName;
  bool _isLoading = true;
  String waktu;

  int jumlah =0;
  String _AbsenMasuk, _AbsenKeluar;
  GoogleMapController _controller;
  double latitude = 0.0, longitude = 0.0;
  Map<String, double> userLocation;
  double _lat, _long;



  static final CameraPosition initiallocation = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );


  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);


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
          image: AssetImage("assets/images/bg_header 2.png"),
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
          color: Colors.redAccent[700],
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
        width: MediaQuery.of(context).size.width,
        child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            crossAxisCount: 1,
            childAspectRatio: 1.0/0.3,
            padding: const EdgeInsets.all(10),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: [
//              {
//                "icon": "assets/icons/icons_peserta.png",
//                "title": allTranslations.text('btn_absen'),
//                "type": "page",
//                "page": AbsensiPage(action: "masuk",),
//                "status": true,
//                "color":0xFF74b9ff
//              },
              {
                "icon": "assets/icons/icons_riwayat.png",
                "title": allTranslations.text('btn_report'),
                "type": "page",
                "page": ReportPage(),
                "status": true,
                "color":0xFFFE5661
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

  Widget _bgBox(BuildContext context){
    return new Container(
      child: Image.asset(
        'assets/images/bg_box.png',
        width: MediaQuery.of(context).size.width,
      ),
      alignment: FractionalOffset.topCenter,
      decoration: BoxDecoration(color: Colors.transparent),
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
                          routeToWidget(context, new SettingsPage());
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
                      _boxMenu(context),
                      _bgBox(context),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          elevation: 5,
                      )
                      )
                    ],
                  ),
                ),
              ],
            )
          )
        ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 50.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: _AbsenKeluar != "" ? Container(): FloatingActionButton.extended(
            onPressed: (){
              routeToWidget(context, AbsensiPage(action: _AbsenMasuk== "" ? "masuk":"pulang",));
            },
            backgroundColor: CorpToyogaColor,
            icon: Icon(Icons.timer),
            label: TextWidget(txt: _AbsenMasuk== "" ? allTranslations.text("txt_absen_masuk") : allTranslations.text("txt_absen_pulang"),txtSize: 13.5,color: Colors.white,),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }

  _initview() async {

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('y-MM-d').format(now);
    setState(() {
      waktu  = formattedDate;
      _isLoading = false;
    });

    print(waktu);

    SharedPreferencesHelper.getDoLogin().then((member) async{
      final memberModels = MemberModels.fromJson(json.decode(member));
      setState(() {
        _fullName =  memberModels.data.nama_user;
        _long = memberModels.data.longitude;
        _lat = memberModels.data.latitude;
      });




      ReqHistoryAbsen params = ReqHistoryAbsen(
          id_pegawai: memberModels.data.id_user,
              tanggal : waktu
      );

     await todayBloc.bloc.doGetTodayAbsen(params.toMap(), (status, error, message, model){
       AbsenModels absenModels = model;
       print(absenModels.data.length);
       setState(() {
         jumlah  = absenModels.data.length;
         if(jumlah != 0) {
           _AbsenKeluar = absenModels.data[0].absen_keluar;
           _AbsenMasuk = absenModels.data[0].absen_masuk;
         } else {
           _AbsenMasuk = "";
           _AbsenKeluar = "";
         }
         print("data absen Masuk : " + _AbsenMasuk);
         print("data jumlah : " + jumlah.toString());
       });
     });


    });


  }



//  _doCek() async{
//    SharedPreferencesHelper.getDoLogin().then((member) async{
//      final memberModels = MemberModels.fromJson(json.decode(member));
//      setState(() {
//        _fullName =  memberModels.data.nama_user;
//      });
//
//      ReqHistoryAbsen params = ReqHistoryAbsen(
//          id_pegawai: memberModels.data.id_user
//      );
//      todayBloc.bloc.doGetTodayAbsen(params.toMap(), (status, error, message, model){
//        AbsenModels absenModels = model;
//        print(absenModels.data.length);
//        print(status);
//      });
//    });
//  }
}