import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geofancing/src/bloc/bloc_profile.dart';
import 'package:geofancing/src/bloc/list_bank_bloc.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/utility/colors.dart';
import 'package:geofancing/src/utility/sharedpreferences.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/models/standart_model.dart';
import 'package:geofancing/src/bloc/changeprofile.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/bloc/bloc_profile.dart' as blocProfile;
import 'package:geofancing/src/models/profile_model.dart';
import 'package:geofancing/src/models/list_bank_model.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;

  final _namaPegawai = TextEditingController();
  final _nik = TextEditingController();
  final _noHp = TextEditingController();
  final _alamat = TextEditingController();
  final _noSepatu = TextEditingController();
  final _sizeWarepak = TextEditingController();
  final _noBPJS = TextEditingController();
  final _namaIbuKandung = TextEditingController();
  final _NoRek = TextEditingController();
  final _AnRek = TextEditingController();
  final blocProfile = DoProfileBloc();
  final blocListBank = GetListBankBloc();
  String _name, id_user,_kdBankSelected = "";
  ListBankModels _mdlListBank = ListBankModels();

  void initState() {
    super.initState();

    _initView();

  }

  _initLoadData(iduser){
    var data;
    data = {
      "id_user" : iduser,
    };

    //print(data);

    blocProfile.fetchProfile(data, (status, error, message, model){
      ProfileModels dataM = model;
      setState(() {
        if(status == true)
        {
          print(dataM.data[0].no_hp);
          _nik.text = dataM.data[0].nik;
          _noHp.text = dataM.data[0].no_hp;
          _alamat.text = dataM.data[0].alamat_pegawai;
          _noSepatu.text = dataM.data[0].no_sepatu;
          _sizeWarepak.text = dataM.data[0].u_werpack;
          _noBPJS.text = dataM.data[0].no_bpjs;
          _namaIbuKandung.text = dataM.data[0].ibu_kandung;
          _NoRek.text = dataM.data[0].no_rek;
          _AnRek.text = dataM.data[0].an_rek;

          Timer(Duration(seconds: 1), () {
            _attempListBank(dataM.data[0].kd_bank);
            _kdBankSelected = dataM.data[0].kd_bank;
          });

          _isLoading = false;
        }
        else
          {
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("user not found")));
            _isLoading = false;
          }

      });
    });

  }

  _initView() {
    SharedPreferencesHelper.getDoLogin().then((member) {
      final memberModels = MemberModels.fromJson(json.decode(member));
      setState(() {
        _name = memberModels.data.nama_user;
        _namaPegawai.text = _name.toString();
        id_user = memberModels.data.id_user;
        //print(id_user);
        _initLoadData(id_user);
      });
    });
  }

  Widget _bgHeader(BuildContext context) {
    return new Container(
      child: Image.asset(
        'assets/images/img_changeprofile.jpg',
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
        title: TextWidget(
            txt: allTranslations.text("txt_changeprofile"),
            color: colorTitle()),
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
                  child: TextFormField(
                    controller: _namaPegawai,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: allTranslations.text("txt_nama_pegawai"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 0.0),
                  child: TextFormField(
                    controller: _nik,
                    decoration: InputDecoration(
                      labelText: allTranslations.text("txt_nik"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 0.0),
                  child: TextFormField(
                    controller: _noHp,
                    decoration: InputDecoration(
                      labelText: allTranslations.text("txt_no_hp"),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 0.0),
                  child: TextFormField(
                    controller: _noSepatu,
                    decoration: InputDecoration(
                      labelText: "No. Sepatu",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 0.0),
                  child: TextFormField(
                    controller: _sizeWarepak,
                    decoration: InputDecoration(
                      labelText: "Size Warepak",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 0.0),
                  child: TextFormField(
                    controller: _noBPJS,
                    decoration: InputDecoration(
                      labelText: "No. BPJS",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 0.0),
                  child: TextFormField(
                    controller: _namaIbuKandung,
                    decoration: InputDecoration(
                      labelText: "Nama Ibu Kandung",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 0.0),
                  child: TextFormField(
                    controller: _NoRek,
                    decoration: InputDecoration(
                      labelText: "No. Rekening",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 0.0),
                  child: TextFormField(
                    controller: _NoRek,
                    decoration: InputDecoration(
                      labelText: "A.N Rekening",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 0.0),
                  child:  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: TextWidget(
                        txtSize: 12,
                        txt : "Pilih Bank",
                      ),
                      isExpanded: true,
                      onChanged: (newValue) {
                        setState(() {
                          _kdBankSelected = newValue;

                        });

                      },
                      value: _kdBankSelected.isNotEmpty ? _kdBankSelected : null,
                      items: _mdlListBank.data == null ? List<String>()
                          .map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem(
                            value: value,
                            child: Text(value,
                                style: TextStyle(fontSize: 12)
                            )
                        );
                      }).toList()
                          : _mdlListBank.data
                          .map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem(
                            value: value.code,
                            child: Text(
                              value.name,
                              style: TextStyle(fontSize: 12),
                            ));
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 0.0),
                  child: TextFormField(
                    controller: _alamat,
                    decoration: InputDecoration(
                      labelText: allTranslations.text("txt_alamat"),
                    ),
                    keyboardType: TextInputType.multiline,
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
                          txt: allTranslations.text("txt_ubah"),
                          txtSize: 14.0,
                        ),
                        elevation: 4.0,
                        color: CorpToyogaColor,
                        splashColor: Colors.redAccent,
                        onPressed: () {
                          _changeProfile();
                        },
                      ),
                      height: 50.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _attempListBank(String kode)
  {
    var req = {
      "code" : kode
    };
    blocListBank.getListBankBloc(req, (model) => {
      print(model),
      storedDataBank(model),
    });
  }

  storedDataBank(model)
  {
    setState(() {
      print(model);
      _mdlListBank = model;
    });
  }

  _changeProfile() {
    var req;
    if(_namaPegawai.text != "" || _nik.text != "" || _noHp.text != "" || _alamat.text != "" || _noSepatu.text != "" || _sizeWarepak.text != "" || _noBPJS.text != "")
      {
        setState(() {
          _isLoading = true;
        });
        req = {
          "id_user": id_user,
          "nama_pegawai" : _namaPegawai.text,
          "nik" : _nik.text,
          "no_hp" : _noHp.text,
          "alamat" : _alamat.text,
          "no_sepatu" : _noSepatu.text,
          "size_warepak" : _sizeWarepak.text,
          "no_bpjs" : _noBPJS.text,
          "ibu_kandung" : _namaIbuKandung.text,
          "no_rek" : _NoRek.text,
          "an_rek" : _AnRek.text,
          "kd_bank" : _kdBankSelected,
        };

        bloc.actProfile(req,(status, message)  {
                setState(() {
                _isLoading = false;
                });
          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
                Navigator.pushNamedAndRemoveUntil(
                    context, "/main_page", (_) => false);
        });
      }
    else
      {
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Mohon lengkapi data terlebih dahulu !")));
      }
  }
}
