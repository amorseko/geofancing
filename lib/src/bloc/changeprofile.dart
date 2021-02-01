import 'package:geofancing/src/models/standart_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ChangeProfileBloc {
  final _repository = Repository();
  final _changeProfile = PublishSubject<StandartModels>();

  actProfile(Map<String, dynamic> body, Function callback) async {
    StandartModels model = await _repository.actChangeProfile(body: body);
    callback(model.status, model.message);
  }

  dispose() {
    _changeProfile.close();
  }
}

final bloc = ChangeProfileBloc();
