class ReqHistoryCarWorking {
  final String id_user;
  final String method;

  ReqHistoryCarWorking({this.id_user, this.method});

  factory ReqHistoryCarWorking.fromJson(Map<String, dynamic> json) {
    return ReqHistoryCarWorking(
      id_user: json['id_user'],
      method: json['method'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id_user"] = id_user;
    map["method"] = method;
    return map;
  }
}