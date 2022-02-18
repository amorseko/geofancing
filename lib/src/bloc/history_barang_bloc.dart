import 'package:dio/dio.dart';
import 'package:geofancing/src/models/history_barang_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class HistoryBloc {
  final _repository = Repository();
  final _getHistoryBarang = PublishSubject<HistoryBarangModels>();


  Stream<HistoryBarangModels> get getHistoryAbsen => _getHistoryBarang.stream;


  getHistory(Map<String, dynamic> body, Function callback) async {
    HistoryBarangModels model = await _repository.getHistoryBarang(body: body);
    _getHistoryBarang.sink.add(model);
    callback(model.status, model.error, model.message, model);
  }

  dispose() {
    _getHistoryBarang.close();
  }

}

final bloc = HistoryBloc();