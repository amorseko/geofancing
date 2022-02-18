import 'package:dio/dio.dart';
import 'package:geofancing/src/models/list_barang_detail_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ListBarangDetailBloc {
  final _repository = Repository();
  final _getListBarangDetail = PublishSubject<GetListBarangDetailModels>();


  Stream<GetListBarangDetailModels> get getHistoryAbsen => _getListBarangDetail.stream;


  getListBarangDetail(Map<String, dynamic> body, Function callback) async {
    GetListBarangDetailModels model = await _repository.getListBarangDetail(body: body);
    _getListBarangDetail.sink.add(model);
    callback(model.status, model.error, model.message, model);
  }

  dispose() {
    _getListBarangDetail.close();
  }

}

final bloc = ListBarangDetailBloc();