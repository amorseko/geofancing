import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:geofancing/src/bloc/request/req_history_car_working.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/ui/main/car_working/car_working_after.dart';
import 'package:geofancing/src/ui/main/car_working/car_working_before.dart';
import 'package:geofancing/src/ui/main/car_working/car_working_detail.dart';
import 'package:geofancing/src/ui/main/car_working/car_working_detail_done.dart';
import 'package:geofancing/src/ui/main/car_working/car_working_ec_after.dart';
import 'package:geofancing/src/ui/main/car_working/car_working_ec_before.dart';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/widgets/ButtonWidgetLoading.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/bloc/bloc_car_working.dart';
import 'package:geofancing/src/models/car_working_model.dart';
import 'package:geofancing/src/widgets/circle_view.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class ListWorkingCarBefore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListWorkingCarBefore();
  }
}

class _ListWorkingCarBefore extends State<ListWorkingCarBefore> {

  bool _isLoading = true;
  double initial, distance;
  int _indexTab = 0;
  String name, id_user, id_dealer, _typePekerjaan;
  HistoryCarWorkingModels _carWorkingModels;

  List listWorkingQuery = List();
  List listWorking = List();

  Icon actionIcon = new Icon(
    Icons.search,
    color: colorTitle(),
  );

  final TextEditingController _searchQuery = new TextEditingController();
  bool _IsSearching = false;

  final ButtonWidgetLoadController _btnAccept = new ButtonWidgetLoadController();
  final ButtonWidgetLoadController _btnEdit = new ButtonWidgetLoadController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    // TODO: implement initState
    super.initState();
    new Timer(const Duration(milliseconds: 150), ()
    {
      initView();
    });
  }

  Widget appBarTitle = TextWidget(
      txt: "History Car Working", color: Colors.white, txtSize: 18,);

  @override
  void dispose() {
    super.dispose();
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: colorTitle(),
      );
      this.appBarTitle = TextWidget(
        txt: "History Car Working",
        color: Colors.white,
        txtSize: 18,
      );
      _IsSearching = false;
      _searchQuery.clear();

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
                      centerTitle: true,
                      brightness: Brightness.light,
                      iconTheme: IconThemeData(color:Colors.white),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: appBarTitle,
                      actions: <Widget>[
                        IconButton(
                          onPressed: () {
                          setState(() {
                            if (this.actionIcon.icon == Icons.search) {
                              _IsSearching = true;
                              this.actionIcon = new Icon(
                                Icons.close,
                                color: Colors.white,
                              );

                              this.appBarTitle = new TextField(
                                  onChanged: (text) {
                                    setState(() {

                                      switch(_indexTab) {
                                        case 0 : {
                                          return _data(context ,'0', text.toUpperCase());
                                          break;
                                        }
                                        case 1 : {
                                          return _data(context ,'1', text.toUpperCase());
                                          break;
                                        }
                                        case 2 : {
                                          return _data(context ,'2', text.toUpperCase());
                                          break;
                                        }
                                      }
                                      // _carWorkingModels.data.where((dataWorking) =>
                                      //     dataWorking.nopol
                                      //         .toLowerCase()
                                      //         .contains(text.toLowerCase()))
                                      //     .toList();
                                    });
                                  },
                                  controller: _searchQuery,
                                  style: new TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: new InputDecoration(
                                            hintText: "Search...",
                                            hintStyle: new TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            MediaQuery.of(context).size.width / 30),
                                  ),
                              );
                            } else {
                              _handleSearchEnd();
                            }
                          });
                        }, icon: actionIcon,)
                      ],
                    )
                  )
                ),
                backgroundColor: Colors.transparent,
                body: ProgressDialog(
                  inAsyncCall: _isLoading,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      initView();
                    },
                    child: GestureDetector(
                      onPanStart: (DragStartDetails details) {
                        initial = details.globalPosition.dx;
                      },
                      onPanUpdate: (DragUpdateDetails details) {
                        distance = details.globalPosition.dx - initial;
                      },
                      onPanEnd: (DragEndDetails details) {
                        initial = 0.0;
                        if (distance > 0) {
                          setState(() {
                            _indexTab = (_indexTab == 0) ? 0 : _indexTab - 1;
                          });
                        } else {
                          setState(() {
                            _indexTab = (_indexTab == 3) ? 3 : _indexTab + 1;
                          });
                        }
                      },
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            _myTab(context),
                            SizedBox(height: 10),
                            body(context),
                          ],
                        ),
                      )
                    ),
                  )
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return Material(
                            type: MaterialType.transparency,
                            child: Container(
                              child: Container(
                                decoration : new BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [CorpToyogaColor, CorpToyogaColor2],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(30.0),
                                    topRight: const Radius.circular(30.0),
                                  ),
                                ),
                                child: Container(
                                    child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget> [
                                                  Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget> [
                                                        TextWidget(
                                                          txt: "Type Pekerjaan",
                                                          txtSize: MediaQuery.of(context).size.width / 20,
                                                          color: colorWhite
                                                        ),
                                                        Container(
                                                          width: 30,
                                                          height: 2,
                                                          alignment: Alignment.topRight,
                                                          color: colorWhite,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 35,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: colorWhite,
                                                      ),
                                                      color: Colors.transparent,
                                                    ),
                                                    child: new IconButton(
                                                        onPressed: (){
                                                          Navigator.of(context, rootNavigator: true).pop();
                                                        },
                                                        icon: Icon(
                                                          Icons.close,
                                                          size : 15.0,
                                                          color: Colors.white
                                                        ))
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            Container(
                                              width: double.infinity,
                                              height: 50,
                                              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                              decoration: BoxDecoration(
                                                color: colorWhite,
                                                borderRadius: new BorderRadius.all(
                                                  const Radius.circular(30.0),
                                                ),
                                              ),
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  hint: Text("Type Pekerjaan"),
                                                  isExpanded: true,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _typePekerjaan = newValue;
                                                    });
                                                  },
                                                  value: _typePekerjaan,
                                                  items:<String>['Air Conditioner','Engine Care'].map((String value) {
                                                    return DropdownMenuItem(child: Text(value), value: value);
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            Container(
                                              width: double.infinity,
                                              height: 50,
                                              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: colorWhite,
                                                borderRadius: new BorderRadius.all(
                                                    const Radius.circular(30.0)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 4,
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          _reset(context);
                                                          Navigator.of(context,
                                                              rootNavigator: true)
                                                              .pop();
                                                        },
                                                        child: TextWidget(
                                                          align: TextAlign.center,
                                                          txt: "Batal",
                                                          txtSize: 15,
                                                          color: Colors.red,
                                                          weight: FontWeight.bold,
                                                        )),
                                                  ),
                                                  Expanded(
                                                      flex: 2,
                                                      child: TextWidget(
                                                        txt: "|",
                                                        txtSize: 15,
                                                        color: colorBlack,
                                                        weight: FontWeight.bold,
                                                      )),
                                                  Expanded(
                                                      flex: 4,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if(_typePekerjaan == null) {
                                                            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Pilih type pekerjaan")));
                                                            return;
                                                          }

                                                          if(_typePekerjaan == "Air Conditioner") {
                                                            print(_typePekerjaan);
                                                            routeToWidget(context, CarWorkingBeforePage());
                                                          } else if(_typePekerjaan == "Engine Care") {
                                                            routeToWidget(context, CarWorkingEcBeforePage());
                                                          }
                                                          // Navigator.of(context,
                                                          //     rootNavigator: true)
                                                          //     .pop();
                                                        },
                                                        child: TextWidget(
                                                          txt: "Lanjut",
                                                          txtSize: 15,
                                                          color: colorBlack,
                                                          weight: FontWeight.bold,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 20),
                                            // ),
                                          ],
                                        )
                                    )
                                )
                              ),
                            )
                          );
                        });
                      }
                    );
                  },
                  backgroundColor: CorpToyogaColor,
                  child: const Icon(Icons.add),
                ),
              )
            ],
        ),
    );
  }

  Widget body(BuildContext context) {
    switch(_indexTab) {
      case 0 : {
        return _data(context ,'0', _searchQuery.text);
        break;
      }
      case 1 : {
        return _data(context ,'1',_searchQuery.text);
        break;
      }
      case 2 : {
        return _data(context ,'2',_searchQuery.text);
        break;
      }
      case 3 : {
        return _data(context ,'3',_searchQuery.text);
        break;
      }
    }
  }

  Widget _data(BuildContext context, String status, String query) {
    print("data status $status");

    return Expanded(
      child: _carWorkingModels.toString() != 'null' ?
      Container(
        child: _carWorkingModels.data.toString() != 'null' ?
                _carWorkingModels.data.where((data) => data.status == status && data.nopol.toUpperCase().contains(query)).length > 0  ?
        ListView(
            scrollDirection: Axis.vertical,
            children: status != "3" ? _carWorkingModels.data
                .where((data) => data.status == status && data.nopol.toUpperCase().contains(query))
                .map((data) => createList(data, context, ""))
                .toList() : _carWorkingModels.data
                .where((data) =>  {"0", "1" , "3"}.contains(data.status) && data.nopol.toUpperCase().contains(query))
                .map((data) => createList(data, context, "direct")).toList()
        ) : ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: dataNotFound(context),
            )
          ],
        ) : ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: dataNotFound(context),
            )
          ],
        ),
      ) : Container(
        height: MediaQuery.of(context).size.height / 2,
        child: dataNotFound(context),
      ),
    );
  }

  Widget createList(data, BuildContext context, String condition) {
    return GestureDetector(
      onTap: () {
        if(data.status == "1") {
          if(condition == "") {
            if(data.type_working == "Engine Care") {
              routeToWidget(context, CarWorkingEcAfterPage(idUniq : data.id_uniq));
            } else {
              routeToWidget(context, CarWorkingAfter(idUniq : data.id_uniq));
            }
          } else {
            routeToWidget(context, DetailWorkingCar(id_uniq : data.id_uniq, condition : condition));
          }
        } else if(data.status == "0" || data.status == "3") {
          routeToWidget(context, DetailWorkingCar(id_uniq : data.id_uniq, condition : condition));
        }  else if(data.status == "2") {
          routeToWidget(context, DetailWorkingCarDone(id_uniq : data.id_uniq));
        }


      },
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget> [
            Card(
              elevation : 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.white,
                child: Container(
                  height: MediaQuery.of(context).size.width / 3.5,
                  width: MediaQuery.of(context).size.width * (3 / 10),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextWidget(
                          txt: "Tanggal",
                          txtSize: 6.5,
                          weight: FontWeight.bold),
                      SizedBox(height: 5),
                      TextWidget(
                          txt: data.input_date,
                          txtSize: 9.5,
                          weight: FontWeight.bold),
                      SizedBox(height: 5),
                      Container(
                          width: 25,
                          height: 1,
                          alignment: Alignment.topRight,
                          color: colorBlack),
                      SizedBox(height: 5),
                      TextWidget(
                          txt: "Tipe Pekerjaan",
                          txtSize: 6.5,
                          weight: FontWeight.bold),
                      SizedBox(height: 5),
                      TextWidget(
                          txt: data.type_working != "" ? data.type_working : "-",
                          txtSize: 9.5,
                          weight: FontWeight.bold),
                    ],
                  ),
                )
            ),
            Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: colorWhite,
                child: Container(
                  height: MediaQuery.of(context).size.width / 3.5,
                  width: MediaQuery.of(context).size.width * (6 / 10),
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextWidget(
                        txt: "Status",
                        txtSize: 12,
                        color: colorBlack,
                        align: TextAlign.left,
                      ),
                      TextWidget(
                        txt: _textStatus(int.parse(data.status)) ,
                        txtSize: 12,
                        color:
                        _indexTab == 0 ? CorpToyogaColor : CorpToyogaColor2,
                        align: TextAlign.right,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(height: 10),
                      TextWidget(
                        txt: "Nomor Polisi",
                        txtSize: 12,
                        color: colorBlack,
                        align: TextAlign.left,
                      ),
                      TextWidget(
                        txt: data.nopol,
                        txtSize: 12,
                        color:
                        _indexTab == 0 ? CorpToyogaColor : CorpToyogaColor2,
                        align: TextAlign.right,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(height: 10),
                      TextWidget(
                        txt: "Model Mobil",
                        txtSize: 12,
                        color: colorBlack,
                        align: TextAlign.left,
                      ),
                      TextWidget(
                        txt: data.model,
                        txtSize: 12,
                        color:
                          _indexTab == 0 ? CorpToyogaColor : CorpToyogaColor2,
                        align: TextAlign.right,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                )
            ),
          ],
        )
      ),
    );
  }


  Widget _myTab(BuildContext context) {
    return Row(
      crossAxisAlignment:  CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap : () {
              setState(() {
                _indexTab = 0;
              });
            },
            child: TextWidget(
              txt: "Before",
              txtSize: _indexTab == 0 ? 15 : 13,
              color: Colors.white,
              weight:  _indexTab == 0 ? FontWeight.bold: null
            )
          )
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                _indexTab = 1;
              });
            },
            child: TextWidget(
                txt: "After",
                txtSize: _indexTab == 1 ? 15 : 13,
                color: Colors.white,
                weight:  _indexTab == 1 ? FontWeight.bold: null
            )
          )
        ),
        Expanded(
            child: InkWell(
                onTap: () {
                  setState(() {
                    _indexTab = 2;
                  });
                },
                child: TextWidget(
                    txt: "After (Done)",
                    txtSize: _indexTab == 2 ? 15 : 13,
                    color: Colors.white,
                    weight:  _indexTab == 2 ? FontWeight.bold: null
                )
            )
        ),
        Expanded(
            child: InkWell(
                onTap: () {
                  setState(() {
                    _indexTab = 3;
                  });
                },
                child: TextWidget(
                    txt: "Before List",
                    txtSize: _indexTab == 3 ? 15 : 13,
                    color: Colors.white,
                    weight:  _indexTab == 3 ? FontWeight.bold: null
                )
            )
        )
      ],
    );
  }

  String _textStatus(int dataStatus) {
    switch(dataStatus) {
      case 0 : {
        return "Before";
        break;
      }
      case 1 : {
        return "After";
        break;
      }
      case 2 : {
        return "After (Done)";
        break;
      }
      case 3 : {
        return "Before List";
        break;
      }
    }
  }

  initView(){
    SharedPreferencesHelper.getDoLogin().then((value)  {
      final member = MemberModels.fromJson(json.decode(value));
      _setListData(member.data.id_user);
    });

  }

  _reset(BuildContext context) {
    setState(() {
      _typePekerjaan = null;
    });
  }

  _setListData(String userId) {
    ReqHistoryCarWorking params = ReqHistoryCarWorking(
        id_user: userId,
        method: "list"
    );

    print(userId);

    bloc.getsHistoryCarWorking({"id_user": userId, "method" : "list"}, (model) async {
       _setData(model);
    });
  }

  _setData(HistoryCarWorkingModels models)  {
    setState(() {
      _carWorkingModels = models;
      _isLoading = false;
    });
  }

}