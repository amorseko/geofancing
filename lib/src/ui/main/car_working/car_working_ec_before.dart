import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/widgets/text_field.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geofancing/src/bloc/car_before_save_bloc.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/widgets/ButtonWidgetLoading.dart';
import 'package:geofancing/src/widgets/additional_widgets.dart';
import 'package:geofancing/src/models/default_model.dart';

class CarWorkingEcBeforePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarWorkingEcBeforePage();
  }
}

class _CarWorkingEcBeforePage extends State<CarWorkingEcBeforePage> {
  final ButtonWidgetLoadController _btnSaveController = new ButtonWidgetLoadController();
  bool _isLoading = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _name, _idUser, _idDealer;
  List listImage = List();


  String _retrieveDataError;
  XFile _imageFile;
  bool isVideo = false;


  final _nopolController = TextEditingController();
  final _remarksController = TextEditingController();

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

  initView() {
      SharedPreferencesHelper.getDoLogin().then((value) {
        final member = MemberModels.fromJson(json.decode(value));
        setState(() {
          _name = member.data.nama_user;
          _idUser = member.data.id_user;
          _idDealer = member.data.id_dealer;
          _idDealer = member.data.id_dealer;
        });
      });

      setState(() {
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
        ]);
        _isLoading = false;
      });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
              "Car Working Engine Care Before",
              style: TextStyle(color: Colors.white)
          ),
          centerTitle: true,
          backgroundColor: CorpToyogaColor
      ),
      body: ProgressDialog(
        inAsyncCall: _isLoading,
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          padding: EdgeInsets.all(20),
          child: Stack(
              children: <Widget>[
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
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: <Widget> [
                                      new Expanded(
                                          child: new TextWidget(
                                            txt: "Remarks",
                                            align: TextAlign.justify,
                                          )
                                      ),
                                      new Expanded(
                                          flex: 3,
                                          child: TextFieldWidget(
                                            _remarksController,
                                            hint: "Remarks",
                                            maxLines: 10,
                                            maxLength: 1000,
                                            keyboardType: TextInputType.multiline,
                                         ) ,
                                      )
                                    ],
                                  ),

                                ],
                              )
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: <Widget>[
                              _blokMesin(context),
                              _noPol(context),

                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          _buttonBottom(context)
                        ],
                      ),
                    )
                )
              ]
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

    if(_nopolController.text == "") {
      _showAlert(context, "Nomor Polisi Tidak Boleh Kosong !");
      return;
    }

    if(_remarksController.text == "") {
      _showAlert(context, "Remarks Tidak Boleh Kosong !");
      return;
    }



    listImage.forEach((element) {
      print(element);
      if(element['path'] == "") {
        if(element['type'] == "D001") {
          _showAlert(context, "Foto Blok Mesin Tidak Boleh Kosong !");
          return;
        }

        if(element['type'] == "D002") {
          _showAlert(context, "Foto No Polisi Tidak Boleh Kosong !");
          return;
        }
      }
    });


    setState(() {
      _isLoading = true;
    });

    var formData = FormData.fromMap({
      'id_user': _idUser,
      'id_sa': '123',
      'nopol' : _nopolController.text,
      'model' : "-",
      'KM' : "-",
      'HP' : "-",
      'LP' :"-",
      'suhu' : "-",
      'windspeed' :"-",
      'filter' :"-",
      'blower' : "-",
      'perawatan' : "-",
      'penggantian' : _remarksController.text,
      "type_working" : "Engine Care"
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

  Widget _blokMesin(BuildContext context) {
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
                                    txt: "Blok Mesin",
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
                                                    "BLM" + f['name'], true);
                                              },
                                              child: Image.file(File(f['path_compressed']),
                                                  fit: BoxFit.fitWidth),
                                            )
                                                : GestureDetector(
                                              onTap: () {
                                                showImage(context, f['path'],
                                                    "BLM" + f['name'], false);
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

  Widget _noPol(BuildContext context) {
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
                                    txt: "No Polisi",
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
                                                    "NOP" + f['name'], true);
                                              },
                                              child: Image.file(File(f['path_compressed']),
                                                  fit: BoxFit.fitWidth),
                                            )
                                                : GestureDetector(
                                              onTap: () {
                                                showImage(context, f['path'],
                                                    "NOP" + f['name'], false);
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
}