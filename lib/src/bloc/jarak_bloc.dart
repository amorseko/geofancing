import 'package:dio/dio.dart';
import 'package:geofancing/src/models/jarak_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class JarakBloc {
  final _repository = new Repository();
  final _getJarak = PublishSubject<JarakModels>();


//  Stream<JarakModels> get getJarak => _getJarak.stream;
  Stream<JarakModels> get getJarak => _getJarak.stream;
  doJarak(Map<String, dynamic> body, Function(bool status, String message, JarakModels model) callback) async {
//    print(callback);
    JarakModels model = await _repository.RepogetJarak(body: body);
//    print(model.data.jarak);
//    print("data req jarak : " + body.toString());
    _getJarak.sink.add(model);
    callback(model.status, model.message, model);
  }

  dispose() {
    _getJarak.close();
  }

}


final bloc = JarakBloc();