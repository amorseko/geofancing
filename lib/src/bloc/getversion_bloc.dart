import 'package:geofancing/src/models/getversion_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetVersionBloc {
  final _repository = Repository();
  final _getVersion = PublishSubject<GetVersionModel>();

  getVersion(Map<String, dynamic> body, Function callback) async {
    GetVersionModel model = await _repository.getVersion(body: body);
    callback(model, model.status, model.message);
  }

  dispose() {
    _getVersion.close();
  }
}

final bloc = GetVersionBloc();