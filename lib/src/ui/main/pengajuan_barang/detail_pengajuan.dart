import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/models/list_barang_detail_model.dart';
import 'package:geofancing/src/bloc/request/req_list_barang_detail.dart';
import 'package:geofancing/src/bloc/get_list_barang_detail_bloc.dart';
import 'package:geofancing/src/bloc/del_barang_detail_bloc.dart'  as delBloc;
import 'package:geofancing/src/bloc/request/req_del_barang_detail.dart';
import 'package:geofancing/src/models/standart_model.dart';

class PageDetailPengajuan extends StatefulWidget {
  String id_barang_detail;
  @override
  _PageDetailPengajuan createState() => _PageDetailPengajuan();
  PageDetailPengajuan({this.id_barang_detail});
}

class _PageDetailPengajuan extends State<PageDetailPengajuan> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;

  List<GetListBarangDetailData> dataListBarangDetailModel = [];


  List barangDetailData = List<GetListBarangDetailData>();

  void removeItem(index) {
    setState(() {
      barangDetailData.removeAt(index);
    });
  }


  initData() async {
    reqListBarangDetailItems params = reqListBarangDetailItems(
        id_permintaan_barang : widget.id_barang_detail
    );

    await bloc.getListBarangDetail(params.toMap(), (status, error, message, model){

      GetListBarangDetailModels dataM = model;

      for(int i=0; i<dataM.data.length; i++){
        barangDetailData.add(dataM.data.elementAt(i));
      }



      setState(() {
        _isLoading=false;
      });
    });
  }

  void initState()  {
    // TODO: implement initState
    super.initState();
    initData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.white),
        title: TextWidget(txt: "Detail", color: colorTitle()),
        backgroundColor: CorpToyogaColor,
        elevation: 0,
      ),
      body: ProgressDialog(
        inAsyncCall: _isLoading,
        child: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: barangDetailData.length,
                itemBuilder: (context, index){
                  return BarangListDetail(
                      index: index,
                      barangListDetailData: barangDetailData[index],
                      onDelete: () => removeItem(index),
//                      onDelete: () => removeItem(index) ,
                  );
                },
              )
          ),
        ),

      ),
    );
  }
}

class BarangListDetail extends StatelessWidget {
  final int index;
  final GetListBarangDetailData barangListDetailData;
  final VoidCallback onDelete;
//  final Function(BarangListDetail) removeItem;



  const BarangListDetail({Key key,this.index, this.barangListDetailData, this.onDelete}): super(key: key);

//  _delBarangDetail(id_pdb) {
//    if(id_pdb != "") {
//      reqDelBarangDetail request = reqDelBarangDetail(
//        id_dpb: id_pdb,
//      );
//      delBloc.bloc.actDelBarangDetail(request.toMap(),  (status, message) => {
//
//      });
//    }
//  }

  Widget build(BuildContext context) {
    return GestureDetector(
        key: Key(barangListDetailData.id_dpb),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: index != - 1 ? ClipRRect(
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
                height: MediaQuery.of(context).size.width/2.5,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "ID Permintaan Barang : " + barangListDetailData.id_permintaan_brg,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        IconButton(
                          icon: new Icon(Icons.delete, color: CorpToyogaColor,),
                          onPressed:(){
                            print(index);
                            showMessage(context, onDelete,barangListDetailData.id_dpb);
//                            this.onDelete();
                          },
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                            "Jenis : " + barangListDetailData.jenis_part,
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
                                            "Part : " + barangListDetailData.kode_part,
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
                                            "Nama Part : " + barangListDetailData.nama_parts,
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
                                            "Nama Satuan : " + barangListDetailData.nama_satuan,
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ) : Container(
            child: Image.asset(
              'assets/images/not_found.png',
              width: MediaQuery.of(context).size.width,
            ),
            alignment: FractionalOffset.topCenter,
            decoration: BoxDecoration(color: Colors.transparent),
          ),
        )
    );
  }

  showAlertDialog(BuildContext context, message) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );


    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void resultSuccess(context,bool status,onDelete) {
    if(status == true) {
      this.onDelete();
    } else {
      showAlertDialog(context, "Failed delete !");
    }
  }

  void showMessage(BuildContext context, onDelete, id_dpb){
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height/ 4,
            child:new SingleChildScrollView(
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
                                  Text("Are you sure want to delete this item ?",
                                    style: TextStyle(
                                        fontSize: 15
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {

                                          Navigator.pop(context);
                                            if(id_dpb != "") {
                                              reqDelBarangDetail request = reqDelBarangDetail(
                                                id_dpb: id_dpb,
                                              );
                                              delBloc.bloc.actDelBarangDetail(request.toMap(),
                                                      (status, message) => {
                                               resultSuccess(context, status, onDelete)
                                              });
                                            }



                                        },
                                        child: Container(
                                            width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                            height: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius: new BorderRadius.all(
                                                    const Radius.circular(30.0)),
                                                color: CorpToyogaColor),
                                            child: Text("OK",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white
                                              ),
                                            )
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                            height: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius: new BorderRadius.all(
                                                    const Radius.circular(30.0)),
                                                color: secondaryColor),
                                            child: Text("CANCEL",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white
                                              ),
                                            )
                                        ),
                                      ),
                                    ],
                                  ),

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