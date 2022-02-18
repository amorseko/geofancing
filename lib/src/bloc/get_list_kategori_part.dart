import 'package:geofancing/src/models/kategori_part_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetListKategoriPartBloc{

  final _repository = Repository();
  final _getListKategoriPartBloc = PublishSubject<GetListKategoriPartModels>();

  Stream<GetListKategoriPartModels> get getListKategoriPartBloc => _getListKategoriPartBloc.stream;
  getListKategoriPartsBloc(Function(GetListKategoriPartModels model) callback) async {
    GetListKategoriPartModels model = await _repository.fetchGetListKategoriPart();
    _getListKategoriPartBloc.sink.add(model);
    callback(model);
  }

  dispose() {
    _getListKategoriPartBloc.close();
  }
}