import 'package:geofancing/src/models/jenis_pekerjaan_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetListJenisPekerjaanBloc {
  final _repository = Repository();
  final _getListJenisPekerjaanBloc =
      PublishSubject<GetListJenisPekerjaanModel>();

  Stream<GetListJenisPekerjaanModel> get getListJenisPekerjaan =>
      _getListJenisPekerjaanBloc.stream;
  getListJenisPekerjaans(
      Function(GetListJenisPekerjaanModel model) callback) async {
    GetListJenisPekerjaanModel model =
        await _repository.fetchGetListJenisPekerjaan();
    _getListJenisPekerjaanBloc.sink.add(model);
    callback(model);
  }

  dispose() {
    _getListJenisPekerjaanBloc.close();
  }
}
