import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geofancing/src/bloc/do_selected_image.dart';
import 'package:geofancing/src/models/default_model.dart';
import 'package:geofancing/src/models/get_picture_model.dart';
import 'package:geofancing/src/ui/main/pekerjaan/pekerjaan.dart';

import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geofancing/src/bloc/bloc_update_image.dart';

class FormPictPekerjaanPage extends StatefulWidget {
  String id_rmh;
  @override
  _FormPictPekerjaanPage createState() => _FormPictPekerjaanPage();
  FormPictPekerjaanPage({this.id_rmh});
}

class _FormPictPekerjaanPage extends State<FormPictPekerjaanPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  File _imageSpk, _imageNoPol;
  String _imageUrlNoPol, _imageUrlSPK;

  final _DataImagePekerjaan = ListSelectedImage();
  GetPictureModel _mdlPicturePekerjaan = GetPictureModel();

  @override
  void initState() {
    super.initState();
    getDataSelected();
    // initDataView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("Form Picture " + allTranslations.text("btn_pekerjaan"),
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: CorpToyogaColor),
      body: ProgressDialog(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 0.0),
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
                              border:
                                  Border.all(color: CorpToyogaColor, width: 2),
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(_imageSpk)))
                          : _imageUrlSPK != ""
                              ? BoxDecoration(
                                  border: Border.all(
                                      color: CorpToyogaColor, width: 2),
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(_imageUrlSPK)))
                              : BoxDecoration(
                                  border: Border.all(
                                      color: CorpToyogaColor, width: 2),
                                  shape: BoxShape.circle,
                                ),
                      child: _imageSpk == null && _imageUrlSPK == ""
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
                              border:
                                  Border.all(color: CorpToyogaColor, width: 2),
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(_imageNoPol)))
                          : _imageUrlNoPol != ""
                              ? BoxDecoration(
                                  border: Border.all(
                                      color: CorpToyogaColor, width: 2),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(_imageUrlNoPol),
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : BoxDecoration(
                                  border: Border.all(
                                      color: CorpToyogaColor, width: 2),
                                  shape: BoxShape.circle,
                                ),
                      child: _imageNoPol == null && _imageUrlNoPol == ""
                          ? Icon(Icons.camera_alt,
                              color: Colors.grey, size: 70.0)
                          : new Offstage(),
                    ),
                  ),
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
                          txt: "Submit",
                          txtSize: 14.0,
                        ),
                        elevation: 4.0,
                        color: CorpSecondToyoga,
                        splashColor: Colors.blueAccent,
                        onPressed: () {},
                      ),
                      height: 50.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImageSPK() async {
    print("onpressed");
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageSpk = image;
      print("this is a image path : ${_imageSpk.path}");
      // _foto.value = TextEditingValue(text: _image.toString());
    });
  }

  Future getImageNoPol() async {
    print("onpressed");
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageNoPol = image;
      print("this is a image path : ${_imageNoPol.path}");
      // _foto.value = TextEditingValue(text: _image.toString());
    });
  }

  getDataSelected() {
    var data = {"id_rmh": widget.id_rmh};

    _DataImagePekerjaan.getListBantuanBloc(data,
        (status, error, message, model) {
      GetPictureModel _mdlPicturePekerjaan = model;
      setState(() {
        _imageUrlNoPol = _mdlPicturePekerjaan.data[0].foto_nopol;
        _imageUrlSPK = _mdlPicturePekerjaan.data[0].foto_spk;

        _isLoading = false;
      });
    });
  }

  submit() async {
    _isLoading = true;

    String filenameSPK = _imageSpk.path.split('/').last;
    String filenameNoPol = _imageNoPol.path.split('/').last;
    if (_imageNoPol != null || _imageSpk != null) {
      var formData = FormData.fromMap({
        'id_rmh': widget.id_rmh,
        'foto_spk':
            await MultipartFile.fromFile(_imageSpk.path, filename: filenameSPK),
        'foto_nopol': await MultipartFile.fromFile(_imageNoPol.path,
            filename: filenameNoPol),
      });

      bloc.doPekerjaanBloc(formData, (callback) {
        DefaultModel model = callback;
        setState(() {
          _isLoading = false;
        });
        if (model.status != "success") {
          showErrorMessage(context, model.message, model.status);
        }
      });
    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Mohon pilih gambar !")));
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
                                        routeToWidget(context, PekerjaanPage())
                                            .then((value) {
                                          setPotrait();
                                        });
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
