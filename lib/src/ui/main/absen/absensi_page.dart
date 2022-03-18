import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:geofancing/src/bloc/request/req_jarak.dart';
import 'package:geofancing/src/models/standart_model.dart';
import 'package:geofancing/src/ui/main/absen/takefoto_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/utility/colors.dart';
import 'package:geofancing/src/utility/sharedpreferences.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/widgets/Strings.dart';
import 'package:geofancing/src/utility/utils.dart' as Utils;
import 'package:geofancing/src/models/members_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as pref;
import 'package:location/location.dart';
import 'package:geofancing/src/models/jarak_model.dart';
import 'package:geofancing/src/bloc/jarak_bloc.dart';
import 'package:ntp/ntp.dart';
import 'package:trust_location/trust_location.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/widgets/ButtonWidgetLoading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AbsensiPage extends StatefulWidget {
  String action;
  String Jarak;
  @override
  _AbsensiPageState createState() => _AbsensiPageState();

  AbsensiPage({this.action, this.Jarak});
}

class _AbsensiPageState extends State<AbsensiPage> {
  bool _isLoading = true;
  int jarak;
  String _fullName;
  String _AksesKhusus;
  double _lat, _long;
  final pref.Distance distance = new pref.Distance();
  LatLng _latlng;
  LatLng _latlng2;

  bool _isButtonDisable = true;

  bool _isMockLocation = false;

//  bool _isButtonDisabled = true;

  double _totalMeters = 0;
  Location _locationTracker = Location();

  final JarakBloc bloc = JarakBloc();

  BitmapDescriptor pinLocationIcon;

  final Set<Marker> _markers = Set();

  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  GoogleMapController _controller;
  final Set<Marker> _doMarkers = Set();

  String formattedDate = "";

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Marker marker;
  Circle circle;
//  Marker _buildingMarker;
//  Marker _doMarker;

  StreamSubscription _locationSubscription;

  final pref.Distance sDistance = new pref.Distance();

  double latitude = 0.0, longitude = 0.0;
  Map<String, double> userLocation;

  final ButtonWidgetLoadController _btnRetryController = new ButtonWidgetLoadController();

  bool hasInternet = false;
  ConnectivityResult resultOfConnectivity = ConnectivityResult.none;
  StreamSubscription subscription;
  StreamSubscription internetSubscription;

  static final CameraPosition initiallocation = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );

  void initState() {
    super.initState();
//    _isButtonDisabled = true;
    new Timer(const Duration(milliseconds: 150), () {
      _inivtiew();

    });


  }

   dispose() {
    super.dispose();

    subscription.cancel();
    internetSubscription.cancel();
  }

  Future<void> NTPTime() async {
    DateTime _myTime;

    /// Or you could get NTP current (It will call DateTime.now() and add NTP offset to it)
    _myTime = await NTP.now();

    formattedDate = DateFormat('y-MM-d').format(_myTime);
  }

  Future<void> isMockLocation() async {
    bool _detectMockLocation;

    _detectMockLocation = await TrustLocation.isMockLocation;

    _isMockLocation = _detectMockLocation;

//    setState(() {
    if (_isMockLocation == true) {
      showAlertDialog(context, allTranslations.text("txt_ilegal_program"));
      _isButtonDisable = false;
    } else {
      _isButtonDisable = true;
    }
//    });
//     print("data mock ${_isMockLocation}");
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => isMockLocation());
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(allTranslations.text("btn_absen"),
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: CorpToyogaColor),
      body: ProgressDialog(
        inAsyncCall: _isLoading,
        child: this.hasInternet ? Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                initialCameraPosition: initiallocation,
                markers: Set.of((_markers != null ? _markers : [])),
                circles: Set.of((circle != null ? [circle] : [])),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                }
            ),
            Container(
                padding: EdgeInsets.only(left: 10, bottom: 20, right: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                      bottom: 0,
                      child: Card(
                        elevation: 5,
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.elliptical(150, 30)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Container(
                            child: TextWidget(
                              txt: allTranslations.text('txt_tanggal') +
                                  " : " +
                                  formattedDate,
                              txtSize: 20,
                              color: CorpToyogaColor,
                              weight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.only(bottom: 15),
                          ),
                          Container(
                            child: TextWidget(
                              txt: "Jarak dengan kantor anda " +
                                  _totalMeters.toString() +
                                  " m",
                              txtSize: 16,
                              color: CorpToyogaColor,
                            ),
                            padding: const EdgeInsets.only(bottom: 15),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: () => getCurrentLocation(),
                                    color: Colors.white,
                                    textColor: CorpToyogaColor,
                                    child: Container(
                                      width:
                                      MediaQuery.of(context).size.width / 4,
                                      child: TextWidget(
                                        txt: "Refresh",
                                        txtSize: 15,
                                        color: CorpToyogaColor,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
//                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
//                      child: Container(),
                                  ),
                                  RaisedButton(
                                    onPressed: () => _isButtonDisable
                                        ? _ValidationChecking(
                                        _totalMeters, _latlng)
                                        : null,
                                    color: CorpToyogaColor,
                                    textColor: Colors.white,
                                    child: Container(
                                      width:
                                      MediaQuery.of(context).size.width / 4,
                                      child: TextWidget(
                                        txt: allTranslations
                                            .text('btn_attendance'),
                                        txtSize: 12,
                                        color: Colors.white,
                                        weight: FontWeight.bold,
                                      ),
                                    ),
//                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
//                      child: Container(),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(bottom: 15)),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ],
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Align(
                  alignment: AlignmentDirectional.center,
                  child: Image.asset(
                    "assets/images/img_no_network.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom : 32, left: 21, right: 21),
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: ButtonWidgetLoad(
                    child: TextWidget(
                      txt: "RETRY",
                      color: Colors.white,
                      txtSize: 14,
                      fontFamily: 'Bold',
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    borderRadius: 15.0,
                    color: Colors.redAccent[400],
                    successColor: Colors.redAccent[400],
                    controller: _btnRetryController,
                    onPressed: () => _navigationPage()
                ),
              ),
            )
          ],
        ),
      ),
    );

  }

  _navigationPage() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Navigator.pop(context);
        // Navigator.of(context, rootNavigator: true).pop(context);
        Navigator.of(context).pop();
      }
    } on SocketException catch (_) {
      Navigator.of(context).pushReplacementNamed('/splashscreen');
    }
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/icons/pin_location.png");
    return byteData.buffer.asUint8List();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 4.5),
        'assets/icons/marker_home.png');
  }

  void updateMarkerAndCircle(
      LocationData newLocationData, Uint8List imageData, int jarak) async {
    LatLng latlngCirlce = LatLng(_long, _lat);
    _latlng = LatLng(newLocationData.latitude, newLocationData.longitude);
    _latlng2 = LatLng(_lat, _long);

    double resultJarak = jarak.toDouble();

    // print("data jarak to double " + resultJarak.toString());

    setState(() {
      _markers.addAll([
        Marker(
            markerId: MarkerId('home'),
            position: _latlng,
//            rotation: newLocationData.heading,
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: BitmapDescriptor.fromBytes(imageData)),
        Marker(
          markerId: MarkerId('working'),
          position: _latlng2,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: pinLocationIcon,
        ),
      ]);

      circle = Circle(
          circleId: CircleId("car"),
          radius: resultJarak,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: _latlng2,
          fillColor: Colors.blue.withAlpha(70));
    });

    _totalMeters = sDistance(new pref.LatLng(_lat, _long),
        new pref.LatLng(newLocationData.latitude, newLocationData.longitude));
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();

      _locationTracker.changeSettings(
          accuracy: LocationAccuracy.HIGH, interval: 0, distanceFilter: 0);
      var posisi = await _locationTracker.getLocation();
      print(posisi);
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              target: LatLng(posisi.latitude, posisi.longitude),
              tilt: 0,
              zoom: 18.00)));

      // print("Lokasi : " +
      //     posisi.latitude.toString() +
      //     "," +
      //     posisi.longitude.toString());

      updateMarkerAndCircle(posisi, imageData, jarak);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

//      await isMockLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  _ValidationChecking(double _Meters, LatLng ltlng) {
    if (_AksesKhusus != "Y") {
      if (_Meters == null || _Meters > jarak) {
        showAlertDialog(context, allTranslations.text("txt_notif_absen"));
      } else {
        Utils.routeToWidget(
            context,
            TakeFotoPage(
                action: widget.action, RangeAbsen: _totalMeters.toString()));
      }
    } else {
      Utils.routeToWidget(
          context,
          TakeFotoPage(
              action: widget.action, RangeAbsen: _totalMeters.toString()));
    }
  }

  _inivtiew() async {
    SharedPreferencesHelper.getDoLogin().then((member) async {
      final memberModels = MemberModels.fromJson(json.decode(member));
      setState(() {
        NTPTime();

        _fullName = memberModels.data.nama_user;
        _long = memberModels.data.longitude;
        _lat = memberModels.data.latitude;
        _AksesKhusus = memberModels.data.user_khusus;
        // print(_AksesKhusus);
      });

      reqJarak params = reqJarak(app_id: appid);

      await bloc.doJarak(params.toMap(), (status, message, model) {
        setState(() {
          jarak = model.data[0].jarak;
          // print("data jarak : " + jarak.toString());
        });
      });
      subscription = Connectivity().onConnectivityChanged.listen((result) {
        // Got a new connectivity status!
        setState(() {
          this.resultOfConnectivity  = result;
          print("data connecitvity : $result");
        });
      });

      internetSubscription = InternetConnectionChecker().onStatusChange.listen((status){
          final hasInternet = status == InternetConnectionStatus.connected;

          setState(() {
            this.hasInternet = hasInternet;
            print("data status $hasInternet");
          });
      });

      getCurrentLocation();
      setCustomMapPin();
    });



    setState(() {
      _isLoading = false;
    });
  }

  Future<Uint8List> getBytesFromCanvas(int width, int height) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.blue;
    final Radius radius = Radius.circular(20.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  showAlertDialog(BuildContext context, message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
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
