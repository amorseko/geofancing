import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'dart:async';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geofancing/src/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geofancing/src/widgets/additional_widgets.dart';
import 'package:geofancing/src/widgets/ButtonWidgetLoading.dart';
import 'package:geofancing/src/bloc/car_before_save_bloc.dart';
import 'package:geofancing/src/models/default_model.dart';

class CarWorkingBeforePage extends StatefulWidget {
  String pekerjaan;

  @override
  State<StatefulWidget> createState() => _CarWorkingBeforePage();

  CarWorkingBeforePage({this.pekerjaan});

}

class _CarWorkingBeforePage extends State<CarWorkingBeforePage> {

  final _namaUserController = TextEditingController();
  final _namaSAController = TextEditingController();
  final _nopolController = TextEditingController();
  final _modelMobilController = TextEditingController();
  final _kmController = TextEditingController();
  final _filterController = TextEditingController();
  final _blowerController = TextEditingController();
  final _perawatanController = TextEditingController();
  final _penggantianController = TextEditingController();
  final _hpController = TextEditingController();
  final _lpController = TextEditingController();
  final _suhuController = TextEditingController();
  final _windSpeedController = TextEditingController();

  final _hpNormalController = TextEditingController();
  final _lpNormalController = TextEditingController();
  final _suhuNormalController = TextEditingController();
  final _windSpeedNormalController = TextEditingController();

  final ButtonWidgetLoadController _btnSaveController = new ButtonWidgetLoadController();


  String _retrieveDataError;

  List listImage = List();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  XFile _imageFile;
  bool isVideo = false;

  bool _isLoading = true;
  String name, id_user, id_dealer, _pekerjaan;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text("Car Working Before", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            backgroundColor: CorpToyogaColor
        ),
        body: ProgressDialog(
          inAsyncCall: _isLoading,
          child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              child: Stack(
                children: <Widget> [
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget> [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white70,
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      TextWidget(
                                        txt:  DateFormat(
                                            "EEEE","id_ID"
                                        ).format(DateTime.now()),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      TextWidget(
                                          txt: DateFormat(
                                              "d-MM-yyyy | HH:mm:ss", "id_ID"
                                          ).format(DateTime.now())
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget> [
                                      new Expanded(
                                          child: new TextWidget(
                                            txt: "Nama User",
                                            align: TextAlign.justify,
                                          )
                                      ),
                                      new Expanded(
                                          flex: 3,
                                          child: new TextFieldWidget(
                                            _namaUserController,
                                            hint: "Nama User",
                                            readOnly : true,
                                          )
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                      children: <Widget> [
                                        new Expanded(
                                            child: new TextWidget(
                                              txt: "Nama SA",
                                              align: TextAlign.justify,
                                            )
                                        ),
                                        new Expanded(
                                            flex: 3,
                                            child: new TextFieldWidget(
                                              _namaSAController,
                                              hint: "Nama SA",
                                              readOnly : false,
                                            )
                                        )
                                      ]
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                      children: <Widget> [
                                        new Expanded(
                                            child: new TextWidget(
                                              txt: "Nomor Polisi",
                                              align: TextAlign.justify,
                                            )
                                        ),
                                        new Expanded(
                                            flex: 3,
                                            child: new TextFieldWidget(
                                              _nopolController,
                                              hint: "Nomor Polisi",
                                            )
                                        )
                                      ]
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                      children: <Widget> [
                                        new Expanded(
                                            child: new TextWidget(
                                              txt: "Model",
                                              align: TextAlign.justify,
                                            )
                                        ),
                                        new Expanded(
                                            flex: 3,
                                            child: new TextFieldWidget(
                                              _modelMobilController,
                                              hint: "Model",
                                            )
                                        )
                                      ]
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                      children: <Widget> [
                                        new Expanded(
                                            child: new TextWidget(
                                              txt: "KM",
                                              align: TextAlign.justify,
                                            )
                                        ),
                                        new Expanded(
                                            flex: 3,
                                            child: new TextFieldWidget(
                                              _kmController,
                                              keyboardType: TextInputType.numberWithOptions(),
                                              hint: "KM",
                                            )
                                        )
                                      ]
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          _hasilCheck(context),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: <Widget>[
                              _kmWidget(context),
                              _tampakDepan(context),

                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _pekerjaan == "Pekerjaan Kecil" ?
                          Row(
                            children: <Widget>[
                              _filterWidget(context),
                              _suhuWindspeedWidget(context),

                            ],
                          ) : Container(),
                          _pekerjaan == "Pekerjaan Kecil" ? SizedBox(height: 20,) : SizedBox(),
                          _pekerjaan == "Pekerjaan Kecil" ? Row(
                            children: <Widget>[
                              _blowerWidget(context),

                            ],
                          ) : Container(),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white70,
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: new TextWidget(
                                            txt: "Filter",
                                            align: TextAlign.justify,
                                          )
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: new TextFieldWidget(
                                              _filterController,
                                              hint: "Filter",
                                            )
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: new TextWidget(
                                                txt: "Blower",
                                                align: TextAlign.justify,
                                            )
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: new TextFieldWidget(
                                              _blowerController,
                                              hint: "blower",
                                            )
                                        ),
                                      ],
                                    )
                                  ]
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          _saranPerbaikian(context),
                          SizedBox(
                            height: 16,
                          ),
                          _buttonBottom(context),
                        ],
                      )
                    )
                  ),

                ],
              ),
          ),
        ),

    );
  }

  void _showAlert(BuildContext context, String _textAlert) {
    _btnSaveController.reset();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Alert"),
          content: Text(_textAlert),
        )
    );
  }

  _onSaveData(BuildContext context) async {

    // var formData = FormData();

    if(_namaSAController.text == "") {
      _showAlert(context, "Nama SA Tidak Boleh Kosong !");
      return;
    }

    if(_namaUserController.text == "") {
      _showAlert(context, "Nama User Tidak Boleh Kosong !");
      return;
    }

    if(_nopolController.text == "") {
      _showAlert(context, "Nomor Polisi Kendaraan Tidak Boleh Kosong !");
      return;
    }

    if(_modelMobilController.text == "") {
      _showAlert(context, "Model Mobile Tidak Boleh Kosong !");
      return;
    }

    if(_kmController.text == "") {
      _showAlert(context, "KM Tidak Boleh Kosong !");
      return;
    }

    if(_hpController.text == "") {
      _showAlert(context, "HP Tidak Boleh Kosong !");
      return;
    }

    if(_lpController.text == "") {
      _showAlert(context, "LP Tidak Boleh Kosong !");
      return;
    }

    if(_suhuController.text == "") {
      _showAlert(context, "Suhu Tidak Boleh Kosong !");
      return;
    }

    if(_windSpeedController.text == "") {
      _showAlert(context, "Windpseed Tidak Boleh Kosong !");
      return;
    }

    if(_filterController.text == "") {
      _showAlert(context, "Filter Tidak Boleh Kosong !");
      return;
    }

    if(_blowerController.text == "") {
      _showAlert(context, "Blower Tidak Boleh Kosong !");
      return;
    }

    if(_perawatanController.text == ""){
      _showAlert(context, "Saran Perawatan Tidak Boleh Kosong !");
      return;
    }

    if(_penggantianController.text == "") {
      _showAlert(context, "Saran Penggantian Tidak Boleh Kosong !");
      return;
    }

    listImage.forEach((element) {
      print(element);
      if(element['path'] == "") {
        if(element['type'] == "D001") {
          _showAlert(context, "Foto KM Tidak Boleh Kosong !");
          return;
        }

        if(element['type'] == "D002") {
          _showAlert(context, "Foto Tampak Depan Tidak Boleh Kosong !");
          return;
        }

        if(_pekerjaan != "Pekerjaan Kecil")
          if(element['type'] == "D003") {
            _showAlert(context, "Foto Filter Tidak Boleh Kosong !");
            return;
          }

          if(element['type'] == "D004") {
            _showAlert(context, "Foto Suhu/Windspeed Tidak Boleh Kosong !");
            return;
          }

        if(element['type'] == "D005") {
          _showAlert(context, "Foto Blower Tidak Boleh Kosong !");
          return;
        }
      }
    });


    setState(() {
      _isLoading = true;
    });

    var formData = FormData.fromMap({
      'id_user': id_user,
      'id_sa': _namaSAController.text,
      'nopol' : _nopolController.text,
      'model' : _modelMobilController.text,
      'KM' : _kmController.text,
      'HP' : _hpController.text,
      'LP' : _lpController.text,
      'suhu' : _suhuController.text,
      'windspeed' : _windSpeedController.text,
      'filter' : _filterController.text,
      'blower' : _blowerController.text,
      'perawatan' : _perawatanController.text,
      'penggantian' : _penggantianController.text,
      "type_working" : "Air Conditioner"
    });

    listImage.forEach((element) {
      formData.files.addAll([
        MapEntry("foto_mobil[]", MultipartFile.fromFileSync(element['path'])),
      ]);
    });


    bloc.doPengajuan(formData, (callback) {
      DefaultModel model = callback;

      setState(() {
        _isLoading = false;
      });

      if(model.status == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(model.message), backgroundColor: Colors.green
        ));
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/list_working_car_before', (Route<dynamic> route) => false);
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(model.message), backgroundColor: Colors.red
        ));
      }

      _btnSaveController.reset();
    });

  }

  void createSnackBar(BuildContext context, String message) {
    final snackBar = new SnackBar(content: new Text(message),
        backgroundColor: Colors.red);

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(context).showSnackBar(snackBar);
  }


Widget _hasilCheck(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.lightGreen, width: 1),
      ),
      color:Colors.white70,
      child: Column(
        children: <Widget> [
          Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Stack(
              children: <Widget>[
                Container(
                  child: Center(
                    child: TextWidget(
                      txt : "Hasil Check",
                      color: Colors.black,
                      weight: FontWeight.bold,
                      align: TextAlign.center,
                      txtSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: TextWidget(
                        txt: "HP",
                        align: TextAlign.justify,
                      )
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: TextFieldWidget(
                        _hpController,
                        keyboardType: TextInputType.numberWithOptions(),
                        hint: "HP",
                        readOnly: _pekerjaan == "Pekerjaan Kecil" ? true : false,
                    ) ,
                  )
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget> [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: TextWidget(
                        txt: "LP",
                        align: TextAlign.justify,
                      )
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: TextFieldWidget(
                        _lpController,
                        keyboardType: TextInputType.numberWithOptions(),
                        hint: "LP",
                        readOnly: _pekerjaan == "Pekerjaan Kecil" ? true : false,
                    ) ,
                  )
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Stack(
              children: <Widget>[
                Container(
                  child: Center(
                    child: TextWidget(
                      txt : "ANEMOMETER",
                      color: Colors.black,
                      weight: FontWeight.bold,
                      align: TextAlign.center,
                      txtSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: TextWidget(
                        txt: "Suhu",
                        align: TextAlign.justify,
                      )
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: TextFieldWidget(
                        _suhuController,
                        keyboardType: TextInputType.numberWithOptions(),
                        hint: "Suhu"
                    ) ,
                  )
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget> [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: TextWidget(
                        txt: "Windspeed",
                        align: TextAlign.justify,
                      )
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: TextFieldWidget(
                        _windSpeedController,
                        keyboardType: TextInputType.numberWithOptions(),
                        hint: "WindSpeed"
                    ) ,
                  )
              ),
            ],
          ),
          Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Stack(
              children: <Widget>[
                Container(
                  child: Center(
                    child: TextWidget(
                      txt : "STANDAR NORMAL",
                      color: Colors.green,
                      weight: FontWeight.bold,
                      align: TextAlign.center,
                      txtSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget> [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: TextWidget(
                        txt: "HP",
                        align: TextAlign.justify,
                        color: Colors.green,
                      )
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: TextFieldWidget(
                        _hpNormalController,
                        hint: "HP",
                        readOnly: true,
                    ) ,
                  )
              ),
            ],
          ),
          Row(
            children: <Widget> [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: TextWidget(
                        txt: "LP",
                        color: Colors.green,
                        align: TextAlign.justify,
                      )
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: TextFieldWidget(
                      _lpNormalController,
                      hint: "LP",
                      readOnly: true,
                    ) ,
                  )
              ),
            ],
          ),
          Row(
            children: <Widget> [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: TextWidget(
                        txt: "Suhu",
                        color: Colors.green,
                        align: TextAlign.justify,
                      )
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: TextFieldWidget(
                      _suhuNormalController,
                      hint: "Suhu",
                      readOnly: true,
                    ) ,
                  )
              ),
            ],
          ),
          Row(
            children: <Widget> [
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: TextWidget(
                        txt: "Windspeed",
                        color: Colors.green,
                        align: TextAlign.justify,
                      )
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: TextFieldWidget(
                      _windSpeedNormalController,
                      hint: "Windspeed",
                      readOnly: true,
                    ) ,
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buttonBottom(BuildContext context) {
    return Align(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 20, 20, 20),
        width: MediaQuery.of(context).size.width / 2,
        child: ButtonWidgetLoad(
          child: TextWidget(
            txt: "SAVE",
            color: Colors.white,
            txtSize: 14,
            fontFamily: 'Bold',
          ),
          width: MediaQuery.of(context).size.width,
          height: 50,
          borderRadius: 15.0,
          color: Colors.redAccent[400],
          successColor: Colors.redAccent[400],
          controller: _btnSaveController,
          onPressed: () => _onSaveData(context),
        ),
      )
    );
  }


  Widget _saranPerbaikian(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: CorpToyogaColor, width: 1),
      ),
      color: Colors.white70,
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Stack(
              children: <Widget>[
                Container(
                  child: Center(
                    child: TextWidget(
                      txt : "Saran Perbaikan",
                      color: Colors.red,
                      weight: FontWeight.bold,
                      align: TextAlign.center,
                      txtSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: TextWidget(
                    txt: "Perawatan",
                    color: Colors.red,
                    align: TextAlign.justify,
                  )
                )
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: TextFieldWidget(
                          _perawatanController,
                          hint: "Perawatan"
                      ) ,
                  )
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: TextWidget(
                        txt: "Penggantian",
                        color: Colors.red,
                        align: TextAlign.justify,
                      )
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: TextFieldWidget(
                        _penggantianController,
                        hint: "Penggantian",
                        maxLines: 10,
                        maxLength: 1000,
                        keyboardType: TextInputType.multiline,
                    ) ,
                  )
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _kmWidget(BuildContext context) {
    return Expanded(
        child: Stack(
            children: <Widget> [
              SizedBox(
                height: 193,
                width: 180,
                child: Card(
                  color: Colors.grey[200],
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 40,
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Row(
                              children: <Widget>[
                                TextWidget(
                                  txt: "KM",
                                  color: Colors.black,
                                  weight: FontWeight.bold,
                                ),
                                TextWidget(
                                  txt: " *",
                                  color: Colors.red,
                                  txtSize: 18,
                                  weight: FontWeight.bold,
                                ),
                              ]
                          )
                        ),
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.16,
                          child: Stack(
                            children: <Widget>[
                              GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                childAspectRatio: 1,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                children: listImage
                                    .where((data) => data['type'] == 'D001')
                                    .map((f) {
                                  if (f['name'] == "button") {
                                    return GestureDetector(
                                      onTap: () {
                                        captureImage('D001');
                                      },
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.black12,
                                              offset: const Offset(0.0, 2.0),
                                              blurRadius: 2.0,
                                              spreadRadius: 2.0,
                                            ),
                                          ],
                                          borderRadius:
                                          new BorderRadius.all(Radius.circular(10.0)),
                                        ),
                                        child: Center(
                                            child: IconButton(
                                              icon: Icon(Icons.add_a_photo),
                                              onPressed: () {
                                                captureImage('D001');
                                              },
                                            )),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Colors.black12,
                                            offset: const Offset(0.0, 2.0),
                                            blurRadius: 2.0,
                                            spreadRadius: 2.0,
                                          ),
                                        ],
                                        borderRadius:
                                        new BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            child: f['status'] == false
                                                ? GestureDetector(
                                              onTap: () {
                                                showImage(context, f['path'],
                                                    "KM" + f['name'], true);
                                              },
                                              child: Image.file(File(f['path_compressed']),
                                                  fit: BoxFit.fitWidth),
                                            )
                                                : GestureDetector(
                                              onTap: () {
                                                showImage(context, f['path'],
                                                    "KM" + f['name'], false);
                                              },
                                              child: Image.file(File(f['path_compressed']),
                                                  fit: BoxFit.fitWidth),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              padding: EdgeInsets.all(3),
                                              margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.all(
                                                      Radius.circular(50.0))),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    print(f['name']);
                                                    deleteFile(f['path']);
                                                    setState(() {
                                                      listImage.removeWhere((item) =>
                                                      item['name'] == f['name']);
                                                    });
                                                    setCam('D001');
                                                  },
                                                  child: Icon(Icons.delete,
                                                      color: Colors.red, size: 15)),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: f['status'] != false
                                                ? Container(
                                              padding: EdgeInsets.all(3),
                                              margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.all(
                                                      Radius.circular(50.0))),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.green,
                                                size: 15,
                                              ),
                                            )
                                                : Container(),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: f['proses'] == true
                                                ? CircularProgressIndicator()
                                                : null,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }).toList(),

                              ),
                            ],
                          ),

                        ),
                      ]
                  ),
                ),
              ),
            ]
        )
    );
  }

  Widget _tampakDepan(BuildContext context) {
    return Expanded(
        child: Stack(
            children: <Widget> [
              SizedBox(
                height: 193,
                width: 180,
                child: Card(
                  color: Colors.grey[200],
                  child: Column(
                      children: <Widget>[
                        Container(
                            height: 40,
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                                children: <Widget>[
                                  TextWidget(
                                    txt: "Tampak Depan",
                                    color: Colors.black,
                                    weight: FontWeight.bold,
                                  ),
                                  TextWidget(
                                    txt: " *",
                                    color: Colors.red,
                                    txtSize: 18,
                                    weight: FontWeight.bold,
                                  ),
                                ]
                            )
                        ),
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.16,
                          child: Stack(
                            children: <Widget>[
                              GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                childAspectRatio: 1,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                children: listImage
                                    .where((data) => data['type'] == 'D002')
                                    .map((f) {
                                  if (f['name'] == "button") {
                                    return GestureDetector(
                                      onTap: () {
                                        captureImage('D002');
                                      },
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.black12,
                                              offset: const Offset(0.0, 2.0),
                                              blurRadius: 2.0,
                                              spreadRadius: 2.0,
                                            ),
                                          ],
                                          borderRadius:
                                          new BorderRadius.all(Radius.circular(10.0)),
                                        ),
                                        child: Center(
                                            child: IconButton(
                                              icon: Icon(Icons.add_a_photo),
                                              onPressed: () {
                                                captureImage('D002');
                                              },
                                            )),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Colors.black12,
                                            offset: const Offset(0.0, 2.0),
                                            blurRadius: 2.0,
                                            spreadRadius: 2.0,
                                          ),
                                        ],
                                        borderRadius:
                                        new BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            child: f['status'] == false
                                                ? GestureDetector(
                                              onTap: () {
                                                showImage(context, f['path'],
                                                    "TDP" + f['name'], true);
                                              },
                                              child: Image.file(File(f['path_compressed']),
                                                  fit: BoxFit.fitWidth),
                                            )
                                                : GestureDetector(
                                              onTap: () {
                                                showImage(context, f['path'],
                                                    "TDP" + f['name'], false);
                                              },
                                              child: Image.file(File(f['path_compressed']),
                                                  fit: BoxFit.fitWidth),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              padding: EdgeInsets.all(3),
                                              margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.all(
                                                      Radius.circular(50.0))),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    print(f['name']);
                                                    deleteFile(f['path']);
                                                    setState(() {
                                                      listImage.removeWhere((item) =>
                                                      item['name'] == f['name']);
                                                    });
                                                    setCam('D002');
                                                  },
                                                  child: Icon(Icons.delete,
                                                      color: Colors.red, size: 15)),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: f['status'] != false
                                                ? Container(
                                              padding: EdgeInsets.all(3),
                                              margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.all(
                                                      Radius.circular(50.0))),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.green,
                                                size: 15,
                                              ),
                                            )
                                                : Container(),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: f['proses'] == true
                                                ? CircularProgressIndicator()
                                                : null,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }).toList(),

                              ),
                            ],
                          ),

                        ),
                      ]
                  ),
                ),
              ),
            ]
        )
    );
  }

  Widget _filterWidget(BuildContext context) {
    return Expanded(
        child: Stack(
            children: <Widget> [
              SizedBox(
                height: 193,
                width: 180,
                child: Card(
                  color: Colors.grey[200],
                  child: Column(
                      children: <Widget>[
                        Container(
                            height: 40,
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                                children: <Widget>[
                                  TextWidget(
                                    txt: "Filter",
                                    color: Colors.black,
                                    weight: FontWeight.bold,
                                  ),
                                  TextWidget(
                                    txt: " *",
                                    color: Colors.red,
                                    txtSize: 18,
                                    weight: FontWeight.bold,
                                  ),
                                ]
                            )
                        ),
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.16,
                          child: Stack(
                            children: <Widget>[
                              GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                childAspectRatio: 1,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                children: listImage
                                    .where((data) => data['type'] == 'D003')
                                    .map((f) {
                                  if (f['name'] == "button") {
                                    return GestureDetector(
                                      onTap: () {
                                        captureImage('D003');
                                      },
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.black12,
                                              offset: const Offset(0.0, 2.0),
                                              blurRadius: 2.0,
                                              spreadRadius: 2.0,
                                            ),
                                          ],
                                          borderRadius:
                                          new BorderRadius.all(Radius.circular(10.0)),
                                        ),
                                        child: Center(
                                            child: IconButton(
                                              icon: Icon(Icons.add_a_photo),
                                              onPressed: () {
                                                captureImage('D003');
                                              },
                                            )),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Colors.black12,
                                            offset: const Offset(0.0, 2.0),
                                            blurRadius: 2.0,
                                            spreadRadius: 2.0,
                                          ),
                                        ],
                                        borderRadius:
                                        new BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            child: f['status'] == false
                                                ? GestureDetector(
                                              onTap: () {
                                                showImage(context, f['path'],
                                                    "FIL" + f['name'], true);
                                              },
                                              child: Image.file(File(f['path_compressed']),
                                                  fit: BoxFit.fitWidth),
                                            )
                                                : GestureDetector(
                                              onTap: () {
                                                showImage(context, f['path'],
                                                    "FIL" + f['name'], false);
                                              },
                                              child: Image.file(File(f['path_compressed']),
                                                  fit: BoxFit.fitWidth),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              padding: EdgeInsets.all(3),
                                              margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.all(
                                                      Radius.circular(50.0))),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    print(f['name']);
                                                    deleteFile(f['path']);
                                                    setState(() {
                                                      listImage.removeWhere((item) =>
                                                      item['name'] == f['name']);
                                                    });
                                                    setCam('D003');
                                                  },
                                                  child: Icon(Icons.delete,
                                                      color: Colors.red, size: 15)),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: f['status'] != false
                                                ? Container(
                                              padding: EdgeInsets.all(3),
                                              margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.all(
                                                      Radius.circular(50.0))),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.green,
                                                size: 15,
                                              ),
                                            )
                                                : Container(),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: f['proses'] == true
                                                ? CircularProgressIndicator()
                                                : null,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }).toList(),

                              ),
                            ],
                          ),

                        ),
                      ]
                  ),
                ),
              ),
            ]
        )
    );
  }

  Widget _suhuWindspeedWidget(BuildContext context) {
    return Expanded(
        child: Stack(
            children: <Widget> [
              SizedBox(
                height: 193,
                width: 180,
                child: Card(
                  color: Colors.grey[200],
                  child: Column(
                      children: <Widget>[
                        Container(
                            height: 40,
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                                children: <Widget>[
                                  TextWidget(
                                    txt: "Suhu/Windspeed",
                                    color: Colors.black,
                                    weight: FontWeight.bold,
                                  ),
                                  TextWidget(
                                    txt: " *",
                                    color: Colors.red,
                                    txtSize: 18,
                                    weight: FontWeight.bold,
                                  ),
                                ]
                            )
                        ),
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.16,
                          child: Stack(
                            children: <Widget>[
                              GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                childAspectRatio: 1,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                children: listImage
                                    .where((data) => data['type'] == 'D004')
                                    .map((f) {
                                  if (f['name'] == "button") {
                                    return GestureDetector(
                                      onTap: () {
                                        captureImage('D004');
                                      },
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.black12,
                                              offset: const Offset(0.0, 2.0),
                                              blurRadius: 2.0,
                                              spreadRadius: 2.0,
                                            ),
                                          ],
                                          borderRadius:
                                          new BorderRadius.all(Radius.circular(10.0)),
                                        ),
                                        child: Center(
                                            child: IconButton(
                                              icon: Icon(Icons.add_a_photo),
                                              onPressed: () {
                                                captureImage('D004');
                                              },
                                            )),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Colors.black12,
                                            offset: const Offset(0.0, 2.0),
                                            blurRadius: 2.0,
                                            spreadRadius: 2.0,
                                          ),
                                        ],
                                        borderRadius:
                                        new BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            child: f['status'] == false
                                                ? GestureDetector(
                                              onTap: () {
                                                showImage(context, f['path'],
                                                    "WS" + f['name'], true);
                                              },
                                              child: Image.file(File(f['path_compressed']),
                                                  fit: BoxFit.fitWidth),
                                            )
                                                : GestureDetector(
                                              onTap: () {
                                                showImage(context, f['path'],
                                                    "WS" + f['name'], false);
                                              },
                                              child: Image.file(File(f['path_compressed']),
                                                  fit: BoxFit.fitWidth),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              padding: EdgeInsets.all(3),
                                              margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.all(
                                                      Radius.circular(50.0))),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    print(f['name']);
                                                    deleteFile(f['path']);
                                                    setState(() {
                                                      listImage.removeWhere((item) =>
                                                      item['name'] == f['name']);
                                                    });
                                                    setCam('D004');
                                                  },
                                                  child: Icon(Icons.delete,
                                                      color: Colors.red, size: 15)),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: f['status'] != false
                                                ? Container(
                                              padding: EdgeInsets.all(3),
                                              margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.all(
                                                      Radius.circular(50.0))),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.green,
                                                size: 15,
                                              ),
                                            )
                                                : Container(),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: f['proses'] == true
                                                ? CircularProgressIndicator()
                                                : null,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }).toList(),

                              ),
                            ],
                          ),

                        ),
                      ]
                  ),
                ),
              ),
            ]
        )
    );
  }

  Widget _blowerWidget(BuildContext context) {
    return Expanded(
        child: Stack(
            children: <Widget> [
              SizedBox(
                height: 193,
                width: 180,
                child: Card(
                  color: Colors.grey[200],
                  child: Column(
                      children: <Widget>[
                        Container(
                            height: 40,
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                                children: <Widget>[
                                  TextWidget(
                                    txt: "Blower",
                                    color: Colors.black,
                                    weight: FontWeight.bold,
                                  ),
                                  TextWidget(
                                    txt: " *",
                                    color: Colors.red,
                                    txtSize: 18,
                                    weight: FontWeight.bold,
                                  ),
                                ]
                            )
                        ),
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.16,
                          child: Stack(
                            children: <Widget>[
                              GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                childAspectRatio: 1,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                children: listImage
                                    .where((data) => data['type'] == 'D005')
                                    .map((f) {
                                  if (f['name'] == "button") {
                                    return GestureDetector(
                                      onTap: () {
                                        captureImage('D005');
                                      },
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.black12,
                                              offset: const Offset(0.0, 2.0),
                                              blurRadius: 2.0,
                                              spreadRadius: 2.0,
                                            ),
                                          ],
                                          borderRadius:
                                          new BorderRadius.all(Radius.circular(10.0)),
                                        ),
                                        child: Center(
                                            child: IconButton(
                                              icon: Icon(Icons.add_a_photo),
                                              onPressed: () {
                                                captureImage('D005');
                                              },
                                            )),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        boxShadow: [
                                          new BoxShadow(
                                            color: Colors.black12,
                                            offset: const Offset(0.0, 2.0),
                                            blurRadius: 2.0,
                                            spreadRadius: 2.0,
                                          ),
                                        ],
                                        borderRadius:
                                        new BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            child: f['status'] == false
                                                ? GestureDetector(
                                              onTap: () {
                                                showImage(context, f['path'],
                                                    "BL" + f['name'], true);
                                              },
                                              child: Image.file(File(f['path_compressed']),
                                                  fit: BoxFit.fitWidth),
                                            )
                                                : GestureDetector(
                                              onTap: () {
                                                showImage(context, f['path'],
                                                    "BL" + f['name'], false);
                                              },
                                              child: Image.file(File(f['path_compressed']),
                                                  fit: BoxFit.fitWidth),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              padding: EdgeInsets.all(3),
                                              margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.all(
                                                      Radius.circular(50.0))),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    print(f['name']);
                                                    deleteFile(f['path']);
                                                    setState(() {
                                                      listImage.removeWhere((item) =>
                                                      item['name'] == f['name']);
                                                    });
                                                    setCam('D005');
                                                  },
                                                  child: Icon(Icons.delete,
                                                      color: Colors.red, size: 15)),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: f['status'] != false
                                                ? Container(
                                              padding: EdgeInsets.all(3),
                                              margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.all(
                                                      Radius.circular(50.0))),
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.green,
                                                size: 15,
                                              ),
                                            )
                                                : Container(),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: f['proses'] == true
                                                ? CircularProgressIndicator()
                                                : null,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }).toList(),

                              ),
                            ],
                          ),

                        ),
                      ]
                  ),
                ),
              ),
            ]
        )
    );
  }



  Future<void> captureImage(String type) async {
    final ImagePicker _picker = ImagePicker();

      final XFile image =await _picker.pickImage(source: ImageSource.camera, imageQuality: 20);
      // final File image = await ImagePicker.pickImage(
      //     source: ImageSource.camera, imageQuality: 20);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      DateTime now = DateTime.now();
      String imageName = type  + "_" + DateFormat('yyyyMMddkkmmss').format(now) + '.jpg';
      final File newImage = await File(image.path).copy('$appDocPath/$imageName');


      final File newImage2 = await File(image.path).copy('$appDocPath/$imageName');
      ImageProperties properties = await FlutterNativeImage.getImageProperties(newImage2.path);
      File compressedFile = await FlutterNativeImage.compressImage(newImage2.path, quality: 20,
          targetWidth: 300,
          targetHeight: (properties.height * 300 / properties.width).round());
      if (!mounted) return;
      setState(() {
        listImage.add({
          "name": imageName,
          "path": newImage.path,
          "path_compressed": compressedFile.path,
          "status": false,
          "proses": false,
          "type": type
        });
      });
      setCam(type);
    }

  Future<int> deleteFile(String _filePath) async {
    try {
      File _localFile = File(_filePath);
      final fileFull = _localFile;

      await fileFull.delete();
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  Future<void> retrieveLostData() async {
    final ImagePicker _picker = ImagePicker();

    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  setCam(String type) {
    setState(() {
      if (type == 'D001' || type == 'D002' || type == 'D003' || type == 'D004' || type == 'D005') {
        if (listImage.where((data) => data['type'] == type).length > 1) {
          listImage.removeWhere(
                  (item) => item['type'] == type && item['name'] == 'button');
        } else {
          if (listImage
              .where((data) =>
          data['type'] == type && data['name'] == 'button')
              .length <
              1) {
            listImage.add({
              "name": "button",
              "path": "",
              "path_compressed":"",
              "status": false,
              "proses": false,
              "type": type
            });
          }
        }
      } else {
        if (listImage.where((data) => data['type'] == type).length > 20) {
          listImage.removeWhere(
                  (item) => item['type'] == type && item['name'] == 'button');
        } else {
          if (listImage
              .where((data) =>
          data['type'] == type && data['name'] == 'button')
              .length <
              1) {
            listImage.add({
              "name": "button",
              "path": "",
              "path_compressed":"",
              "status": false,
              "proses": false,
              "type": type
            });
          }
        }
      }
    });
    setOrder(type);
  }

  setOrder(String type) {
    setState(() {
      listImage
          .sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));
    });
  }

  initView()  {
    SharedPreferencesHelper.getDoLogin().then((value) {
      final member = MemberModels.fromJson(json.decode(value));
      setState(() {
        name = member.data.nama_user;
        id_user = member.data.id_user;
        id_dealer = member.data.id_dealer;
        _namaUserController.text = name;
        // _namaSAController.text = name;
        _hpNormalController.text = "200 - 250";
        _lpNormalController.text = "20 - 40";
        _suhuNormalController.text = "< 7";
        _windSpeedNormalController.text = "2.0";
        _pekerjaan = widget.pekerjaan;
        if(widget.pekerjaan != "" || widget.pekerjaan != null || widget.pekerjaan == "Pekerjaan Kecil") {
          _hpController.text = "0";
          _lpController.text = "0";
        }
      });
    });

    listImage.addAll([
      {
        "name": "button",
        "path": "",
        "path_compressed":"",
        "status": false,
        "proses": false,
        "type": "D001"
      },
      {
        "name": "button",
        "path": "",
        "path_compressed":"",
        "status": false,
        "proses": false,
        "type": "D002"
      },
      {
        "name": "button",
        "path": "",
        "path_compressed":"",
        "status": false,
        "proses": false,
        "type": "D003"
      },
      {
        "name": "button",
        "path": "",
        "path_compressed":"",
        "status": false,
        "proses": false,
        "type": "D004"
      },
      {
        "name": "button",
        "path": "",
        "path_compressed":"",
        "status": false,
        "proses": false,
        "type": "D005"
      }
    ]);

    setState(() {
      _isLoading = false;
    });
  }

}
