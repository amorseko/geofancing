import 'dart:convert';

import 'package:geofancing/src/models/members_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:rxdart/rxdart.dart';

class DoLoginBloc {
  final _repository = Repository();
  final _doLogin = PublishSubject<MemberModels>();

//  Observable<MemberModels> get doRegistration =>
//      _doRegistrationFetch.stream;

  fetchDoLogin(Map<String, dynamic> body, Function callback) async {
    print(body);
    MemberModels model = await _repository.actLogin(body: body);
    if (model.data != null) {
//      print(model.data.password);
      SharedPreferencesHelper.setDoLogin(json.encode(model.toJson()));
//      SharedPreferencesHelper.setToken(model.token);
    }
    callback(model.status, model.message, model.code);
  }

  dispose() {
    _doLogin.close();
  }
}

final bloc = DoLoginBloc();
