import 'package:dio/dio.dart';
import 'package:geofancing/src/models/default_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class PekerjaanBloc {
  final _repository = Repository();
  final _getDoPekerjaan = PublishSubject<DefaultModel>();

  Stream<DefaultModel> get getUploadImageProfile => _getDoPekerjaan.stream;

  doPekerjaanBloc(FormData data, Function callback) async {
//    print(data);
    DefaultModel model = await _repository.submitChangeImage(formData: data);
    _getDoPekerjaan.sink.add(model);
    callback(model);
  }

  dispose() {
    _getDoPekerjaan.close();
  }
}

final bloc = PekerjaanBloc();
