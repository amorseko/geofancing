class reqBarang {
  final String id_jenis_part;

  reqBarang({this.id_jenis_part});

  factory reqBarang.fromJson(Map<String, dynamic> json) {
    return reqBarang(
      id_jenis_part: json['id_jenis_part'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id_jenis_part"] = id_jenis_part;
    return map;
  }
}
