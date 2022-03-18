import 'package:dio/dio.dart';
import 'package:geofancing/src/models/default_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CarBeforeSave {
  final _repository = Repository();
  final _getDoSaveBefore = PublishSubject<DefaultModel>();

  Stream<DefaultModel> get getCarSaveBefore => _getDoSaveBefore.stream;

  doPengajuan(FormData data, Function callback) async {
//    print(data);
    DefaultModel model = await _repository.submitCarBefore(formData: data);
    _getDoSaveBefore.sink.add(model);
    callback(model);
  }

  dispose() {
    _getDoSaveBefore.close();
  }
}

final bloc = CarBeforeSave();