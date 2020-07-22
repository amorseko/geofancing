import 'package:dio/dio.dart';
import 'package:geofancing/src/models/absen_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class AbsenTodayBloc {
  final _repository = Repository();
  final _getAbsenToday = PublishSubject<AbsenModels>();


  Stream<AbsenModels> get getAbsenToday => _getAbsenToday.stream;


  doGetTodayAbsen(Map<String, dynamic> body, Function callback) async {
    AbsenModels model = await _repository.getTodayAbsen(body: body);
    _getAbsenToday.sink.add(model);
    callback(model.status, model.error, model.message, model);
  }

  dispose() {
    _getAbsenToday.close();
  }

}

final bloc = AbsenTodayBloc();