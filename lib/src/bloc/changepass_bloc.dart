import 'package:geofancing/src/models/standart_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ChangePassBloc {
  final _repository = Repository();
  final _changePassword = PublishSubject<StandartModels>();

  actForgotPass(Map<String, dynamic> body, Function callback) async {
    StandartModels model = await _repository.actChangePassUser(body: body);
    callback(model.status, model.message);
  }

  dispose() {
    _changePassword.close();
  }
}

final bloc = ChangePassBloc();
