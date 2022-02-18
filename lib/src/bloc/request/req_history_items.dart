class ReqHistoryItems {
  final String id_user;

  ReqHistoryItems({this.id_user});

  factory ReqHistoryItems.fromJson(Map<String, dynamic> json) {
    return ReqHistoryItems(
      id_user: json['id_user'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id_user"] = id_user;
    return map;
  }
}