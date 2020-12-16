import 'package:dio/dio.dart';
import 'package:geofancing/src/models/default_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class PengajuanDetailBloc {
  final _repository = Repository();
  final _getDoDetailPengajuan = PublishSubject<DefaultModel>();


  Stream<DefaultModel> get getUploadImageProfile => _getDoDetailPengajuan.stream;


  doPengajuanDetail(FormData data, Function callback) async {
//    print(data);
    DefaultModel model = await _repository.submitDetailPengajuan(formData: data);
    _getDoDetailPengajuan.sink.add(model);
    callback(model);
  }

  dispose() {
    _getDoDetailPengajuan.close();
  }

}

final bloc = PengajuanDetailBloc();