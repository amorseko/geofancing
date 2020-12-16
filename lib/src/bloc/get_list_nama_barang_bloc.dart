import 'package:geofancing/src/models/list_barang_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetListNamaBarangBloc {
  final _repository = Repository();
  final _getListNamaBarangBloc = PublishSubject<GetListNamaBarangModels>();

  getListNamaParangBlocs(Map<String, dynamic> body, Function callback) async {
    GetListNamaBarangModels model =
        await _repository.fetchGetListNamaBarang(body: body);
//    callback(model.status, model.message);
    _getListNamaBarangBloc.sink.add(model);
    callback(model);
  }

  dispose() {
    _getListNamaBarangBloc.close();
  }
}

final bloc = GetListNamaBarangBloc();
