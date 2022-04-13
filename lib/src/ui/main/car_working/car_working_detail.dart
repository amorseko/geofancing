import 'dart:io';
import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/bloc/bloc_car_working.dart';
import 'package:geofancing/src/models/standart_model.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/models/car_working_model.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/widgets/additional_widgets.dart';
import 'package:geofancing/src/widgets/ButtonWidgetLoading.dart';
import 'package:geofancing/src/widgets/DoubleBackToCloseApp.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:geofancing/src/bloc/change_status_working_bloc.dart' as blocCarWorking;

class DetailWorkingCar extends StatefulWidget {
  String id_uniq;

  @override
  State<StatefulWidget> createState() => _DetailWorkingCar();

  DetailWorkingCar({this.id_uniq});
}

class _DetailWorkingCar extends State<DetailWorkingCar> {
  bool _isLoading = true;
  String _idUser;
  HistoryCarWorkingModels _detailCarWorking;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final ButtonWidgetLoadController _btnAcceptController = new ButtonWidgetLoadController();

  void initState() {
    // TODO: implement initState
    super.initState();
    new Timer(const Duration(milliseconds: 150), ()
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

    SharedPreferencesHelper.getDoLogin().then((value)  {
      final member = MemberModels.fromJson(json.decode(value));
      setState(() {
        _idUser = member.data.id_user;
      });
      var data = {"id_uniq" : widget.id_uniq, "method" : "detail", "id_user" : _idUser};
      bloc.getsHistoryCarWorking(data, (model) {
        getData(model);
      });
    });


  }

  getData(HistoryCarWorkingModels models) {
    setState((){
      _detailCarWorking = models;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
        child: Stack(
          children: <Widget>[
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                color: CorpToyogaColor,
              ),
            ),
            Scaffold(
              key: _scaffoldKey,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(100.0),
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: AppBar(
                    brightness: Brightness.light,
                    iconTheme: IconThemeData(color: colorTitle()),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: TextWidget(
                        txt: "Detail Car Working",
                        color: colorTitle()
                    ),
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: colorWhite),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }
                    ),
                  ),
                ),
              ),
                backgroundColor: Colors.transparent,
              body: DoubleBackToCloseApp(
                snackBar: snackBar(),
                child: ProgressDialog(
                  inAsyncCall: _isLoading,
                  child: _detailCarWorking.toString() != 'null' ?
                      ListView(
                        children: <Widget> [
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.white,
                              child: Stack(
                                children: <Widget>[
                                  _contentResultValid(context),
                                ],
                              ),
                            )
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color: Colors.white,
                                child: Stack(
                                  children: <Widget>[
                                    _contentRepair(context),
                                  ],
                                ),


                              )
                          ),
                          for (var i = 0; i <  _detailCarWorking.data[0].list_foto.split(', ').length; i++)
                            Container(
                              child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      child: _detailCarWorking.data[0].list_foto.split(', ')[i] != null || _detailCarWorking.data[0].list_foto.split(', ')[i] != "" ?
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: 20,),
                                          Container(
                                              height: 40,
                                              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                              child: TextWidget(
                                                  txt: _textImage(i.toString()),
                                                  color: Colors.black,
                                                  txtSize: 18,
                                                  weight: FontWeight.bold
                                              )
                                          ),
                                          Container(
                                              child: _attachPhoto(
                                                  context, _detailCarWorking.data[0].list_foto.split(', ')[i]
                                              )
                                          )
                                        ],
                                      ) : SizedBox(),
                                    )
                                  ]
                              ),
                            ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom : 32, left: 21, right: 21),
                            child: Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: ButtonWidgetLoad(
                                  child: TextWidget(
                                    txt: "ACCEPT",
                                    color: Colors.white,
                                    txtSize: 14,
                                    fontFamily: 'Bold',
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  borderRadius: 15.0,
                                  color: Colors.redAccent[400],
                                  successColor: Colors.redAccent[400],
                                  controller: _btnAcceptController,
                                  onPressed: () =>  _onAccept(context) ,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ) : Container(),
                ),
              )
            ),

          ],
        ),
    );
  }

  Widget _attachPhoto(BuildContext context, String dataImage) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 80,
        maxHeight: double.infinity,
        maxWidth: double.infinity,
        minWidth: 50
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                showImage(context, dataImage, "1", false);
              },
              child: CachedNetworkImage(
                imageUrl: dataImage,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                        fit: BoxFit.cover,
                    )
                  )
                ),
                placeholder: (context, url) => SizedBox(
                    height: 10.0,
                    width: 10.0,
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                        strokeWidth: 5.0)
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
            );
          },
      )
    );
  }

  Widget _contentRepair(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(25, 15, 25, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      txt: "Perawatan",
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.left,
                    ),
                    TextWidget(
                      txt: _detailCarWorking.data[0].perawatan,
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.right,
                    ),
                  ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextWidget(
                    txt: "Penggantian",
                    txtSize: 12,
                    color: Colors.black,
                    align: TextAlign.left,
                  ),
                  TextWidget(
                    txt: _detailCarWorking.data[0].penggantian,
                    txtSize: 12,
                    color: Colors.black,
                    align: TextAlign.right,
                  ),
                ],
              ),
            ]
          )
        )
      ]
    );
  }

  String _textImage(String dataCount) {
    switch(dataCount) {
      case '0' : {
          return 'Foto KM';
          break;
      }
      case '1' : {
        return 'Foto Tampak Depan';
        break;
      }
      case '2' : {
        return 'Foto Filter';
        break;
      }
      case '3' : {
        return 'Foto Suhu/Windspeed';
        break;
      }
      case '4' : {
        return 'Foto Blower';
        break;
      }
    }
  }

  Widget _contentResultValid(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(25, 15, 25, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextWidget(
                    txt: "No polisi",
                    txtSize: 12,
                    color: Colors.black,
                    align: TextAlign.left,
                  ),
                  TextWidget(
                    txt: _detailCarWorking.data[0].nopol,
                    txtSize: 12,
                    color: Colors.black,
                    align: TextAlign.right,
                  ),
                ]
              ),
              SizedBox(height: 10,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      txt: "Model Mobil",
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.left,
                    ),
                    TextWidget(
                      txt: _detailCarWorking.data[0].model,
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.right,
                    ),
                  ]
              ),
              SizedBox(height: 10,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      txt: "KM",
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.left,
                    ),
                    TextWidget(
                      txt: _detailCarWorking.data[0].km,
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.right,
                    ),
                  ]
              ),
              SizedBox(height: 10,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      txt: "HP",
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.left,
                    ),
                    TextWidget(
                      txt: _detailCarWorking.data[0].hp,
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.right,
                    ),
                  ]
              ),
              SizedBox(height: 10,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      txt: "LP",
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.left,
                    ),
                    TextWidget(
                      txt: _detailCarWorking.data[0].lp,
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.right,
                    ),
                  ]
              ),
              SizedBox(height: 10,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      txt: "Suhu",
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.left,
                    ),
                    TextWidget(
                      txt: _detailCarWorking.data[0].suhu,
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.right,
                    ),
                  ]
              ),
              SizedBox(height: 10,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      txt: "Windspeed",
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.left,
                    ),
                    TextWidget(
                      txt: _detailCarWorking.data[0].windspeed,
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.right,
                    ),
                  ]
              ),
              SizedBox(height: 10,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      txt: "Filter",
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.left,
                    ),
                    TextWidget(
                      txt: _detailCarWorking.data[0].filter,
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.right,
                    ),
                  ]
              ),
              SizedBox(height: 10,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      txt: "Blower",
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.left,
                    ),
                    TextWidget(
                      txt: _detailCarWorking.data[0].blower,
                      txtSize: 12,
                      color: Colors.black,
                      align: TextAlign.right,
                    ),
                  ]
              )
            ]
          )
        ),
      ],
    );
  }

  _onAccept(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    
    var data = {"id_uniq" : widget.id_uniq};


    blocCarWorking.bloc.actChangeStatusWorking(data, (status, message)  {

      if(status) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message), backgroundColor: Colors.green
        ));

        Navigator.of(context).pushNamedAndRemoveUntil('/list_working_car_before', (Route<dynamic> route) => false);

      } else {

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message), backgroundColor: Colors.red
        ));

      }

      _btnAcceptController.reset();
    });


  }

}
