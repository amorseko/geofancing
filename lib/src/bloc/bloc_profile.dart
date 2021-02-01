import 'dart:convert';

import 'package:geofancing/src/models/profile_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:geofancing/src/utility/SharedPreferences.dart';
import 'package:rxdart/rxdart.dart';

class DoProfileBloc {
  final _repository = Repository();
  final _doProfile = PublishSubject<ProfileModels>();

//  Observable<MemberModels> get doRegistration =>
//      _doRegistrationFetch.stream;
  Stream<ProfileModels> get getListProfileBloc => _doProfile.stream;
  fetchProfile(Map<String, dynamic> body, Function callback) async {
    print(body);
    ProfileModels model = await _repository.fetchProfile(body: body);
    _doProfile.sink.add(model);
    callback(model.status, model.message, model.code, model);
  }

  dispose() {
    _doProfile.close();
  }
}

//final bloc = DoProfileBloc();
