import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geofancing/src/models/default_model.dart';

import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/models/jenis_part_model.dart';
import 'package:geofancing/src/bloc/get_list_jenis_part_bloc.dart';
import 'package:geofancing/src/models/kategori_part_model.dart';
import 'package:geofancing/src/bloc/get_list_kategori_part.dart';
import 'package:geofancing/src/models/list_barang_model.dart';
import 'package:geofancing/src/bloc/get_list_nama_barang_bloc.dart';
import 'package:geofancing/src/bloc/request/req_barang.dart';
import 'package:geofancing/src/bloc/get_satuan_nama.dart';
import 'package:geofancing/src/models/satuan_model.dart';
import 'package:geofancing/src/bloc/request/req_satuan.dart';
import 'package:geofancing/src/ui/main/pengajuan_barang/detail_pengajuan.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/ui/main/pengajuan_barang/submit_pengajuan.dart';
import 'package:geofancing/src/bloc/pengajuan_detail_bloc.dart';
import 'package:geofancing/src/bloc/id_detail_bloc.dart';
import 'package:geofancing/src/models/id_barang_detail_model.dart';
import 'package:dio/dio.dart';

class FormPengajuanPage extends StatefulWidget {
  String id_barang;
  @override
  _FormPengajuanPage createState() => _FormPengajuanPage();
  FormPengajuanPage({this.id_barang});
}

class KondisiBarangs {
  const KondisiBarangs(this.id, this.kondisi);

  final String kondisi;
  final String id;
}

class _FormPengajuanPage extends State<FormPengajuanPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  bool _isVisible = false;

  DateTime selectedDate = DateTime.now();

  String valueDate;

  String JenisPart,
      KategoriPart,
      NamaBarang,
      NamaSatuan,
      _IdNamaSatuan,
      KondisiBarang,
      _idUser,
      _idBarang;

  TextEditingController _date = new TextEditingController();
  TextEditingController _txtJumlah = new TextEditingController();
  TextEditingController _txtSatuan = new TextEditingController();

  GetListJenisPartModels _JenisPartModels = GetListJenisPartModels();
  GetListKategoriPartModels _KategoriPartModels = GetListKategoriPartModels();
  GetListNamaBarangModels _NamaBarangModels = GetListNamaBarangModels();
  PengajuanDetailBloc bloc = PengajuanDetailBloc();
  GetSatuanModels _SatuanModels = GetSatuanModels();
  IDBarangModels _IdBarangModels = IDBarangModels();
  final listJenisPartBloc = GetListJenisPartBloc();
  final listKategoriPart = GetListKategoriPartBloc();
  final listNamaBarang = GetListNamaBarangBloc();
  final listSatuan = GetSatuanNamaBloc();

  bool _disableButton = true;

  final idBarangModel = GetIdBarangDetailBloc();

//  KondisiBarangs selectedKondisiBarang;
  List<KondisiBarangs> _kondisiBarang = <KondisiBarangs>[
    const KondisiBarangs("1", 'Rusak'),
    const KondisiBarangs("2", 'Hilang')
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    initData();

    SharedPreferencesHelper.getDoLogin().then((onValue) {
      final memberModels = MemberModels.fromJson(json.decode(onValue));
      setState(() {
        _idUser = memberModels.data.id_user;
        if (widget.id_barang == "" || widget.id_barang == null) {
          _GetIdBarang();
        }
      });
    });

    _attempJenisPart();
    _attempKategoriPart();
    _isLoading = false;
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
        key: _scaffoldKey,
        appBar: AppBar(
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.white),
          title: TextWidget(txt: "Form Pengajuan", color: colorTitle()),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.assignment,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
                routeToWidget(context,
                        PageDetailPengajuan(id_barang_detail: _idBarang))
                    .then((value) {
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
                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _bgHeader(context),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 0.0),
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () => {_selectDate(context)},
                                  child: TextFormField(
                                    enabled: false,
                                    controller: _date,
                                    decoration: InputDecoration(
                                        labelText: allTranslations
                                            .text("txt_tanggal")),
//                            initialValue: valueDate,
                                  ),
                                )
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 0.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: TextWidget(
                                txt: "Pilih jenis part",
                                txtSize: 12,
                              ),
                              isExpanded: true,
                              onChanged: (newValue) {
                                setState(() {
                                  JenisPart = newValue;
                                  print("Data Jenis Part : $JenisPart");
                                  NamaBarang = null;
                                  KondisiBarang = null;
                                  _txtSatuan.clear();
                                  newValue == "3"
                                      ? _isVisible = true
                                      : _isVisible = false;
                                });
                                _attempNamaBarang(newValue);
                              },
                              value: JenisPart,
                              items: _JenisPartModels.data == null
                                  ? List<String>()
                                      .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem(
                                          value: value,
                                          child: Text(value,
                                              style: TextStyle(fontSize: 12)));
                                    }).toList()
                                  : _JenisPartModels.data
                                      .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem(
//                              onTap: () {
//                                _attempNamaBarang(value.id_jenis_part);
//                              },
                                          value: value.id_jenis_part,
                                          child: Text(
                                            value.jenis_part,
                                            style: TextStyle(fontSize: 12),
                                          ));
                                    }).toList(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 0.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: TextWidget(
                                txt: "Pilih Kategori Part",
                                txtSize: 12,
                              ),
                              isExpanded: true,
                              onChanged: (newValue) {
                                setState(() {
                                  KategoriPart = newValue;
                                });
                              },
                              value: KategoriPart,
                              items: _KategoriPartModels.data == null
                                  ? List<String>()
                                      .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem(
                                          value: value,
                                          child: Text(value,
                                              style: TextStyle(fontSize: 12)));
                                    }).toList()
                                  : _KategoriPartModels.data
                                      .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem(
                                          value: value.id_kategori_part,
                                          child: Text(
                                            value.nama_kategori_part,
                                            style: TextStyle(fontSize: 12),
                                          ));
                                    }).toList(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 0.0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: TextWidget(
                                txt: "Pilih Nama Barang",
                                txtSize: 12,
                              ),
                              isExpanded: true,
                              onChanged: (newValue) {
//                          NamaBarang = newValue;
                                setState(() {
                                  NamaBarang = newValue;
                                });
                              },
                              value: NamaBarang,
                              items: _NamaBarangModels.data == null
                                  ? List<String>()
                                      .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem(
                                          value: value,
                                          child: Text(value,
                                              style: TextStyle(fontSize: 12)));
                                    }).toList()
                                  : _NamaBarangModels.data
                                      .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem(
                                          onTap: () {
                                            _attempNamaSatuan(value.satuan);
                                          },
                                          value: value.id_barang,
                                          child: Text(
                                            value.nama_parts,
                                            style: TextStyle(fontSize: 12),
                                          ));
                                    }).toList(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 0.0),
                          child: _buildDropDown(_isVisible),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 0.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _txtJumlah,
                            decoration: InputDecoration(
                              labelText: 'Total',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 0.0),
                          child: TextFormField(
                            enabled: false,
                            controller: _txtSatuan,
                            decoration: InputDecoration(
                              labelText: allTranslations.text("txt_satuan"),
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
                                  txt: "ADD",
                                  txtSize: 14.0,
                                ),
                                elevation: 4.0,
                                color: CorpToyogaColor,
                                splashColor: Colors.redAccent,
                                onPressed: () {
                                  _AddDetail();
                                },
                              ),
                              height: 50.0,
                            ),
                          ),
                        ),
//
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
                                  txt: "NEXT",
                                  txtSize: 14.0,
                                ),
                                elevation: 4.0,
                                color: CorpSecondToyoga,
                                splashColor: Colors.blueAccent,
                                onPressed: () {
                                  if (widget.id_barang != "") {
                                    _idBarang = widget.id_barang;
                                  }

                                  print(KondisiBarang);

                                  if (_idBarang == "") {
                                    print("data kosong ");
                                  } else {
                                    print(_idBarang);
                                    _disableButton
                                        ? null
                                        : routeToWidget(
                                            context,
                                            SubmitPengajuanPage(
                                              imagePath: "",
                                              idBarang: _idBarang,
                                              idJenisBarang: JenisPart,
                                              KondisiBarang: KondisiBarang,
                                              tglTransaksi: _date.text,
                                            )).then((value) {
                                            setPotrait();
                                          });
                                  }
                                },
                              ),
                              height: 50.0,
                            ),
                          ),
                        ),
                      ]))),
        ));
  }

  _buildDropDown(bool enable) {
    if (enable) {
      return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: TextWidget(
            txt: "Pilih Kondisi Barang",
            txtSize: 12,
          ),
          isExpanded: true,
          onChanged: (newValue) {
            setState(() {
              KondisiBarang = newValue;
            });
          },
          value: KondisiBarang,
          items: _kondisiBarang.map((KondisiBarangs _kondisibarang) {
            return DropdownMenuItem(
              value: _kondisibarang.id,
              child: Text(
                _kondisibarang.kondisi,
                style: TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      // Just Divider with zero Height xD
      return Divider(color: Colors.white, height: 0.0);
    }
  }

  _AddDetail() {
    if (_date.text != "" ||
        JenisPart != "" ||
        KategoriPart != "" ||
        NamaBarang != "") {
      _isLoading = true;
      if (KondisiBarang == "" || KondisiBarang == null) {
        KondisiBarang = "0";
      }

      if (widget.id_barang != "") {
        _idBarang = widget.id_barang;
      }

      print(_idBarang);

      var formData = FormData.fromMap({
        'id_permintaan_brg': _idBarang,
        'id_jenis_part': JenisPart,
        'id_kategori_part': KategoriPart,
        'id_barang': NamaBarang,
        'ID_users': _idUser,
        'jumlah_in': _txtJumlah.text,
        'satuan_in': _IdNamaSatuan,
        'stt_save': "0",
        'stt_alat': KondisiBarang
      });

      bloc.doPengajuanDetail(formData, (callback) {
        DefaultModel model = callback;
        setState(() {
          _isLoading = false;
        });


        if (model.status != "success") {
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("Error : " + model.message)));
//          showErrorMessage(context, model.message, model.status);
        } else {
          _disableButton = false;

          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("Success !")));
          //clearFields();
        }
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
                                      Navigator.of(context).pop();
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        valueDate =
            "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
        _date.value = TextEditingValue(text: valueDate.toString());
      });
  }

  _attempJenisPart() {
    listJenisPartBloc.getListJenisParts((model) => {
          getDataJenisPart(model),
        });
  }

  _attempKategoriPart() {
    listKategoriPart.getListKategoriPartsBloc((model) => {
          getDataKategoriPart(model),
        });
  }

  _attempNamaBarang(val) {
    reqBarang request = reqBarang(id_jenis_part: val);
    listNamaBarang.getListNamaParangBlocs(
        request.toMap(),
        (model) => {
              getDataNamaBarang(model),
            });
  }

  _attempNamaSatuan(val) {
    print(val);
    reqSatuan request = reqSatuan(id_satuan: val);
    listSatuan.getListSatuanNamabloc(
        request.toMap(),
        (model) => {
              getDataSatuan(model),
            });
  }

  _GetIdBarang() {
    idBarangModel.getIdBarangs((model) => {
          getDataIdBarangDetail(model),
        });
  }

  getDataJenisPart(model) {
    setState(() {
      _JenisPartModels = model;
    });
  }

  getDataKategoriPart(model) {
    setState(() {
      _KategoriPartModels = model;
    });
  }

  getDataNamaBarang(model) {
    setState(() {
      _NamaBarangModels = model;
    });
  }

  getDataSatuan(model) {
    setState(() {
      _SatuanModels = model;
      NamaSatuan = _SatuanModels.data[0].nama_satuan;
      _IdNamaSatuan = _SatuanModels.data[0].id_satuan;
      _txtSatuan.value = TextEditingValue(text: NamaSatuan.toString());
    });
  }

  getDataIdBarangDetail(model) {
    setState(() {
      _IdBarangModels = model;
      _idBarang = _IdBarangModels.data[0].id_permintaan_barang;
      print("data permintaan barang : ${_idBarang}");
    });
  }

  void clearFields() {
    _txtJumlah.clear();
    _txtSatuan.clear();
    KondisiBarang = null;
    KategoriPart = null;
    NamaBarang = null;
  }
}
