import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    // TODO: implement initState
    super.initState();

    initView();
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
      child: Container(
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
                _indexTab = 0;
              });
            },
            child: TextWidget(
                txt: "Post Checking",
                txtSize: _indexTab == 0 ? 15 : 13,
                color: Colors.white,
                weight:  _indexTab == 0 ? FontWeight.bold: null
            )
          )
        )
      ],
    );
  }

  initView() {

    SharedPreferencesHelper.getDoLogin().then((value) {
      final member = MemberModels.fromJson(json.decode(value));
      setState(() {
        name = member.data.nama_user;
        id_user = member.data.id_user;
        id_dealer = member.data.id_dealer;
      });
    });

    setState(() {
      _isLoading = false;
    });

  }


}