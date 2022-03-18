import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geofancing/src/models/default_model.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/ui/main/pengajuan_barang/pengajuan.dart';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/ui/main/pengajuan_barang/detail_pengajuan.dart';
import 'package:geofancing/src/ui/main/pengajuan_barang/take_foto_pengajuan.dart';
import 'package:geofancing/src/bloc/bloc_doPengajuan.dart';

class SubmitPengajuanPage extends StatefulWidget {
  String imagePath;
  String idBarang;
  String idJenisBarang;
  String tglTransaksi;
  String KondisiBarang;

  @override
  _SubmitPengajuanPage createState() => _SubmitPengajuanPage();
  SubmitPengajuanPage(
      {this.imagePath,
      this.idBarang,
      this.idJenisBarang,
      this.tglTransaksi,
      this.KondisiBarang});
}

class _SubmitPengajuanPage extends State<SubmitPengajuanPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;

  TextEditingController _txtRemarks = new TextEditingController();

  String _namaUser;
  String _idUser;
  String _idDealer;

  void initState() {
    // TODO: implement initState
    super.initState();
    initView();
  }

  initView() async {
    SharedPreferencesHelper.getDoLogin().then((value) async {
      final member = MemberModels.fromJson(json.decode(value));
      setState(() {
        _isLoading = false;
        _namaUser = member.data.nama_user;
        _idUser = member.data.id_user;
        _idDealer = member.data.id_dealer;
      });
    });

    print(widget.idBarang);
//    DateTime now = DateTime.now();
//    String formattedDate = DateFormat('y-MM-d kk:mm:ss').format(now);
    setState(() {
      _isLoading = false;
//      waktu  = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.white),
        title: TextWidget(txt: "Submit Pengajuan", color: colorTitle()),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.assignment,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
              routeToWidget(
                  context,
                  PageDetailPengajuan(
                    id_barang_detail: widget.idBarang,
                  )).then((value) {
                setPotrait();
              });
            },
          )
        ],
        backgroundColor: CorpToyogaColor,
        elevation: 0,
      ),
      body: ProgressDialog(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      if (widget.KondisiBarang == "1") {
                        routeToWidget(
                            context,
                            TakeFotoPengajuan(
                              idBarang: widget.idBarang,
                              KondisiBarang:widget.KondisiBarang,
                              idJenisBarang: widget.idJenisBarang,
                              tglTransaksi: widget.tglTransaksi,
                            )).then((value) {
                          setPotrait();
                        });
                      }
                    },
                    child: Container(
                      width: 200.0,
                      height: 200.0,
                      decoration: widget.KondisiBarang == "1" && widget.imagePath != ""
                          ? BoxDecoration(
                              border:
                                  Border.all(color: CorpToyogaColor, width: 2),
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(widget.imagePath))))
                          : widget.KondisiBarang == "1" && widget.imagePath == "" ?
                      BoxDecoration(
                              border:
                                  Border.all(color: CorpToyogaColor, width: 2),
                              shape: BoxShape.circle,
                            ) : BoxDecoration(),
                      child: widget.imagePath == "" && widget.KondisiBarang == "1"
                          ? Icon(Icons.camera_alt,
                              color: Colors.grey, size: 70.0)
                          : new Offstage(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 0.0),
                    child: TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: _txtRemarks,
                      decoration: InputDecoration(
                        labelText: "Remarks",
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
                            txt: "SAVE",
                            txtSize: 14.0,
                          ),
                          elevation: 4.0,
                          color: CorpToyogaColor,
                          splashColor: Colors.redAccent,
                          onPressed: () {
                            _submitPengajuan(context);
                          },
                        ),
                        height: 50.0,
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }



  _submitPengajuan(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    if (widget.imagePath != "" || _txtRemarks.text != "") {
      String fileName = widget.imagePath.split('/').last;
      print(fileName);
      print(widget.idBarang);
      var formData = FormData.fromMap({
        'foto':
            await MultipartFile.fromFile(widget.imagePath, filename: fileName),
        'id_permintaan_barang': widget.idBarang,
        'id_jenis_part': widget.idJenisBarang,
        'id_dealer': _idDealer,
        'id_pemohon': _idUser,
        'tgl_transaksi_in': widget.tglTransaksi,
        'keterangan': _txtRemarks.text
      });

      bloc.doPengajuan(formData, (callback) {
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
                                        ? "Success"
                                        : (message == "not accept")
                                            ? "Failed"
                                            : message,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (status == "success") {
                                        Navigator.of(
                                                context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PengajuanBarangPage()),
                                                (Route<dynamic> route) =>
                                                    false);
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
