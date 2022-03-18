import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:geofancing/src/bloc/absentoday_bloc.dart' as todayBloc;
import 'package:geofancing/src/bloc/bloc_checkuser.dart';
import 'package:geofancing/src/bloc/get_config_features_bloc.dart';
import 'package:geofancing/src/bloc/request/req_history_absen.dart';
import 'package:geofancing/src/models/absen_model.dart';
import 'package:geofancing/src/models/config_get_features.dart';
import 'package:geofancing/src/ui/main/absen/report_page.dart';
import 'package:geofancing/src/ui/main/car_working/list_working_car_before.dart';
import 'package:geofancing/src/ui/main/pekerjaan/pekerjaan.dart';
import 'package:geofancing/src/ui/pre_login.dart';
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
import 'package:geofancing/src/ui/main/pengajuan_barang/pengajuan.dart';
import 'package:geofancing/src/models/getversion_model.dart';
import 'package:geofancing/src/bloc/getversion_bloc.dart' as _blocVersion;
import 'package:package_info/package_info.dart';
import 'package:geofancing/src/ui/main/car_working/car_working_before.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) {

}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _fullName;
  bool _isLoading = true;
  String waktu;

  int jumlah = 0;
  String _AbsenMasuk, _AbsenKeluar;
  GoogleMapController _controller;
  double latitude = 0.0, longitude = 0.0;
  Map<String, double> userLocation;
  double _lat, _long;
  String _username, _idUser;

  final _blocFeatures = ConfigGetFeaturesBloc();
  static List Features = List();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  _registerOnFirebase() {
    _firebaseMessaging.subscribeToTopic('notifUpdate');
    _firebaseMessaging.getToken().then((token) {
      print(token);
    }
    );
  }

  Future onSelectNotification(String payload) async {
    print(payload);
    if(payload != "")
    {
      _launchURL(payload);
//      routeToWidget(context,ListNotifPage()).then((value) {
//        setPotrait();
//      });
    }
  }

  Future<void> _demoNotification(dynamic PayLoad) async {
    final dynamic data = jsonDecode(PayLoad['data']['data']);
    print(PayLoad);
    final dynamic notification = jsonDecode(PayLoad['data']['notification']);
    final dynamic dataNotifUrl = jsonDecode(PayLoad['data']['data']);
    final int idNotification = data['id'] != null ? int.parse(data['id']) : 1;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Toyoga Apps', 'notification',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS : iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, notification['title'], notification['body'], platformChannelSpecifics, payload: dataNotifUrl['url']);
  }

  final CheckUserBloc = ChangePassBloc();
  @override
  void initState() {
    // TODO: implement initState
//  super.initState();
    super.initState();
    setPotrait();
    new Timer(const Duration(milliseconds: 150), () {
      _initview();

      getMessage();

    });
  }

  void showNotification(dynamic Payload) async {
    await _demoNotification(Payload);
  }

  _launchURL(String URLData) async {
    //const url = 'https://flutter.io';
    if (await canLaunch(URLData)) {
      await launch(URLData);
    } else {
      throw 'Could not launch $URLData';
    }
  }

  void getMessage() async{
//    final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");
    var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

//     _firebaseMessaging.configure(
//         onMessage: (Map<String, dynamic> message) async {
//           await showNotification(message);
// //
//         },
//         onBackgroundMessage: onBackgroundMessage,
//         onResume: (Map<String, dynamic> message) async {
//           print('on resume $message');
//           await showNotification(message);
//         },
//         onLaunch: (Map<String, dynamic> message) async {
//           print('on launch $message');
//           await showNotification(message);
//         }
//     );
    if (Platform.isIOS) await iOSPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      await showNotification(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{
      await showNotification(message.data);
    });

    _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, sound: true);
  }

  Future<void> iOSPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _blocFeatures.dispose();
  }


  checkVersion() async {
     _blocVersion.bloc.getVersion({"app_id": appid}, (model, status, message) async {
      await getVersion(model, status, message);
    });
  }

  getVersion(GetVersionModel model, status, message) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
//    debug.
    print("data package : " + packageInfo.buildNumber);
    if (int.parse(packageInfo.buildNumber) <
        int.parse(Platform.isAndroid
            ? model.data.data.android.version_code
            : model.data.data.ios.version_code)) {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 100,
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.elliptical(150, 30)),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        child: Image.asset('assets/icons/close_popup.png'),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.lightBlueAccent,
                              blurRadius: 10.0,
                              spreadRadius: 5.0,
                              offset: Offset(0.0, 0.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: TextWidget(
                        txt: "Version " +
                            model.data.data.android.version_name +
                            " is Available",
                        txtSize: 20,
                        color: Colors.lightBlueAccent,
                        weight: FontWeight.bold,
                      ),
                      padding: const EdgeInsets.only(bottom: 15),
                    ),
                    Container(
                        child: RaisedButton(
                          onPressed: () async {
                            String url = model.data.data.android.url;
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          color: Colors.lightBlueAccent,
                          textColor: Colors.white,
                          child: TextWidget(
                            txt: "UPDATE NOW",
                            txtSize: 15,
                            color: Colors.white,
                            weight: FontWeight.bold,
                          ),
//                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
//                      child: Container(),
                        ),
                        padding: const EdgeInsets.only(bottom: 15)),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildCustomCover(Size screenSize) {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: screenSize.height / 4,
        width: screenSize.width,
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
    return Container(
      height: 80.0,
      width: 300.0,
      color: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
              color: Colors.redAccent[700],
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: new Center(
            child: new Text(
              _fullName == null ? " " : _fullName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
//  Widget _buildFullName() {
//    TextStyle _nameTextStyle = TextStyle(
//      color: Colors.black,
//      fontSize: 20.0,
//      fontWeight: FontWeight.w500,
//    );
//
//    return Text(
//      _fullName == null ? " " : _fullName,
//      style: _nameTextStyle,
//    );
//  }

  Widget _boxMenu(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
//        child: Features.length > 0?
        child: Features.length > 0?GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            crossAxisCount: 1,
            childAspectRatio: 1.0 / 0.3,
            padding: const EdgeInsets.all(10),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            children: [
              {
                "icon": "assets/icons/icons_peserta.png",
                "title": allTranslations.text("btn_history_request"),
                "type": "page",
                "page": PengajuanBarangPage(),
                "status": findData(Features, "m0002")[0].status,
                "color": 0xFF74b9ff
              },
              {
                "icon": "assets/icons/icons_riwayat.png",
                "title": "History Absen",
                "type": "page",
                "page": ReportPage(),
                "status": findData(Features, "m0003")[0].status,
                "color": 0xFFFE5661
              },
              {
                "icon": "assets/icons/ic_history_klaim.png",
                "title": allTranslations.text("btn_pekerjaan"),
                "type": "page",
                "page": PekerjaanPage(),
                "status": findData(Features, "m0004")[0].status,
                "color": 0xFFFE5661
              },
              {
                "icon": "assets/icons/ic_history_klaim.png",
                "title": "Car Checking",
                "type": "page",
                "page": ListWorkingCarBefore(),
                "status": findData(Features, "m0004")[0].status,
                "color": 0xFFFE5661
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
            }).toList()):null);
  }

  Widget _bgBox(BuildContext context) {
    return new Container(
      child: Image.asset(
        'assets/images/bg_box.png',
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
      alignment: FractionalOffset.topCenter,
      // decoration: BoxDecoration(color: Colors.transparent),
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
              Container(
                margin: new EdgeInsets.symmetric(vertical: 230.0),
                child: new Center(
                  child: new Image.asset(
                    'assets/images/bg_box.png',
                    width: screenSize.width,
                    height: screenSize.height / 2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Center(
              //   child: new Image.asset(
              //     'assets/images/bg_box.png',
              //     width: screenSize.width,
              //     height: screenSize.height / 2,
              //     fit: BoxFit.cover,
              //   ),
              // ),
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
                    onPressed: () {
                      routeToWidget(context, new SettingsPage());
                    },
                  ),
                ),
              )),
              SafeArea(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: screenSize.height / 7),
                    _buildProfileImage(),
                    SizedBox(height: 10),
                    _buildFullName(),
                    // _bgBox(context),
                    _boxMenu(context),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          elevation: 5,
                        ))
                  ],
                ),
              ),
            ],
          ))),
            floatingActionButton: findData(Features, "m0001")[0].status == true ? Container(
              padding: EdgeInsets.only(bottom: 50.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _AbsenKeluar != ""
                    ? Container()
                    : FloatingActionButton.extended(
                        onPressed: () {
                          routeToWidget(
                              context,
                              AbsensiPage(
                                action: _AbsenMasuk == "" ? "masuk" : "pulang",
                              ));
                        },
                        backgroundColor: CorpToyogaColor,
                        icon: Icon(Icons.timer),
                        label: TextWidget(
                          txt: _AbsenMasuk == ""
                              ? allTranslations.text("txt_absen_masuk")
                              : allTranslations.text("txt_absen_pulang"),
                          txtSize: 13.5,
                          color: Colors.white,
                        ),
                      ),
              ),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//      floatingActionButton: Container(
//        padding: EdgeInsets.only(bottom: 50.0),
//        child: Align(
//          alignment: Alignment.bottomCenter,
//          child: _AbsenKeluar != ""
//              ? Container()
//              : FloatingActionButton.extended(
//                  onPressed: () {
//                    routeToWidget(
//                        context,
//                        AbsensiPage(
//                          action: _AbsenMasuk == "" ? "masuk" : "pulang",
//                        ));
//                  },
//                  backgroundColor: CorpToyogaColor,
//                  icon: Icon(Icons.timer),
//                  label: TextWidget(
//                    txt: _AbsenMasuk == ""
//                        ? allTranslations.text("txt_absen_masuk")
//                        : allTranslations.text("txt_absen_pulang"),
//                    txtSize: 13.5,
//                    color: Colors.white,
//                  ),
//                ),
//        ),
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _logout() {
    SharedPreferencesHelper.clearAllPreference();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => PreLoginActivity()),
        (Route<dynamic> route) => false);
  }

  _initview() async {



    DateTime now = DateTime.now();
    String formattedDate = DateFormat('y-MM-d').format(now);
    setState(() {
      waktu = formattedDate;
      _isLoading = false;
    });

    print(waktu);

    SharedPreferencesHelper.getFeature().then((feature){
      print("data : " + feature);
      final configGetFeaturesModel  = ConfigGetFeaturesModel.fromJson(json.decode(feature));
      Features = configGetFeaturesModel.data;

      setState(() {
        Features = configGetFeaturesModel.data;

      });
    });

    SharedPreferencesHelper.getDoLogin().then((member) async {
      final memberModels = MemberModels.fromJson(json.decode(member));
      setState(() {
        _fullName = memberModels.data.nama_user;
        _long = memberModels.data.longitude;
        _lat = memberModels.data.latitude;
        _username = memberModels.data.username;
        _idUser = memberModels.data.id_user;
        _firebaseMessaging.unsubscribeFromTopic('notifUpdate');
        _firebaseMessaging.subscribeToTopic('notifUpdate');
        _firebaseMessaging.getToken().then((token) {
          print(token);
        });
//        if(_idUser != null)
//        {
//          _firebaseMessaging.subscribeToTopic('all');
//        }
      });

      ReqHistoryAbsen params = ReqHistoryAbsen(
          id_pegawai: memberModels.data.id_user, tanggal: waktu);

      await todayBloc.bloc.doGetTodayAbsen(params.toMap(),
          (status, error, message, model) {
        AbsenModels absenModels = model;
        print(absenModels.data.length);
        setState(() {
          jumlah = absenModels.data.length;
          if (jumlah != 0) {
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

      var data = {
        "id_user": _idUser,
        "username": _username,
      };
      await CheckUserBloc.actForgotPass(data, (status, message) {
        
        print(message);
        if (message == "not avail") {
          _logout();
        }
      });

      await checkVersion();

     // findData(Features, "m0005")[0].status == true ? checkVersion() : null;

    });
  }
}
