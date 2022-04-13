import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geofancing/src/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/models/default_model.dart';
import 'package:geofancing/src/bloc/bloc_car_working.dart' as blocCarWorking;
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/models/car_working_model.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:geofancing/src/bloc/car_before_save_bloc.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/widgets/additional_widgets.dart';
import 'package:geofancing/src/widgets/ButtonWidgetLoading.dart';


class CarWorkingAfter extends StatefulWidget {
  String idUniq;

  @override
  State<StatefulWidget> createState() => _CarWorkingAfter();

  CarWorkingAfter({this.idUniq});
}

class _CarWorkingAfter extends State<CarWorkingAfter> {

  bool _isLoading = true;
  String _idUser,_name,_idDealer;
  HistoryCarWorkingModels _detailCarWorking;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _namaUserController = TextEditingController();
  final _namaSAController = TextEditingController();
  final _nopolController = TextEditingController();
  final _modelMobilController = TextEditingController();
  final _kmController = TextEditingController();
  final _filterController = TextEditingController();
  final _blowerController = TextEditingController();
  final _perawatanController = TextEditingController();
  final _penggantianController = TextEditingController();
  final _perbaikanController = TextEditingController();
  final _hpController = TextEditingController();
  final _lpController = TextEditingController();
  final _suhuController = TextEditingController();
  final _windSpeedController = TextEditingController();

  final _hpNormalController = TextEditingController();
  final _lpNormalController = TextEditingController();
  final _suhuNormalController = TextEditingController();
  final _windSpeedNormalController = TextEditingController();

  List listImage = List();

  XFile _imageFile;
  bool isVideo = false;

  int step = 0;


  final ButtonWidgetLoadController _btnSaveController = new ButtonWidgetLoadController();
  String _retrieveDataError;

  void initState() {
    // TODO: implement initState
    super.initState();
    new Timer(const Duration(milliseconds: 550), ()
    {
      initView();
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  initView() {
    setState(() {
      _isLoading = false;
    });

    listImage.addAll([
      {
        "name": "button",
        "path": "",
        "path_compressed":"",
        "status": false,
        "proses": false,
        "delete": true,
        "type": "D001"
      },
      {
        "name": "button",
        "path": "",
        "path_compressed":"",
        "status": false,
        "proses": false,
        "delete": true,
        "type": "D002"
      },
      {
        "name": "button",
        "path": "",
        "path_compressed":"",
        "status": false,
        "proses": false,
        "delete": true,
        "type": "D003"
      },
      {
        "name": "button",
        "path": "",
        "path_compressed":"",
        "status": false,
        "proses": false,
        "delete": true,
        "type": "D004"
      },
      {
        "name": "button",
        "path": "",
        "path_compressed":"",
        "status": false,
        "proses": false,
        "delete": true,
        "type": "D005"
      }
    ]);

    SharedPreferencesHelper.getDoLogin().then((value)  {
      final member = MemberModels.fromJson(json.decode(value));
      setState(() {
        _idUser = member.data.id_user;
        _namaUserController.text = member.data.nama_user;
        _namaSAController.text = "";
      });
      var data = {"id_uniq" : widget.idUniq, "method" : "detail", "id_user" : _idUser};
      blocCarWorking.bloc.getsHistoryCarWorking(data, (model) async {
        await getData(model);
      });
    });


  }

  getData(HistoryCarWorkingModels models) async {
    setState((){
      _detailCarWorking = models;
      _nopolController.text = models.data[0].nopol;
      _modelMobilController.text = models.data[0].model;
      _kmController.text = models.data[0].km;

      if(models.error == false) {
        for (var i = 0; i <  models.data[0].list_foto.split(', ').length; i++) {
          if(models.data[0].list_foto.split(', ')[i].toString() != "" || models.data[0].list_foto.split(', ')[i] != null) {
            var urlImage = models.data[0].list_foto.split(', ')[i].toString();
            var imageName = urlImage.substring(urlImage.lastIndexOf("/") + 1, urlImage.length);
            int idx = imageName.indexOf("_");
            var codeFile = imageName.substring(0,idx).trim();

            // Image.network(urlImage);

            listImage.add({
              "name": imageName,
              "path": urlImage,
              "path_compressed": NetworkImage(urlImage),
              "status": true,
              "proses": false,
              "delete": false,
              "type": codeFile
            });

            setOrder(codeFile);
          }
        }
      }
      // listImage.removeWhere((item) => item['name'] == name);
      // listImage.add({
      //   "name": model.data.file.last.filename,
      //   "path": model.data.file.last.url,
      //   "path_compressed": path_compressed,
      //   "status": true,
      //   "proses": false,
      //   "type": type
      // });
      // setOrder(type);

      // _hpController.text = models.data[0].hp;
      // _lpController.text = models.data[0].lp;
      // _suhuController.text = models.data[0].suhu;
      // _windSpeedController.text = models.data[0].windspeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Car Working After", style: TextStyle(color: Colors.white)),
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
                        shape:RoundedRectangleBorder(
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
                                          readOnly : true,
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
                        height: 20,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 80,
                          // Set as you want or you can remove it also.
                          maxHeight: double.infinity,
                        ),
                        child: _kmWidget(context),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 80,
                          // Set as you want or you can remove it also.
                          maxHeight: double.infinity,
                        ),
                        child: _tampakDepan(context),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 80,
                          // Set as you want or you can remove it also.
                          maxHeight: double.infinity,
                        ),
                        child: _filterWidget(context),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 80,
                          // Set as you want or you can remove it also.
                          maxHeight: double.infinity,
                        ),
                        child: _suhuWindspeedWidget(context),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 80,
                          // Set as you want or you can remove it also.
                          maxHeight: double.infinity,
                        ),
                        child: _blowerWidget(context),
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
                      _catatanPerbaikan(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _saranPerbaikian(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.blue[400], width: 1),
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
                      color: Colors.blue,
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
                        color: Colors.blue,
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
                        color: Colors.blue,
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

  Widget _catatanPerbaikan(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.green[400], width: 1),
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
                      txt : "Catatan Perbaikan",
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
          SizedBox(
            height: 15,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: TextFieldWidget(
                      _perbaikanController,
                      hint: "Catatan Penggantian",
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
    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width / 20,
        right: MediaQuery.of(context).size.width / 20
      ),
      decoration: BoxDecoration(
        color:Colors.grey[200],
        boxShadow: [
          new BoxShadow(
            color: Colors.black12,
            offset: const Offset(0.0, 2.0),
            blurRadius: 2.0,
            spreadRadius: 2.0
          )
        ],
        borderRadius: new BorderRadius.only(
          topRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0)
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:  MainAxisAlignment.start,
        children: <Widget> [
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
            color: Colors.grey[200],
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextWidget(
                          txt: "Photo",
                          color: Colors.red,
                          txtSize: 12,
                          weight: FontWeight.bold)
                    ],
                  ),
                ),
                SizedBox(height: 20),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2,
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
                                color: Colors.grey,
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.black12,
                                    offset: const Offset(0.0, 2.0),
                                    blurRadius: 2.0,
                                    spreadRadius: 2.0,
                                  ),
                                ],
                                borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.add_a_photo, color: Colors.black),
                                  onPressed: () {
                                    captureImage('D001');
                                  },
                                )
                              ),
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
                                    child: Image.file(File(f['path']),
                                        fit: BoxFit.fitWidth),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      showImage(context, f['path'],
                                          "KM" + f['name'], false);
                                    },
                                    child: Image.network(f['path'],
                                        fit: BoxFit.fitWidth),
                                  ),
                                ),
                                f['delete'] ? Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    decoration: BoxDecoration(
                                        color: colorWhite,
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(50.0))),
                                    child: GestureDetector(
                                        onTap: () {
                                            print(f['name']);
                                            setState(() {
                                              listImage.removeWhere((item) =>
                                              item['name'] == f['name']);
                                            });
                                            setCam('D001');

                                        },
                                        child: Icon(Icons.delete,color: Colors.red, size: 15)
                                    ),
                                  ),
                                ) : Align(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: f['status'] != false
                                      ? Container(
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                    decoration: BoxDecoration(
                                        color: colorWhite,
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
      )
    );
  }

  Widget _tampakDepan(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 20,
            right: MediaQuery.of(context).size.width / 20
        ),
        decoration: BoxDecoration(
          color:Colors.grey[200],
          boxShadow: [
            new BoxShadow(
                color: Colors.black12,
                offset: const Offset(0.0, 2.0),
                blurRadius: 2.0,
                spreadRadius: 2.0
            )
          ],
          borderRadius: new BorderRadius.only(
              topRight: Radius.circular(10.0),
              topLeft: Radius.circular(10.0)
          ),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:  MainAxisAlignment.start,
            children: <Widget> [
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
                color: Colors.grey[200],
                width: double.infinity,
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextWidget(
                              txt: "Photo",
                              color: Colors.red,
                              txtSize: 12,
                              weight: FontWeight.bold)
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
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
                                color: Colors.grey,
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.black12,
                                    offset: const Offset(0.0, 2.0),
                                    blurRadius: 2.0,
                                    spreadRadius: 2.0,
                                  ),
                                ],
                                borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.add_a_photo, color: Colors.black),
                                    onPressed: () {
                                      captureImage('D002');
                                    },
                                  )
                              ),
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
                                    child: Image.file(File(f['path']),
                                        fit: BoxFit.fitWidth),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      showImage(context, f['path'],
                                          "TDP" + f['name'], false);
                                    },
                                    child: Image.network(f['path'],
                                        fit: BoxFit.fitWidth),
                                  ),
                                ),
                                f['delete'] ? Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    decoration: BoxDecoration(
                                        color: colorWhite,
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(50.0))),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            listImage.removeWhere((item) =>
                                            item['name'] == f['name']);
                                          });
                                          setCam('D002');

                                        },
                                        child: Icon(Icons.delete,color: Colors.red, size: 15)
                                    ),
                                  ),
                                ) : Align(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: f['status'] != false
                                      ? Container(
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                    decoration: BoxDecoration(
                                        color: colorWhite,
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
        )
    );
  }

  Widget _filterWidget(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 20,
            right: MediaQuery.of(context).size.width / 20
        ),
        decoration: BoxDecoration(
          color:Colors.grey[200],
          boxShadow: [
            new BoxShadow(
                color: Colors.black12,
                offset: const Offset(0.0, 2.0),
                blurRadius: 2.0,
                spreadRadius: 2.0
            )
          ],
          borderRadius: new BorderRadius.only(
              topRight: Radius.circular(10.0),
              topLeft: Radius.circular(10.0)
          ),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:  MainAxisAlignment.start,
            children: <Widget> [
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
                color: Colors.grey[200],
                width: double.infinity,
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextWidget(
                              txt: "Photo",
                              color: Colors.red,
                              txtSize: 12,
                              weight: FontWeight.bold)
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
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
                                color: Colors.grey,
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.black12,
                                    offset: const Offset(0.0, 2.0),
                                    blurRadius: 2.0,
                                    spreadRadius: 2.0,
                                  ),
                                ],
                                borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.add_a_photo, color: Colors.black),
                                    onPressed: () {
                                      captureImage('D003');
                                    },
                                  )
                              ),
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
                                    child: Image.file(File(f['path']),
                                        fit: BoxFit.fitWidth),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      showImage(context, f['path'],
                                          "FIL" + f['name'], false);
                                    },
                                    child: Image.network(f['path'],
                                        fit: BoxFit.fitWidth),
                                  ),
                                ),
                                f['delete'] ? Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    decoration: BoxDecoration(
                                        color: colorWhite,
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(50.0))),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            listImage.removeWhere((item) =>
                                            item['name'] == f['name']);
                                          });
                                          setCam('D003');

                                        },
                                        child: Icon(Icons.delete,color: Colors.red, size: 15)
                                    ),
                                  ),
                                ) : Align(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: f['status'] != false
                                      ? Container(
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                    decoration: BoxDecoration(
                                        color: colorWhite,
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
        )
    );
  }

  Widget _suhuWindspeedWidget(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 20,
            right: MediaQuery.of(context).size.width / 20
        ),
        decoration: BoxDecoration(
          color:Colors.grey[200],
          boxShadow: [
            new BoxShadow(
                color: Colors.black12,
                offset: const Offset(0.0, 2.0),
                blurRadius: 2.0,
                spreadRadius: 2.0
            )
          ],
          borderRadius: new BorderRadius.only(
              topRight: Radius.circular(10.0),
              topLeft: Radius.circular(10.0)
          ),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:  MainAxisAlignment.start,
            children: <Widget> [
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
                color: Colors.grey[200],
                width: double.infinity,
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextWidget(
                              txt: "Photo",
                              color: Colors.red,
                              txtSize: 12,
                              weight: FontWeight.bold)
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
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
                                color: Colors.grey,
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.black12,
                                    offset: const Offset(0.0, 2.0),
                                    blurRadius: 2.0,
                                    spreadRadius: 2.0,
                                  ),
                                ],
                                borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.add_a_photo, color: Colors.black),
                                    onPressed: () {
                                      captureImage('D004');
                                    },
                                  )
                              ),
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
                                    child: Image.file(File(f['path']),
                                        fit: BoxFit.fitWidth),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      showImage(context, f['path'],
                                          "WS" + f['name'], false);
                                    },
                                    child: Image.network(f['path'],
                                        fit: BoxFit.fitWidth),
                                  ),
                                ),
                                f['delete'] ? Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    decoration: BoxDecoration(
                                        color: colorWhite,
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(50.0))),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            listImage.removeWhere((item) =>
                                            item['name'] == f['name']);
                                          });
                                          setCam('D004');

                                        },
                                        child: Icon(Icons.delete,color: Colors.red, size: 15)
                                    ),
                                  ),
                                ) : Align(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: f['status'] != false
                                      ? Container(
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                    decoration: BoxDecoration(
                                        color: colorWhite,
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
        )
    );
  }

  Widget _blowerWidget(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 20,
            right: MediaQuery.of(context).size.width / 20
        ),
        decoration: BoxDecoration(
          color:Colors.grey[200],
          boxShadow: [
            new BoxShadow(
                color: Colors.black12,
                offset: const Offset(0.0, 2.0),
                blurRadius: 2.0,
                spreadRadius: 2.0
            )
          ],
          borderRadius: new BorderRadius.only(
              topRight: Radius.circular(10.0),
              topLeft: Radius.circular(10.0)
          ),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:  MainAxisAlignment.start,
            children: <Widget> [
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
                color: Colors.grey[200],
                width: double.infinity,
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextWidget(
                              txt: "Photo",
                              color: Colors.red,
                              txtSize: 12,
                              weight: FontWeight.bold)
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
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
                                color: Colors.grey,
                                boxShadow: [
                                  new BoxShadow(
                                    color: Colors.black12,
                                    offset: const Offset(0.0, 2.0),
                                    blurRadius: 2.0,
                                    spreadRadius: 2.0,
                                  ),
                                ],
                                borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.add_a_photo, color: Colors.black),
                                    onPressed: () {
                                      captureImage('D005');
                                    },
                                  )
                              ),
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
                                    child: Image.file(File(f['path']),
                                        fit: BoxFit.fitWidth),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      showImage(context, f['path'],
                                          "BL" + f['name'], false);
                                    },
                                    child: Image.network(f['path'],
                                        fit: BoxFit.fitWidth),
                                  ),
                                ),
                                f['delete'] ? Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                                    decoration: BoxDecoration(
                                        color: colorWhite,
                                        borderRadius: new BorderRadius.all(
                                            Radius.circular(50.0))),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            listImage.removeWhere((item) =>
                                            item['name'] == f['name']);
                                          });
                                          setCam('D005');

                                        },
                                        child: Icon(Icons.delete,color: Colors.red, size: 15)
                                    ),
                                  ),
                                ) : Align(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: f['status'] != false
                                      ? Container(
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                    decoration: BoxDecoration(
                                        color: colorWhite,
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
        )
    );
  }

  Widget _hasilCheck(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.lightGreen, width: 1),
      ),
      color:Colors.white70,
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
                      txt : "Hasil Check",
                      color: Colors.black,
                      weight: FontWeight.bold,
                      align: TextAlign.center,
                      txtSize: 15,
                    ),
                  )
                )
              ],
            )
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
                        hint: "HP"
                    ) ,
                  )
              ),
            ]
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
                        hint: "LP"
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
        "delete": true,
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
      if (type == '') {
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
              "delete": true,
              "type": type
            });
          }
        }
      } else {
        if (listImage.where((data) => data['type'] == type).length > 2) {
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
              "delete": true,
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
