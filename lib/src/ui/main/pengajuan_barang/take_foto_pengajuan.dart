import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/utility/Colors.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/widgets/ProgressDialog.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/ui/main/pengajuan_barang/submit_pengajuan.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TakeFotoPengajuan extends StatefulWidget {
  String idBarang;
  String idJenisBarang;
  String tglTransaksi;
  String KondisiBarang;
  @override
  _TakeFotoPengajuan createState() => _TakeFotoPengajuan();
  TakeFotoPengajuan({this.idBarang, this.idJenisBarang, this.tglTransaksi, this.KondisiBarang});
}

class _TakeFotoPengajuan extends State<TakeFotoPengajuan> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  var ImagePath;
  String id_user;

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
//    final firstCamera = cameras.last;
    final firstCamera = cameras[1];
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  initData() {
    SharedPreferencesHelper.getDoLogin().then((value) {
      final user = MemberModels.fromJson(json.decode(value));
      setState(() {
        id_user = user.data.id_user;
      });
    });

    print(widget.tglTransaksi);
  }

  void onCaptureButtonPressed(BuildContext context) async {
    //on camera button press
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('y-MM-d_kk-mm-ss').format(now);

      final path = join(
        (await getTemporaryDirectory()).path, //Temporary path
        formattedDate + '_' + id_user + '.png',
      );
      ImagePath = path;
      await _controller.takePicture(path); //take photo

      routeToWidget(
          context,
          SubmitPengajuanPage(
            imagePath: ImagePath,
            idBarang: widget.idBarang,
            idJenisBarang: widget.idJenisBarang,
            tglTransaksi: widget.tglTransaksi,
              KondisiBarang:widget.KondisiBarang
          ));

      setState(() {
        showCapturedPhoto = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initializeCamera();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      appBar: AppBar(
//          automaticallyImplyLeading: false,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text("", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: CorpToyogaColor),
      body: Stack(
        children: <Widget>[
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return Transform.scale(
                    scale: _controller.value.aspectRatio / deviceRatio,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: CameraPreview(_controller), //cameraPreview
                      ),
                    ));
              } else {
                return Center(
                    child:
                        CircularProgressIndicator()); // Otherwise, display a loading indicator.
              }
            },
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 100),
                child: MaterialButton(
                  onPressed: () {
                    onCaptureButtonPressed(context);
                  },
                  color: CorpToyogaColor,
                  textColor: Colors.white,
                  child: Icon(
                    Icons.camera_alt,
                    size: 36,
                  ),
                  padding: EdgeInsets.all(16),
                  shape: CircleBorder(),
                ),
              ))
        ],
      ),
    );
  }
}
