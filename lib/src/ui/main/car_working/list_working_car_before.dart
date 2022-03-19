import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:geofancing/src/bloc/request/req_history_car_working.dart';
import 'package:geofancing/src/models/history_pekerjaan.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/bloc/bloc_car_working.dart';
import 'package:geofancing/src/models/car_working_model.dart';
import 'package:intl/intl.dart';
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
  String name, id_user, id_dealer;

  HistoryCarWorkingModels _carWorkingModels;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    // TODO: implement initState
    super.initState();
    new Timer(const Duration(milliseconds: 100), ()
    {
      initView();
    });
  }

  @override
  void dispose() {
    super.dispose();
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
                      title: TextWidget(
                        txt: "History Car Working",
                        txtSize: 18,
                        color: Colors.white
                      ),
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
                            _indexTab = (_indexTab == 2) ? 2 : _indexTab + 1;
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
                )
              )
            ],
        ),
    );
  }

  Widget body(BuildContext context) {
    switch(_indexTab) {
      case 0 : {
        return _data(context ,'0');
        break;
      }
      case 1 : {
        return _data(context ,'1');
        break;
      }
    }
  }

  Widget _data(BuildContext context, String status) {
    return Expanded(
      child: _carWorkingModels.toString() != 'null' ?
      Container(
        child: _carWorkingModels.data.toString() != 'null' ? _carWorkingModels.data.where((data) => data.status == status).length > 0 ?
        ListView(
            scrollDirection: Axis.vertical,
            children: _carWorkingModels.data
                .where((data) => data.status == status)
                .map((data) => createList(data, context))
                .toList()
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

  Widget createList(data, BuildContext context) {
    return GestureDetector(
      onTap: () {

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
                          txt: data.request_time,
                          txtSize: 9.5,
                          weight: FontWeight.bold),
                      SizedBox(height: 5),
                      Container(
                          width: 25,
                          height: 1,
                          alignment: Alignment.topRight,
                          color: colorBlack)
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
              txt: "Pra Checking",
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
                txt: "Post Checking",
                txtSize: _indexTab == 1 ? 15 : 13,
                color: Colors.white,
                weight:  _indexTab == 1 ? FontWeight.bold: null
            )
          )
        )
      ],
    );
  }

  String _textStatus(int dataStatus) {
    switch(dataStatus) {
      case 0 : {
        return "Pre Checking";
        break;
      }
      case 1 : {
        return "Post Checking";
        break;
      }
    }
  }

  initView(){
    SharedPreferencesHelper.getDoLogin().then((value) async {
      final member = MemberModels.fromJson(json.decode(value));
      await _setListData(member.data.id_user);
    });

  }

  _setListData(String userId) {
    ReqHistoryCarWorking params = ReqHistoryCarWorking(
        id_user: userId,
        method: "list"
    );

    bloc.getsHistoryCarWorking(params.toMap(), (model) async {
      await _setData(model);
    });
  }

  _setData(HistoryCarWorkingModels models) async {
    setState(() {
      _carWorkingModels = models;
      _isLoading = false;
    });
  }

}