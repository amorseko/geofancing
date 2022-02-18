import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:geofancing/src/models/history_barang_model.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/bloc/history_barang_bloc.dart';
import 'package:geofancing/src/bloc/request/req_history_items.dart';
import 'package:shimmer/shimmer.dart';
import 'package:geofancing/src/utility/app_config.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/ui/main/pengajuan_barang/form_pengajuan.dart';

class PengajuanBarangPage extends StatefulWidget {
  @override
  _PengjuanBarangPageState createState() => _PengjuanBarangPageState();
}

class _PengjuanBarangPageState extends State<PengajuanBarangPage> {
  bool _isLoading=true;


  List<HistoryBarangData> dataBarang = [];

  List BarangData = List<HistoryBarangData>();
  String name;

  initData(){

    SharedPreferencesHelper.getDoLogin().then((value) async{
      final members = MemberModels.fromJson(json.decode(value));
      setState(() {
        name=members.data.nama_user;
      });

      ReqHistoryItems params = ReqHistoryItems(
          id_user: members.data.id_user
      );

      await bloc.getHistory(params.toMap(), (status, error, message, model){

        HistoryBarangModels dataM = model;

        print(dataM.data.length);
        for(int i=0; i<dataM.data.length; i++){
          BarangData.add(dataM.data.elementAt(i));
        }

        print(members.data.id_user);

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
          title:
            Text("History Permintaan Barang",
              style: TextStyle(color: Colors.white)
            ),
          centerTitle: true,
          backgroundColor: CorpToyogaColor
        ),
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
                      ]
                  ),
                )
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: BarangData.length,
                    itemBuilder: (context, index){
                      return barangList(
                          index: index,
                          barangData: BarangData[index]
                      );
                    },
                  )
                )
              )
            ],
          ),
        ),
        floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 50.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white
              ),
              backgroundColor: CorpToyogaColor,
              onPressed: (){
                routeToWidget(context, FormPengajuanPage(id_barang: "",)).then((value) {
                  setPotrait();
                });
//                routeToWidget(context, FormPengajuanPage());
              },
            )
          ),
        )
    );
  }

  Future<List<HistoryBarangData>> getHistoryData() async{
    SharedPreferencesHelper.getDoLogin().then((value) async{
      final members = MemberModels.fromJson(json.decode(value));
      ReqHistoryItems params = ReqHistoryItems(
          id_user: members.data.id_user
      );
      await bloc.getHistory(params.toMap(), (status, error, message, model){

        print(model.status);
        setState(() {
          dataBarang = model.data;
          _isLoading=false;

        });
        dataBarang = model.data;

      });

    });

    return dataBarang;
  }

}

class barangList extends StatelessWidget {
  final int index;
  final HistoryBarangData barangData;

  const barangList({Key key, this.index, this.barangData});

  Widget build(BuildContext context) {
    return GestureDetector(
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
                        barangData.npb + " - Tanggal : " + barangData.tgl_transaksi_in,
                        style: TextStyle(
                            fontSize: 15,
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
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                child: Container(
                                                  child: Text(
                                                    "Jenis : " + barangData.jenis_part,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                child: Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    "Dealer : " + barangData.nama_dealer,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Align(
                                                child: Container(
                                                  child: Text(
                                                    "Keterangan : " + barangData.keterangan,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]
                                        )

                                      ],
                                  )
                                ],
                            )
                          ],
                      )
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