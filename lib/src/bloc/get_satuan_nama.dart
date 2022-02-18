import 'package:geofancing/src/models/satuan_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';


class GetSatuanNamaBloc{
  final _repository = Repository();
  final _getSatuanNamaBloc = PublishSubject<GetSatuanModels>();

  getListSatuanNamabloc(Map<String, dynamic> body, Function callback) async {
    GetSatuanModels model = await _repository.fetchGetNamaSatuan(body: body);
//    callback(model.status, model.message);
    _getSatuanNamaBloc.sink.add(model);
    callback(model);
  }

  dispose() {
    _getSatuanNamaBloc.close();
  }
}

final bloc = GetSatuanNamaBloc();