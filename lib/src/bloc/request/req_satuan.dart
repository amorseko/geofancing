class reqSatuan {
  final String id_satuan;

  reqSatuan({this.id_satuan});

  factory reqSatuan.fromJson(Map<String, dynamic> json) {
    return reqSatuan(
      id_satuan: json['id_satuan'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id_satuan"] = id_satuan;
    return map;
  }
}
