class reqJarak {
  final String app_id;

  reqJarak({this.app_id});

  factory reqJarak.fromJson(Map<String, dynamic> json) {
    return reqJarak(
      app_id: json['app_id'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["app_id"] = app_id;
    return map;
  }
}
