import 'package:geofancing/src/models/standart_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ChangeStatusWorkingBloc {
  final _repository = Repository();
  final _changeStatusWorking = PublishSubject<StandartModels>();

  actChangeStatusWorking(Map<String, dynamic> body, Function callback) async {
    StandartModels model = await _repository.actChangeStatusWorkingCar(body: body);
    callback(model.status, model.message);
  }

  dispose() {
    _changeStatusWorking.close();
  }
}

final bloc = ChangeStatusWorkingBloc();