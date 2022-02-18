class reqListBarangDetailItems {
  final String id_permintaan_barang;

  reqListBarangDetailItems({this.id_permintaan_barang});

  factory reqListBarangDetailItems.fromJson(Map<String, dynamic> json) {
    return reqListBarangDetailItems(
      id_permintaan_barang: json['id_permintaan_barang'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id_permintaan_barang"] = id_permintaan_barang;
    return map;
  }
}