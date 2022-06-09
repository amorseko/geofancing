import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geofancing/src/models/default_model.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/ui/main/pekerjaan/form_pict_pekerjaan.dart';
import 'package:geofancing/src/ui/main/pekerjaan/pekerjaan.dart';

import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:geofancing/src/bloc/doPekerjaanBloc.dart';

class FormPekerjaanPage extends StatefulWidget {
  @override
  _FormPekerjaanPage createState() => _FormPekerjaanPage();
}

class _FormPekerjaanPage extends State<FormPekerjaanPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  String _idUser, _idDealer;
  List _myActivities;
  String _myActivitiesResult;
  XFile _imageSpk, _imageNoPol;

  TextEditingController _txtNoSpk = new TextEditingController();
  TextEditingController _txtNoPol = new TextEditingController();
  TextEditingController _txtKeterangan = new TextEditingController();

  @override
  void initState() {
    super.initState();

    SharedPreferencesHelper.getDoLogin().then((onValue) {
      final memberModels = MemberModels.fromJson(json.decode(onValue));
      setState(() {
        _isLoading = false;
        _idUser = memberModels.data.id_user;
        _idDealer = memberModels.data.id_dealer;
      });
    });

    _myActivities = [];
    _myActivitiesResult = "";
    // initDataView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _bgHeader(BuildContext context) {
    return new Container(
      child: Image.asset(
        'assets/images/list_image.jpg',
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
          title: Text("Form " + allTranslations.text("btn_pekerjaan"),
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: CorpToyogaColor),
      body: ProgressDialog(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _bgHeader(context),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 0.0),
                        child: TextFormField(
                          controller: _txtNoSpk,
                          decoration: InputDecoration(
                            labelText: 'No. SPK',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 0.0),
                        child: TextFormField(
                          controller: _txtNoPol,
                          decoration: InputDecoration(
                            labelText: 'No. Polisi',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 0.0),
                        child: MultiSelectFormField(
                          title: Text("Select Type Pekerjaan"),
                          dataSource: [
                            {
                              "display": "AC",
                              "value": "Air Conditioner",
                            },
                            {
                              "display": "EC",
                              "value": "Engine Care",
                            },
                            {
                              "display": "OZ",
                              "value": "Ozone",
                            },
                            {
                              "display": "RM",
                              "value": "Rematching",
                            },
                            {
                              "display": "FL",
                              "value": "Flushing",
                            },
                            {
                              "display": "CR",
                              "value": "Car Wash",
                            },
                          ],
                          required: true,
                          hintWidget: Text('Please choose one or more'),
                          //initialValue: _currText,
                          textField: 'value',
                          initialValue: _myActivities,
                          valueField: 'display',
                          onSaved: (value) {
                            if (value == null) return;
                            setState(() {
                              _myActivities = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 0.0),
                        child: TextFormField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          controller: _txtKeterangan,
                          decoration: InputDecoration(
                            labelText: "Remarks",
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 0.0),
                            child: TextWidget(
                              txtSize: 20,
                              txt: "Foto SPK",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 0.0),
                            child: InkWell(
                              onTap: () {
                                getImageSPK();
                              },
                              child: Container(
                                width: 200.0,
                                height: 200.0,
                                decoration: _imageSpk != null
                                    ? BoxDecoration(
                                        border: Border.all(
                                            color: CorpToyogaColor, width: 2),
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(File(_imageSpk.path))))
                                    : BoxDecoration(
                                        border: Border.all(
                                            color: CorpToyogaColor, width: 2),
                                        shape: BoxShape.circle,
                                      ),
                                child: _imageSpk == null
                                    ? Icon(Icons.camera_alt,
                                        color: Colors.grey, size: 70.0)
                                    : new Offstage(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 0.0),
                            child: TextWidget(
                              txtSize: 20,
                              txt: "Foto No. Polisi",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 0.0),
                            child: InkWell(
                              onTap: () {
                                getImageNoPol();
                              },
                              child: Container(
                                width: 200.0,
                                height: 200.0,
                                decoration: _imageNoPol != null
                                    ? BoxDecoration(
                                        border: Border.all(
                                            color: CorpToyogaColor, width: 2),
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(File(_imageNoPol.path))))
                                    : BoxDecoration(
                                        border: Border.all(
                                            color: CorpToyogaColor, width: 2),
                                        shape: BoxShape.circle,
                                      ),
                                child: _imageNoPol == null
                                    ? Icon(Icons.camera_alt,
                                        color: Colors.grey, size: 70.0)
                                    : new Offstage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: ButtonTheme(
                            child: new RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextWidget(
                                color: Colors.white,
                                txt: "SUBMIT",
                                txtSize: 14.0,
                              ),
                              elevation: 4.0,
                              color: CorpSecondToyoga,
                              splashColor: Colors.blueAccent,
                              onPressed: () {
                                submitPekerjaan();
                              },
                            ),
                            height: 50.0,
                          ),
                        ),
                      ),
                    ]))),
      ),
    );
  }

  Future getImageSPK() async {
    print("onpressed");
    final ImagePicker _picker = ImagePicker();

    var image =await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageSpk = image;
      print("this is a image path : ${_imageSpk.path}");
      // _foto.value = TextEditingValue(text: _image.toString());
    });
  }

  Future getImageNoPol() async {
    print("onpressed");
    final ImagePicker _picker = ImagePicker();

    var image =await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageNoPol = image;
      print("this is a image path : ${_imageNoPol.path}");
      // _foto.value = TextEditingValue(text: _image.toString());
    });
  }

  submitPekerjaan() async {
    setState(() {
      _isLoading = true;
    });
    String filenameSPK = _imageSpk.path.split('/').last;
    String filenameNoPol = _imageNoPol.path.split('/').last;
    if (_txtNoSpk.text != "" ||
        _txtNoPol.text != "" ||
        _myActivities != null ||
        _imageNoPol != null ||
        _imageSpk != null) {
      var formData = FormData.fromMap({
        'ID_users': _idUser,
        'id_dealer': _idDealer,
        'no_spk': _txtNoSpk.text,
        'nopol': _txtNoPol.text,
        'jenis_pekerjaan': _myActivities.toString(),
        'foto_spk':
            await MultipartFile.fromFile(_imageSpk.path, filename: filenameSPK),
        'foto_nopol': await MultipartFile.fromFile(_imageNoPol.path,
            filename: filenameNoPol),
        'keterangan_pekerjaan': _txtKeterangan.text
      });

      bloc.doPekerjaanBloc(formData, (callback) {
        DefaultModel model = callback;
        setState(() {
          _isLoading = false;
          // if (model.status == "success") {
          showErrorMessage(context, model.message, model.status);
          // }
        });
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text("Mohon isi text yang kosong !")));
    }
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
                                    message,
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
                                            "/pekerjaan_page",
                                            (_) => false);
                                        // routeToWidget(context, PekerjaanPage())
                                        //     .then((value) {
                                        //   setPotrait();
                                        // });
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
