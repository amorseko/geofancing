import 'package:geofancing/src/models/id_barang_detail_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetIdBarangDetailBloc {
  final _repository = Repository();
  final _getIdBarangDetailModels = PublishSubject<IDBarangModels>();

  Stream<IDBarangModels> get getIdBarang => _getIdBarangDetailModels.stream;
  getIdBarangs(Function(IDBarangModels model) callback) async {
    IDBarangModels model = await _repository.fetchGetIdBarangDetail();
    _getIdBarangDetailModels.sink.add(model);
    callback(model);
  }

  dispose() {
    _getIdBarangDetailModels.close();
  }
}
