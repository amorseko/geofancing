import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/utility/colors.dart';
import 'package:geofancing/src/utility/sharedpreferences.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/widgets/Strings.dart';
import 'package:geofancing/src/utility/utils.dart' as  Utils;
import 'package:geofancing/src/models/members_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart' as pref;

class AbsensiPage extends StatefulWidget {
  @override
  _AbsensiPageState createState() => _AbsensiPageState();
}


class _AbsensiPageState extends State<AbsensiPage> {
  bool _isLoading = true;
  String _fullName;

  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);

//  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _controller;
  final Set<Marker> _markers = Set();

  static var today = new DateTime.now();
  String formattedDate = DateFormat('d' + '-' + 'MMMM' + '-' + 'y').format(today);


  final _scaffoldKey = GlobalKey<ScaffoldState>();

//  final Set<Marker> _markers = {};
  var Lok = new Location();

  Marker marker;
  Circle circle;
  Location _locationTracker = Location();



  StreamSubscription _locationSubscription;

  double latitude = 0.0,
      longitude = 0.0;
  Map<String, double> userLocation;
  final Location location = Location();
  final LatLng _currentPosition = LatLng(3.595196, 98.672226);

  static final CameraPosition initiallocation = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );


  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 0)).then((_) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          enableDrag: false,
          builder: (builder) {
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
                      borderRadius: BorderRadius.vertical(top: Radius.elliptical(150, 30)),
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
                            color : Colors.white,
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
//
                      SizedBox(height: 20),
                      Container(
                        child :
                        TextWidget(
                          txt: allTranslations.text('txt_tanggal') + " : " + formattedDate,
                          txtSize: 20,
                          color: Colors.lightBlueAccent,
                          weight: FontWeight.bold,

                        ),
                        padding: const EdgeInsets.only(bottom: 15),
                      ),

                      Container(
                          child: RaisedButton(
                            onPressed: () async {
//                        Navigator.pop(context);
                            },
                            color : Colors.lightBlueAccent,
                            textColor: Colors.white,
                            child: TextWidget(
                              txt: allTranslations.text('btn_attendance'),
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
                          padding:const EdgeInsets.only(bottom: 15)
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
    });
    new Timer(const Duration(milliseconds: 150), () {
//      _getLocationData();
      getCurrentLocation();
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
          backgroundColor: Colors.white
      ),
      body: ProgressDialog(
        inAsyncCall: _isLoading,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: initiallocation,
                markers: Set.of((marker != null ? [marker] : [])),
                circles: Set.of((circle != null ? [circle] : [])),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_searching),
        onPressed: () {
          getCurrentLocation();
        },
      ),


    );
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(
        "assets/icons/car_icon.png");
    return byteData.buffer.asUint8List();
  }




  void updateMarkerAndCircle(LocationData newLocationData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocationData.latitude, newLocationData.longitude);
    print(latlng);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId('home'),
          position: latlng,
          rotation: newLocationData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocationData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();

      var Location = await _locationTracker.getLocation();

      updateMarkerAndCircle(Location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
            if (_controller != null) {
              _controller.animateCamera(
                  CameraUpdate.newCameraPosition(new CameraPosition(
                      bearing: 192.83349401395799,
                      target: LatLng(
                          newLocalData.latitude, newLocalData.longitude),
                      tilt: 0,
                      zoom: 18.00
                  )));
              updateMarkerAndCircle(newLocalData, imageData);
            }
          });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  _inivtiew() async {

    print("tanggal : " + formattedDate);
    SharedPreferencesHelper.getDoLogin().then((member) {
      final memberModels = MemberModels.fromJson(json.decode(member));
      setState(() {
        _fullName = memberModels.data.nama_user;
      });
    });
    setState(() {
      _isLoading = false;
    });
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



