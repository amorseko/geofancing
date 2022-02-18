import 'package:geofancing/src/models/standart_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class delBarangDetailBloc{
  final _repository = Repository();
  final _doDelBarangDetailBloc = PublishSubject<StandartModels>();

  actDelBarangDetail(Map<String, dynamic> body, Function callback) async {
    StandartModels model = await _repository.fetchDelBarangDetail(body: body);
    callback(model.status, model.message);
  }

  dispose() {
    _doDelBarangDetailBloc.close();
  }
}

final bloc = delBarangDetailBloc();