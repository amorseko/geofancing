import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui';
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


class AbsensiPage extends StatefulWidget {
  String action;
  @override
  _AbsensiPageState createState() => _AbsensiPageState();

  AbsensiPage({this.action});
}

class _AbsensiPageState extends State<AbsensiPage> {
  bool _isLoading = true;
  int jarak;
  String _fullName;
  double _lat, _long;
  final pref.Distance distance = new pref.Distance();
  LatLng _latlng;
  LatLng _latlng2;

  bool _isButtonDisabled = false;

  double _totalMeters = 0;
  Location _locationTracker = Location();

  final JarakBloc bloc = JarakBloc();


  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  GoogleMapController _controller;
  final Set<Marker> _markers = Set();

  static var today = new DateTime.now();
  String formattedDate =
      DateFormat('d' + ' ' + 'MMMM' + ' ' + 'y').format(today);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

//  final Set<Marker> _markers = {};

  Marker marker;
  Circle circle;



  StreamSubscription _locationSubscription;

  final pref.Distance sDistance = new pref.Distance();

  double latitude = 0.0, longitude = 0.0;
  Map<String, double> userLocation;

  static final CameraPosition initiallocation = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );

  void initState() {
    super.initState();
    _isButtonDisabled = true;
    new Timer(const Duration(milliseconds: 150), () {
      _inivtiew();
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
//          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(allTranslations.text("btn_absen"),
              style: TextStyle(color: coorporateColor)),
          centerTitle: true,
          backgroundColor: Colors.white),
      body: ProgressDialog(
        inAsyncCall: _isLoading,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[

            GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                initialCameraPosition: initiallocation,
                markers: Set.of((marker != null ? [marker] : [])),
                circles: Set.of((circle != null ? [circle] : [])),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                }),
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
                            color: Colors.lightBlueAccent,
                            weight: FontWeight.bold,
                          ),
                          padding: const EdgeInsets.only(bottom: 15),
                        ),
                        Container(
                          child: TextWidget(
                            txt: "Jarak dengan kantor anda " +  _totalMeters.toString() + " m",
                            txtSize: 16,
                            color: Colors.lightBlueAccent,
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
                                  textColor: Colors.lightBlueAccent,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 4,
                                    child: TextWidget(
                                      txt: "Refresh",
                                      txtSize: 15,
                                      color: Colors.lightBlueAccent,
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
                                  onPressed: () =>_ValidationChecking(_totalMeters,_latlng),
                                  color: Colors.lightBlueAccent,
                                  textColor: Colors.white,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 4,
                                    child: TextWidget(
                                      txt: allTranslations.text('btn_attendance'),
                                      txtSize: 15,
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
                            padding: const EdgeInsets.only(bottom: 15)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/icons/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocationData, Uint8List imageData) async{
    LatLng latlngCirlce = LatLng(_long, _lat);
    _latlng = LatLng(newLocationData.latitude, newLocationData.longitude);
    _latlng2 = LatLng(_lat,_long);


    setState(() {
      marker = Marker(
          markerId: MarkerId('home'),
          position: _latlng,
          rotation: newLocationData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));

      circle = Circle(
          circleId: CircleId("car"),
          radius: 50,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: _latlng2,
          fillColor: Colors.blue.withAlpha(70));
    });

    _totalMeters = sDistance(
        new pref.LatLng(_lat, _long),
        new pref.LatLng(newLocationData.latitude, newLocationData.longitude));


  }


  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();

      _locationTracker.changeSettings(accuracy: LocationAccuracy.HIGH, interval: 0, distanceFilter: 0);
      var posisi = await _locationTracker.getLocation();


      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              target: LatLng(posisi.latitude, posisi.longitude),
              tilt: 0,
              zoom: 18.00))
      );

      print("Lokasi : " + posisi.latitude.toString() + "," + posisi.longitude.toString());


      updateMarkerAndCircle(posisi, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

//      _locationSubscription =
//          _locationTracker.onLocationChanged().listen((newLocalData) {
//            if (_controller != null) {
//              _controller.animateCamera(CameraUpdate.newCameraPosition(
//                  new CameraPosition(
//                      target: LatLng(newLocalData.latitude, newLocalData.longitude),
//                      tilt: 0,
//                      zoom: 18.00))
//              );
//              updateMarkerAndCircle(newLocalData, imageData);
////              getCurrentMeters(newLocalData);
//            }
//          });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }
  _ValidationChecking(double _Meters, LatLng ltlng) {
    if(_Meters == null || _Meters > jarak) {
      showAlertDialog(context, allTranslations.text("txt_notif_absen"));
    }else{
      Utils.routeToWidget(context, TakeFotoPage(action: widget.action,));
    }
  }

  _inivtiew() async {
    SharedPreferencesHelper.getDoLogin().then((member) async {
      final memberModels = MemberModels.fromJson(json.decode(member));
      setState(() {
        _fullName = memberModels.data.nama_user;
        _long = memberModels.data.longitude;
        _lat = memberModels.data.latitude;
      });

//      _doCheckJarak();

      reqJarak params = reqJarak(
          app_id: appid
      );

      await bloc.doJarak(params.toMap(), (status, message, model) {
        setState(() {
          jarak  = model.data[0].jarak;
          print("data jarak : " + jarak.toString());
        });
      });
    });



    getCurrentLocation();

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

  _renderView(BuildContext context) {
    showBottomSheet(
        context: context,
        builder: (context) => Container(
              color: Colors.red,
            ));
    setState(() {
      _isLoading = false;
    });
  }

}
