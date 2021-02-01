import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geofancing/src/bloc/bloc_profile.dart';
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
  final blocProfile = DoProfileBloc();
  String _name, id_user;

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
        print(dataM.data[0].no_hp);
        _nik.text = dataM.data[0].nik;
        _noHp.text = dataM.data[0].no_hp;
        _alamat.text = dataM.data[0].alamat_pegawai;
        _noSepatu.text = dataM.data[0].no_sepatu;
        _sizeWarepak.text = dataM.data[0].u_werpack;
        _noBPJS.text = dataM.data[0].no_bpjs;
        _isLoading = false;
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
