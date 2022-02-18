class ReqDoLogin {
  final String username;
  final String password;

  ReqDoLogin({this.username, this.password});

  factory ReqDoLogin.fromJson(Map<String, dynamic> json) {
    return ReqDoLogin(
      username: json['username'],
      password: json['password']
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    return map;
  }
}
