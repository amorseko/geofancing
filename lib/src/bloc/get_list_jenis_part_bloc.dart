import 'package:geofancing/src/models/jenis_part_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetListJenisPartBloc{

  final _repository = Repository();
  final _getListJenisPartBloc = PublishSubject<GetListJenisPartModels>();

  Stream<GetListJenisPartModels> get getListJenisPart => _getListJenisPartBloc.stream;
  getListJenisParts(Function(GetListJenisPartModels model) callback) async {
    GetListJenisPartModels model = await _repository.fetchGetListJenisPart();
    _getListJenisPartBloc.sink.add(model);
    callback(model);
  }

  dispose() {
    _getListJenisPartBloc.close();
  }
}