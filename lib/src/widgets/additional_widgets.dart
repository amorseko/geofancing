import 'dart:io';
import 'package:geofancing/src/utility/allTranslations.dart';
import 'package:geofancing/src/utility/utils.dart';
import 'package:geofancing/src/widgets/TextWidget.dart';
import 'package:geofancing/src/utility/Colors.dart';
// import 'package:geofancing/src/ui/main_menu/claim_rembursment/detail_pengajuan.dart';
// import 'package:brilife/src/ui/main_menu/claim_rembursment/status_pengajuan/detail_statuspengajuan.dart';
// import 'package:brilife/utility/allTranslations.dart';
// import 'package:brilife/utility/utils.dart';
// import 'package:brilife/widgets/DividerWidget.dart';
import 'package:flutter/material.dart';
// import 'package:brilife/utility/colors.dart';
// import 'package:brilife/widgets/TextWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
final currancy = new NumberFormat("#,##0", "en_US");

Widget leadingBack (BuildContext context){
  return IconButton(
    icon: Icon(Icons.arrow_back,color: Colors.white,size: MediaQuery.of(context).size.width/20),
    onPressed: (){
      Navigator.of(context).pop();
    },
  );
}
void showImage(BuildContext context, String image, String title,bool internal){
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return Material(
                type: MaterialType.transparency,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    decoration: new BoxDecoration(
                        color: Colors.black,
                        gradient: LinearGradient(colors: [Colors.white, Colors.grey],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )),
                    child: Scaffold(
                      backgroundColor: Colors.black,
                      appBar: PreferredSize(
                        preferredSize: Size.fromHeight(90.0),
                        child: Container(
                          color: Colors.black,
                          padding: EdgeInsets.only(top: 30,left: 10,right: 10),
                          child: AppBar(
                            brightness: Brightness.light,
                            iconTheme: IconThemeData(color: colorTitle()),
//        title: TextWidget(txt: widget.title, color: colorTitle()),
                            backgroundColor: Colors.black,
                            elevation: 0,
                          ),
                        ),
                      ),
                      body: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            new Container(
                                decoration: BoxDecoration(
                                    color: Colors.black
                                )
                            ),
                            PhotoView(imageProvider: internal==true?FileImage(File(image)):CachedNetworkImageProvider(image)),
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    color: Colors.black26,
                                    child: TextWidget(txtSize: 12,txt: 'Foto : '+title,color: Colors.white,),
                                  ),
                                )
                            )
                          ]
                      ),
                    ),
                  ),
                ),
              );
            });
      });
}
void showListImage(BuildContext context, List image,List title){
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return Material(
                  type: MaterialType.transparency,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.grey[200],
                    child: Stack(
                      children: <Widget>[
                        ClipPath(
                          clipper: OvalBottomBorderClipper(),
                          child: Container(
                            height: MediaQuery.of(context).size.height/3,
                            color: CorpToyogaColor,
                          ),
                        ),
                        Scaffold(
                          appBar: PreferredSize(
                            preferredSize: Size.fromHeight(100.0),
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.only(top: 30,left: 20,right: 20),
                              child: AppBar(
                                brightness: Brightness.light,
                                iconTheme: IconThemeData(color: colorTitle()),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                title: TextWidget(txt: "Detail Image", color: colorTitle()),
                              ),
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                          body: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: image.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  crossAxisCount:  1),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: (){
                                    showImage(context, image[index],title[index],false);
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: image[index],
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              );
            });
      });
}
// Widget createList(data,BuildContext context){
//   Color background = data.status=='0'?colorWhite
//       :data.status=='1'?colorWhite
//       :data.status=='2'?CorpToyogaColor
//       :data.status=='3'?CorpToyogaColor
//       :data.status=='4' || data.status=='5'?CorpToyogaColor
//       :data.status=='6' || data.status=='7' || data.status=='8'?colorWhite
//       :colorWhite;
//   Color titleText = data.status=='0'?colorBlack
//       :data.status=='1'?colorBlack
//       :data.status=='2'?colorWhite
//       :data.status=='3'?colorWhite
//       :data.status=='4' || data.status=='5'?colorWhite
//       :data.status=='6' || data.status=='7' || data.status=='8'?colorBlack
//       :colorBlack;
//   Color dataText = data.status=='0'?CorpToyogaColor
//       :data.status=='1'?CorpToyogaColor
//       :data.status=='2'?colorWhite
//       :data.status=='3'?colorWhite
//       :data.status=='4' || data.status=='5'?colorWhite
//       :data.status=='6' || data.status=='7' || data.status=='8'?CorpToyogaColor
//       :CorpToyogaColor;
//   if(data.status=='4' || data.status=='5' || data.status=='6' || data.status=='7' || data.status=='8'){
//     return GestureDetector(
//       onTap: (){
//         routeToWidget(context, DetailPengajuan(request_id: data.request_id));
//       },
//       child: Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           color:background,
//           child:Column(
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.all(15),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         TextWidget(
//                           txt: allTranslations.text("txt_no_submission"),
//                           txtSize: 12,
//                           color: titleText,
//                           align: TextAlign.left,
//                         ),
//                         TextWidget(
//                           txt: data.request_id,
//                           txtSize: 12,
//                           color: dataText,
//                           align: TextAlign.right,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Container(
//                       child: data.claims_id!=null?Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           TextWidget(
//                             txt: 'Claim ID',
//                             txtSize: 12,
//                             color: titleText,
//                             align: TextAlign.left,
//                           ),
//                           TextWidget(
//                             txt: data.claims_id,
//                             txtSize: 12,
//                             color: dataText,
//                             align: TextAlign.right,
//                           ),
//                         ],
//                       ):null,
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         TextWidget(
//                           txt: allTranslations.text("txt_status_submission"),
//                           txtSize: 12,
//                           color: titleText,
//                           align: TextAlign.left,
//                         ),
//                         TextWidget(
//                           txt: statusCode(int.parse(data.status)),
//                           txtSize: 12,
//                           color: dataText,
//                           align: TextAlign.right,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         TextWidget(
//                           txt: 'Nama Rumah Sakit',
//                           txtSize: 12,
//                           color: titleText,
//                           align: TextAlign.left,
//                         ),
//                         TextWidget(
//                           txt: data.provider_name,
//                           txtSize: 12,
//                           color: dataText,
//                           align: TextAlign.right,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         TextWidget(
//                           txt: allTranslations.text("txt_dateentry"),
//                           txtSize: 12,
//                           color: titleText,
//                           align: TextAlign.left,
//                         ),
//                         TextWidget(
//                           txt: data.admission_date,
//                           txtSize: 12,
//                           color: dataText,
//                           align: TextAlign.right,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         TextWidget(
//                           txt: allTranslations.text("txt_outdate"),
//                           txtSize: 12,
//                           color: titleText,
//                           align: TextAlign.left,
//                         ),
//                         TextWidget(
//                           txt: data.discharge_date,
//                           txtSize: 12,
//                           color: dataText,
//                           align: TextAlign.right,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         TextWidget(
//                           txt: allTranslations.text("txt_hospital_inv_number"),
//                           txtSize: 12,
//                           color: titleText,
//                           align: TextAlign.left,
//                         ),
//                         TextWidget(
//                           txt: data.hosp_inv_no,
//                           txtSize: 12,
//                           color: dataText,
//                           align: TextAlign.right,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         TextWidget(
//                           txt: allTranslations.text("txt_hospital_date"),
//                           txtSize: 12,
//                           color: titleText,
//                           align: TextAlign.left,
//                         ),
//                         TextWidget(
//                           txt: data.hosp_inv_date,
//                           txtSize: 12,
//                           color: dataText,
//                           align: TextAlign.right,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         TextWidget(
//                           txt: allTranslations.text("txt_plancode"),
//                           txtSize: 12,
//                           color: titleText,
//                           align: TextAlign.left,
//                         ),
//                         TextWidget(
//                           txt: data.plan_id,
//                           txtSize: 12,
//                           color: dataText,
//                           align: TextAlign.right,
//                         ),
//                       ],
//                     ),
//                     Divider(),
//                     TextWidget(
//                       txt: allTranslations.text("txt_diagnosis"),
//                       txtSize: 12,
//                       color: titleText,
//                       align: TextAlign.left,
//                     ),
//                     TextWidget(
//                       txt: data.diagnosis,
//                       txtSize: 12,
//                       maxLine: 5,
//                       color: dataText,
//                       weight: FontWeight.bold,
//                       align: TextAlign.left,
//                     ),
//                     Container(
//                       child: data.status=='4' || data.status=='5'?Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Divider(),
//                           TextWidget(
//                             txt: 'Remarks:',
//                             txtSize: 12,
//                             color: colorWhite,
//                             align: TextAlign.left,
//                           ),
//                           TextWidget(
//                             txt: data.remarks,
//                             txtSize: 12,
//                             color: colorWhite,
//                             weight: FontWeight.bold,
//                             align: TextAlign.left,
//                           )
//                         ],
//                       ):null,
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 child: data.claims_id!=null?Container(
//                   padding: EdgeInsets.all(15),
//                   color: Colors.grey[200],
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             TextWidget(txt: allTranslations.text("txt_totalsubmission"), txtSize: 12, color: colorBlack,weight: FontWeight.bold),
//                             TextWidget(
//                               //              txt: snapshot.data.data[index].remarks,
//                               txt: "Rp. "+currancy.format(int.parse(data.incurred)),
//                               align: TextAlign.left,
//                               txtSize: 10,
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             TextWidget(txt: allTranslations.text("txt_approved"), txtSize: 12, color: colorBlack,weight: FontWeight.bold),
//                             TextWidget(
//                               //              txt: snapshot.data.data[index].remarks,
//                               txt: "Rp. "+currancy.format(int.parse(data.approved)),
//                               align: TextAlign.left,
//                               txtSize: 10,
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             TextWidget(txt: allTranslations.text("txt_notapproved"), txtSize: 12, color: colorBlack,weight: FontWeight.bold),
//                             TextWidget(
//                               //              txt: snapshot.data.data[index].remarks,
//                               txt: "Rp. "+currancy.format(int.parse(data.not_approved)),
//                               align: TextAlign.left,
//                               txtSize: 10,
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ):null,
//               )
//             ],
//           )
//       ),
//     );
//   }else{
//     return GestureDetector(
//       onTap: (){
//         if(data.status=='2'){
//           routeToWidget(context, DetailStatusPengajuan(request_id:data.request_id));
//         }else{
//           routeToWidget(context, DetailPengajuan(request_id: data.request_id));
//         }
//       },
//       child: Card(
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           color: background,
//           child:Padding(
//             padding: EdgeInsets.all(15),
//             child:  Column(
//               children: <Widget>[
//                 Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           TextWidget(
//                             txt: allTranslations.text("txt_status_submission"),
//                             txtSize: 12,
//                             color: titleText,
//                             align: TextAlign.left,
//                           ),
//                           TextWidget(
//                             txt: statusCode(int.parse(data.status)),
//                             txtSize: 12,
//                             color: dataText,
//                             align: TextAlign.right,
//                             weight: FontWeight.bold,
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           TextWidget(
//                             txt: allTranslations.text("txt_no_submission"),
//                             txtSize: 12,
//                             color: titleText,
//                             align: TextAlign.left,
//                           ),
//                           TextWidget(
//                             txt: data.request_id,
//                             txtSize: 12,
//                             color: dataText,
//                             align: TextAlign.right,
//                             weight: FontWeight.bold,
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           TextWidget(
//                             txt: allTranslations.text("txt_hospital_inv_number"),
//                             txtSize: 12,
//                             color: titleText,
//                             align: TextAlign.left,
//                           ),
//                           TextWidget(
//                             txt: data.hosp_inv_no,
//                             txtSize: 12,
//                             color: dataText,
//                             align: TextAlign.right,
//                             weight: FontWeight.bold,
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           TextWidget(
//                             txt: allTranslations.text("txt_date_submission"),
//                             txtSize: 12,
//                             color: titleText,
//                             align: TextAlign.left,
//                           ),
//                           TextWidget(
//                             txt: data.request_time,
//                             txtSize: 12,
//                             color: dataText,
//                             align: TextAlign.right,
//                             weight: FontWeight.bold,
//                           ),
//                         ],
//                       ),
//                       Container(
//                         child: data.status=='2'?Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             DividerWidget(height: 0.5),
//                             TextWidget(
//                               txt: 'Remarks:',
//                               txtSize: 12,
//                               color: colorWhite,
//                               align: TextAlign.left,
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             TextWidget(
//                               txt: data.remarks,
//                               txtSize: 12,
//                               color: colorWhite,
//                               weight: FontWeight.bold,
//                               align: TextAlign.left,
//                             )
//                           ],
//                         ):null,
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )
//       ),
//     );
//   }
// }