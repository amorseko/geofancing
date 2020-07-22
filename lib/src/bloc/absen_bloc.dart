import 'package:dio/dio.dart';
import 'package:geofancing/src/models/default_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class AbsenBloc {
  final _repository = Repository();
  final _getDoAbsen = PublishSubject<DefaultModel>();


  Stream<DefaultModel> get getUploadImageProfile => _getDoAbsen.stream;


  doAbsen(FormData data, Function callback) async {
    DefaultModel model = await _repository.submitAbsen(formData: data);
    _getDoAbsen.sink.add(model);
    callback(model);
  }

  dispose() {
    _getDoAbsen.close();
  }

}

final bloc = AbsenBloc();