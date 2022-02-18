class ReqChangePass {
  final String password_old;
  final String password_new;
  final String id_user;

  ReqChangePass({this.password_old, this.password_new, this.id_user});

  factory ReqChangePass.fromJson(Map<String, dynamic> json) {
    return ReqChangePass(
      password_old: json['password_old'],
      password_new: json['password_new'],
      id_user: json['id_user'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["password_old"] = password_old;
    map["password_new"] = password_new;
    map["id_user"] = id_user;
    return map;
  }

}