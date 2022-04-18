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
import 'package:geofancing/src/bloc/BlocCarWorkingDone.dart';
import 'package:geofancing/src/models/standart_model.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/models/car_working_model_done.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/widgets/additional_widgets.dart';
import 'package:geofancing/src/widgets/ButtonWidgetLoading.dart';
import 'package:geofancing/src/widgets/DoubleBackToCloseApp.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:geofancing/src/bloc/change_status_working_bloc.dart' as blocCarWorking;

class DetailWorkingCarDone extends StatefulWidget {
  String id_uniq;

  @override
  State<StatefulWidget> createState() => _DetailWorkingCarDone();

  DetailWorkingCarDone({this.id_uniq});
}

class _DetailWorkingCarDone extends State<DetailWorkingCarDone> {
  bool _isLoading = true;
  String _idUser;
  HistoryCarWorkingModelsDone _detailCarWorking;
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
      var data = {"id_uniq" : widget.id_uniq, "method" : "detail_after", "id_user" : _idUser};
      bloc.getsHistoryCarWorkingDone(data, (model) {
        getData(model);
      });
    });


  }

  getData(HistoryCarWorkingModelsDone models) {
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
                        txt: "Detail Car Working Done",
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
                      // _detailCarWorking.data.list_foto != null ?
                      Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child: _detailCarWorking.data.list_foto != null && _detailCarWorking.data.list_foto.where((data) =>
                            data.code == 'D001' && data.foto != "").length > 0 ? Column(
                              mainAxisAlignment:MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20),
                                Container(
                                    height: 40,
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                    child: TextWidget(
                                      txt: "Foto KM ",
                                      color: colorBlack,
                                      txtSize: 18,
                                      weight: FontWeight.bold,
                                    )
                                ),
                                Container(
                                    child: _attachPhoto(
                                        context ,_detailCarWorking.data.list_foto.where((data) => data.code =='D001').toList()
                                    )
                                ),
                              ],
                            ) : SizedBox(),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child: _detailCarWorking.data.list_foto != null && _detailCarWorking.data.list_foto.where((data) =>
                            data.code == 'D002' && data.foto != "").length > 0 ? Column(
                              mainAxisAlignment:MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20),
                                Container(
                                    height: 40,
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                    child: TextWidget(
                                      txt: "Foto Tampak Depan ",
                                      color: colorBlack,
                                      txtSize: 18,
                                      weight: FontWeight.bold,
                                    )
                                ),
                                Container(
                                    child: _attachPhoto(
                                        context ,_detailCarWorking.data.list_foto.where((data) => data.code =='D002').toList()
                                    )
                                ),
                              ],
                            ) : SizedBox(),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child: _detailCarWorking.data.list_foto != null && _detailCarWorking.data.list_foto.where((data) =>
                            data.code == 'D003' && data.foto != "").length > 0 ? Column(
                              mainAxisAlignment:MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20),
                                Container(
                                    height: 40,
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                    child: TextWidget(
                                      txt: "Foto Filter ",
                                      color: colorBlack,
                                      txtSize: 18,
                                      weight: FontWeight.bold,
                                    )
                                ),
                                Container(
                                    child: _attachPhoto(
                                        context ,_detailCarWorking.data.list_foto.where((data) => data.code =='D003').toList()
                                    )
                                ),
                              ],
                            ) : SizedBox(),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child: _detailCarWorking.data.list_foto != null && _detailCarWorking.data.list_foto.where((data) =>
                            data.code == 'D004' && data.foto != "").length > 0 ? Column(
                              mainAxisAlignment:MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20),
                                Container(
                                    height: 40,
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                    child: TextWidget(
                                      txt: "Foto Suhu/Windspeed ",
                                      color: colorBlack,
                                      txtSize: 18,
                                      weight: FontWeight.bold,
                                    )
                                ),
                                Container(
                                    child: _attachPhoto(
                                        context ,_detailCarWorking.data.list_foto.where((data) => data.code =='D004').toList()
                                    )
                                ),
                              ],
                            ) : SizedBox(),
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child: _detailCarWorking.data.list_foto != null && _detailCarWorking.data.list_foto.where((data) =>
                            data.code == 'D005' && data.foto != "").length > 0 ? Column(
                              mainAxisAlignment:MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20),
                                Container(
                                    height: 40,
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                    child: TextWidget(
                                      txt: "Foto Blower ",
                                      color: colorBlack,
                                      txtSize: 18,
                                      weight: FontWeight.bold,
                                    )
                                ),
                                Container(
                                    child: _attachPhoto(
                                        context ,_detailCarWorking.data.list_foto.where((data) => data.code =='D005').toList()
                                    )
                                ),
                              ],
                            ) : SizedBox(),
                          )
                        ],
                      ),
                      //     : Container(
                      //   height: MediaQuery.of(context).size.height / 2,
                      //   child: dataNotFound(context),
                      // ),
                    ],
                  ) : Container(),
                ),
              )
          ),

        ],
      ),
    );
  }
  Widget _attachPhoto(BuildContext context, data) {

    // String code = data[0].code;
    // print("data " + data.);
    // print("data " +  data[0].foto.toString());
    List image = data[0].foto.split(',');
    List name = data[0].file_name.split(',');
    if (image.length > 6) {
      return ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 80, // Set as you want or you can remove it also.
            maxHeight: double.infinity,
            maxWidth: double.infinity,
            minWidth: 50),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: 6,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            if (index == 5) {
              return GestureDetector(
                onTap: () {
                  showListImage(context, image, name);
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.2),
                                  BlendMode.dstATop),
                              image: NetworkImage(image[index]),
                              fit: BoxFit.cover,
                            ),
                            color: colorBlack),
                        width: double.infinity),
                    Align(
                      alignment: Alignment.center,
                      child: TextWidget(
                        txt: "+" + (image.length - 6).toString(),
                        color: colorWhite,
                        txtSize: 50,
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Container(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
//                      routeToWidget(context, FullScreenImage(image: image[index],title: name[index]));
                      showImage(context, image[index], name[index], false);
                    },
                    child: CachedNetworkImage(
                      imageUrl: image[index],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(strokeWidth: 10),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ));
            }
          },
        ),
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 80, // Set as you want or you can remove it also.
            maxHeight: double.infinity,
            maxWidth: double.infinity,
            minWidth: 50),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: image.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (image.length > 3) ? 3 : image.length),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                showImage(context, image[index], name[index], false);
              },
              child: CachedNetworkImage(
                imageUrl: image[index],
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => SizedBox(
                    height: 10.0,
                    width: 10.0,
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                        strokeWidth: 5.0)),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            );
          },
        ),
      );
    }
  }
  Widget _attachPhotox(BuildContext context,  dataImage) {
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
          itemCount: 2,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
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
                          txt: _detailCarWorking.data.perawatan,
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
                          txt: _detailCarWorking.data.penggantian,
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
                          txt: _detailCarWorking.data.nopol,
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
                          txt: _detailCarWorking.data.model,
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
                          txt: _detailCarWorking.data.km,
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
                          txt: _detailCarWorking.data.hp,
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
                          txt: _detailCarWorking.data.lp,
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
                          txt: _detailCarWorking.data.suhu,
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
                          txt: _detailCarWorking.data.windspeed,
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
                          txt: _detailCarWorking.data.filter,
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
                          txt: _detailCarWorking.data.blower,
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



}
