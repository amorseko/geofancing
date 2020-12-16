import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geofancing/src/bloc/request/req_history_items.dart';
import 'package:geofancing/src/models/history_pekerjaan.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/ui/main/pekerjaan/form_pekerjaan.dart';
import 'package:geofancing/src/ui/main/pekerjaan/form_pict_pekerjaan.dart';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/bloc/bloc_history_pekerjaan.dart';
import 'package:intl/intl.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:ntp/ntp.dart';

class PekerjaanPage extends StatefulWidget {
  @override
  _PekerjaanPageState createState() => _PekerjaanPageState();
}

class Constants {
  static const String FirstItem = 'First Item';
  static const String SecondItem = 'Second Item';
  static const String ThirdItem = 'Third Item';

  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
    ThirdItem,
  ];
}

class _PekerjaanPageState extends State<PekerjaanPage> {
  bool _isLoading = true;

  String name;

  List PekerjaanData = List<HistoryPekerjaanData>();

  initData() {
    SharedPreferencesHelper.getDoLogin().then((value) async {
      final members = MemberModels.fromJson(json.decode(value));
      setState(() {
        name = members.data.nama_user;
        //_isLoading = false;
      });

      ReqHistoryItems params = ReqHistoryItems(id_user: members.data.id_user);

      await bloc.getHistoryPekerjaan(params.toMap(),
          (status, error, message, model) {
        HistoryPekerjaanModels dataM = model;
        print(dataM.data.length);
        for (int i = 0; i < dataM.data.length; i++) {
          PekerjaanData.add(dataM.data.elementAt(i));
        }

        print(members.data.id_user);

        setState(() {
          _isLoading = false;
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
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(
              context, "/main_page", (_) => false);
           return false;
        },
        child: Scaffold(
            appBar: AppBar(
                brightness: Brightness.light,
                iconTheme: IconThemeData(color: Colors.white),
                title: Text(allTranslations.text("btn_pekerjaan"),
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
                        child: Column(children: <Widget>[
                          ClipOval(
                            child: Image.asset(
                              'assets/icons/icons_peserta.png',
                              fit: BoxFit.cover,
                              matchTextDirection: true,
                              height: 120,
                              width: 120,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            name != null ? name : " ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ]),
                      )),
                  Expanded(
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: PekerjaanData.length,
                            itemBuilder: (context, index) {
                              return pekerjaanList(
                                  index: index,
                                  pekerjaanData: PekerjaanData[index]);
                            },
                          )))
                ],
              ),
            ),
            floatingActionButton: Container(
              padding: EdgeInsets.only(bottom: 50.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    child: Icon(Icons.add, color: Colors.white),
                    backgroundColor: CorpToyogaColor,
                    onPressed: () {
                      // routeToWidget(context, FormPengajuanPage(id_barang: "",)).then((value) {
                      //   setPotrait();
                      // });
                      routeToWidget(context, FormPekerjaanPage());
                    },
                  )),
            )));
  }
}

class pekerjaanList extends StatelessWidget {
  final int index;
  final HistoryPekerjaanData pekerjaanData;

  const pekerjaanList({Key key, this.index, this.pekerjaanData});

  detectDate<String>(String callsign, void Function(int) callback) async {
    DateTime now = await NTP.now();
    // var dFormat = DateFormat('y-MM-d HH:mm').format(now);
    DateTime _tglInput = DateTime.parse(pekerjaanData.tgl_report);
    // var tFormat = DateFormat('y-MM-d HH:mm').format(_tglInput);
    print("${now.difference(_tglInput).inHours}");

    callback(now.difference(_tglInput).inHours);

    // var inHours = now.difference(_tglInput).inHours;
  }

  Widget build(BuildContext context) {
    PopupMenu.context = context;
    return GestureDetector(
      // onTapUp: (TapUpDetails details) {
      //   detectDate("", (value) {
      //     if (value < 24) {
      //       showPopup(details.globalPosition);
      //     }
      //   });
      // },
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
                      height: MediaQuery.of(context).size.width / 4,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            pekerjaanData.no_spk +
                                " - Tanggal : " +
                                pekerjaanData.tgl_report_formated,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              child: Container(
                                                child: Text(
                                                  "No. Polisi : " +
                                                      pekerjaanData.nopol,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ]),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: <Widget>[
                          //     IconButton(
                          //       icon: new Icon(
                          //         Icons.edit,
                          //         color: primaryColor,
                          //       ),
                          //       onPressed: () {

                          //         //                            print(index);
                          //         // routeToWidget(context, EditGapoktanPage(idGapoktan: gapoktanData.id_gapoktan,)).then((value) {
                          //         //   setPotrait();
                          //         // });
                          //       },
                          //     ),
                          //     IconButton(
                          //       icon: new Icon(
                          //         Icons.delete,
                          //         color: primaryColor,
                          //       ),
                          //       onPressed: () {
                          //         print(index);
                          //         // showMessage(context, onDelete,gapoktanData.id_gapoktan);
                          //         //showMessage(context, onDelete,barangListDetailData.id_dpb);
                          //         //                            this.onDelete();
                          //       },
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 50,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey))),
    );
  }

  void showPopup(Offset offset) {
    PopupMenu menu = PopupMenu(

        // backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        maxColumn: 2,
        items: [
          MenuItem(title: 'Edit', image: Icon(Icons.edit, color: Colors.white)),
          MenuItem(
              title: 'Edit Image',
              image: Icon(Icons.image, color: Colors.white)),
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    menu.show(rect: Rect.fromPoints(offset, offset));
  }

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  void onClickMenu(MenuItemProvider item) {
    if (item.menuTitle == "Edit") {
    } else if (item.menuTitle == "Edit Image") {
      Navigator.push(
        PopupMenu.context,
        MaterialPageRoute(
            builder: (context) => FormPictPekerjaanPage(
                  id_rmh: pekerjaanData.id_rmh,
                )),
      );

      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //         builder: (context) => FormPictPekerjaanPage(
      //               id_rmh: pekerjaanData.id_rmh,
      //             )),
      //     (Route<dynamic> route) => true);
    }

    print('Click menu -> ${item.menuTitle}');
  }

  void onDismiss() {
    print('Menu is dismiss');
  }
}
