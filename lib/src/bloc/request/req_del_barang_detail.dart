class reqDelBarangDetail {
  final String id_dpb;

  reqDelBarangDetail({this.id_dpb});

  factory reqDelBarangDetail.fromJson(Map<String, dynamic> json) {
    return reqDelBarangDetail(
      id_dpb: json['id_dpb'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id_dpb"] = id_dpb;
    return map;
  }
}