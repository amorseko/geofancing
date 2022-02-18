import 'package:dio/dio.dart';
import 'package:geofancing/src/models/history_pekerjaan.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class HistoryPekerjaanBloc {
  final _repository = Repository();
  final _getHistoryPekerjaan = PublishSubject<HistoryPekerjaanModels>();

  Stream<HistoryPekerjaanModels> get getHistoryAbsen =>
      _getHistoryPekerjaan.stream;

  getHistoryPekerjaan(Map<String, dynamic> body, Function callback) async {
    HistoryPekerjaanModels model =
        await _repository.HistoryPekerjaan(body: body);
    _getHistoryPekerjaan.sink.add(model);
    callback(model.status, model.error, model.message, model);
  }

  dispose() {
    _getHistoryPekerjaan.close();
  }
}

final bloc = HistoryPekerjaanBloc();
