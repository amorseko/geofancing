class ReqHistoryAbsen {
  final String id_pegawai;

  ReqHistoryAbsen({this.id_pegawai});

  factory ReqHistoryAbsen.fromJson(Map<String, dynamic> json) {
    return ReqHistoryAbsen(
        id_pegawai: json['id_pegawai'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id_pegawai"] = id_pegawai;
    return map;
  }
}
