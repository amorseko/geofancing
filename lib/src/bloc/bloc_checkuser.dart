import 'package:geofancing/src/models/standart_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ChangePassBloc {
  final _repository = Repository();
  final _CheckUser = PublishSubject<StandartModels>();

  actForgotPass(Map<String, dynamic> body, Function callback) async {
    StandartModels model = await _repository.actCheckUser(body: body);
    callback(model.status, model.message);
  }

  dispose() {
    _CheckUser.close();
  }
}

final bloc = ChangePassBloc();
