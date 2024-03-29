import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geofancing/src/bloc/absen_bloc.dart';
import 'package:geofancing/src/models/default_model.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/ui/main/main_page.dart';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:ntp/ntp.dart';

class SubmitAbsenPage extends StatefulWidget {
  String imagePath;
  String action;
  String RangeAbsen;

  @override
  _SubmitAbsenPageState createState() => _SubmitAbsenPageState();

  SubmitAbsenPage({this.imagePath, this.action, this.RangeAbsen});
}

class _SubmitAbsenPageState extends State<SubmitAbsenPage> {
  String name, id_user, id_dealer;
  String waktu = "";
  bool _isLoading = false;
  bool _isHide = false;
  Location _locationTracker = Location();
  TextEditingController _txtEntry = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initView();
  }

  void _toggle() async {
    setState(() {
      widget.action == "masuk" ? _isHide = false : _isHide = true;
    });
  }

  Future<void> NTPTime() async {
    DateTime _myTime;

    /// Or you could get NTP current (It will call DateTime.now() and add NTP offset to it)
    _myTime = await NTP.now();

    waktu = DateFormat('y-MM-d kk:mm:ss').format(_myTime);
    print(waktu);
  }

  Widget _bgTime(BuildContext context) {
    return new Container(
      child: Image.asset(
        'assets/images/time_management.png',
        width: MediaQuery.of(context).size.width,
      ),
      alignment: FractionalOffset.topCenter,
      decoration: BoxDecoration(color: Colors.transparent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Preview", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: CorpToyogaColor),
      body: ProgressDialog(
        inAsyncCall: _isLoading,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: new BoxDecoration(
                      border: Border.all(color: CorpToyogaColor, width: 2),
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(widget.imagePath))))),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                waktu != null ? waktu : " ",
                style: TextStyle(fontSize: 24),
              ),
              Text(
                name != null ? name : " ",
                style: TextStyle(fontSize: 24),
              ),
              _buildDropDown(_isHide), //for hide and show textformfield
              SizedBox(
                height: 20,
              ),
              // _bgTime(context),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: ButtonTheme(
                  child: new RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      allTranslations.text("btn_absen"),
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    elevation: 4.0,
                    color: CorpToyogaColor,
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      submitAbsen();
                    },
                  ),
                  height: 50.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  initView() async {
    SharedPreferencesHelper.getDoLogin().then((value) async {
      DateTime startDate = await NTP.now();
      final member = MemberModels.fromJson(json.decode(value));
      setState(() {
//        NTPTime();
       // _toggle();
        waktu = DateFormat('y-MM-d kk:mm:ss').format(startDate);
        name = member.data.nama_user;
        id_user = member.data.id_user;
        id_dealer = member.data.id_dealer;
        widget.action == "masuk" ? _isHide = false : _isHide = true;
      });
    });

//    DateTime now = DateTime.now();
//    String formattedDate = DateFormat('y-MM-d kk:mm:ss').format(now);
    setState(() {
      _isLoading = false;
//      waktu  = formattedDate;
    });
  }

  _buildDropDown(bool enable) {
    if (enable) {
      return TextFormField(
        controller: _txtEntry,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Entry",
        ),
      );
    } else {
      // Just Divider with zero Height xD
      return Divider(color: Colors.white, height: 0.0);
    }
  }

  submitAbsen() async {
    setState(() {
      _isLoading = true;
    });

    _locationTracker.changeSettings(
        accuracy: LocationAccuracy.high, interval: 0, distanceFilter: 0);
    var posisi = await _locationTracker.getLocation();
    String lokasiAbsen =
        posisi.latitude.toString() + ", " + posisi.longitude.toString();

    String fileName = widget.imagePath.split('/').last;
    print(fileName);
    print(widget.imagePath);
    print(waktu.split(" ")[1]);
    print("range area : " + widget.RangeAbsen);
    var formData = FormData.fromMap({
      'jam': waktu.split(" ")[1],
      'tanggal': waktu.split(" ")[0],
      'koordinat': lokasiAbsen,
      'id_pegawai': id_user,
      'upfile':
          await MultipartFile.fromFile(widget.imagePath, filename: fileName),
      'status_absen': widget.action == "masuk" ? 0 : 1,
      'range_absen': widget.RangeAbsen.toString(),
      'entry': _txtEntry.text,
      'id_dealer': id_dealer,
    });
    bloc.doAbsen(formData, (callback) {
      DefaultModel model = callback;
//      print(model.message);

      setState(() {
        _isLoading = false;
      });
      if (model.status == "success") {
        showErrorMessage(context, model.message, model.status);
      } else {
        print(model.message);
        showErrorMessage(context, model.message, model.status);
      }
    });
  }

  void showErrorMessage(BuildContext context, message, status) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 5.5,
            child: new SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
              // height: MediaQuery.of(context).size.width / 2,
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
                                  Text(
                                    (status == "success")
                                        ? allTranslations.text("msg_absen")
                                        : (message == "not accept")
                                            ? allTranslations
                                                .text('txt_not_accept')
                                            : message,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (status == "success") {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            "/main_page",
                                            (_) => false);
                                      } else {
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
                                            color: CorpToyogaColor),
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
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
            ),
          );
        });
  }
}
