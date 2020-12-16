import 'package:dio/dio.dart';
import 'package:geofancing/src/models/default_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class AbsenBloc {
  final _repository = Repository();
  final _getDoPengajuan = PublishSubject<DefaultModel>();

  Stream<DefaultModel> get getPengajuan => _getDoPengajuan.stream;

  doPengajuan(FormData data, Function callback) async {
//    print(data);
    DefaultModel model = await _repository.submitPenajuan(formData: data);
    _getDoPengajuan.sink.add(model);
    callback(model);
  }

  dispose() {
    _getDoPengajuan.close();
  }
}

final bloc = AbsenBloc();
