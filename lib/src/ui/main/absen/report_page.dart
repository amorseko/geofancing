import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geofancing/src/bloc/history_bloc.dart';
import 'package:geofancing/src/bloc/request/req_history_absen.dart';
import 'package:geofancing/src/models/history_model.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:shimmer/shimmer.dart';
import 'package:geofancing/src/utility/app_config.dart';


class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool _isLoading=true;


  List<HistoryData> dataAbsen = [];
  Future _future;
  List absensiData = List<HistoryData>();
  String name;

  AppConfig _ac;

  initData(){

    SharedPreferencesHelper.getDoLogin().then((value) async{
      final members = MemberModels.fromJson(json.decode(value));
      setState(() {
        name=members.data.nama_user;
      });
      ReqHistoryAbsen params = ReqHistoryAbsen(
          id_pegawai: members.data.id_user
      );
      await bloc.getHistory(params.toMap(), (status, error, message, model){

        HistoryModels dataM = model;
        for(int i=0; i<dataM.data.length; i++){
          absensiData.add(dataM.data.elementAt(i));
        }

        setState(() {
          _isLoading=false;
        });
      });

    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initData();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("History Absen",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: CorpToyogaColor),
      body: ProgressDialog(
        inAsyncCall: _isLoading,
        child: Column(
          children: <Widget>[
            Card(
              elevation: 5,
              child: Container(
                height: 200,
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    ClipOval(
                          child: Image.asset('assets/icons/icons_peserta.png',
                          fit: BoxFit.cover,
                          matchTextDirection: true,
                          height: 120,
                          width: 120,),
//                        child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTG6a6KfKK66Jy1eCuDau7yp2rb5dIfGvl45g&usqp=CAU',
//                          fit: BoxFit.cover,
//                          matchTextDirection: true,
//                          height: 120,
//                          width: 120,
//                        )
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      name != null ? name : " ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    )

                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child:  ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: absensiData.length,
                      itemBuilder: (context, index){
                          return AbsenList(
                            index: index,
                            absenData: absensiData[index]
                        );
                      },
                    )
              ),
            ),
          ],
        ),
      )
    );
  }


  Future<List<HistoryData>> getHistoryAbsen() async{
    SharedPreferencesHelper.getDoLogin().then((value) async{
      final members = MemberModels.fromJson(json.decode(value));
      ReqHistoryAbsen params = ReqHistoryAbsen(
          id_pegawai: members.data.id_user
      );
      await bloc.getHistory(params.toMap(), (status, error, message, model){

        print(model.status);
        setState(() {
          dataAbsen = model.data;
          _isLoading=false;

        });
        dataAbsen = model.data;

      });

    });
    print(dataAbsen.length);

    return dataAbsen;
  }
}

class AbsenList extends StatelessWidget {
  final int index;
  final HistoryData absenData;
  //AppConfig _ac;

  const AbsenList({Key key, this.index, this.absenData});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: index != -1
              ? ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: Container(
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.width/3,
                width: MediaQuery.of(context).size.width,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      absenData.tanggal,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.timer
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Jam Masuk",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      absenData.absen_masuk,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green

                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.grey,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[

                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Jam Pulang",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      absenData.absen_keluar == "" ? "-":absenData.absen_keluar,
                                      style: TextStyle(
                                          fontSize: 18,
                                      color: Colors.red
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                    Icons.timer
                                ),
                              ],
                            )
                          ],
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ): Container(
              height: 50,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey
              )
          )
      ),
    );
  }
}

