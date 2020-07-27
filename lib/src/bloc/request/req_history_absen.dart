class ReqHistoryAbsen {
  final String id_pegawai;
  final String tanggal;

  ReqHistoryAbsen({this.id_pegawai, this.tanggal});

  factory ReqHistoryAbsen.fromJson(Map<String, dynamic> json) {
    return ReqHistoryAbsen(
        id_pegawai: json['id_pegawai'],
        tanggal : json['tanggal'],

    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id_pegawai"] = id_pegawai;
    map['tanggal'] = tanggal;
    return map;
  }
}
