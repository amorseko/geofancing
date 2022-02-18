import 'package:dio/dio.dart';
import 'package:geofancing/src/models/history_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class HistoryBloc {
  final _repository = Repository();
  final _getHistoryAbsen = PublishSubject<HistoryModels>();


  Stream<HistoryModels> get getHistoryAbsen => _getHistoryAbsen.stream;


  getHistory(Map<String, dynamic> body, Function callback) async {
    HistoryModels model = await _repository.getHistoryAbsen(body: body);
    _getHistoryAbsen.sink.add(model);
    callback(model.status, model.error, model.message, model);
  }

  dispose() {
    _getHistoryAbsen.close();
  }

}

final bloc = HistoryBloc();