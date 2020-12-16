import 'package:geofancing/src/models/get_picture_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ListSelectedImage {
  final _repository = Repository();
  final _GetPictureModel = PublishSubject<GetPictureModel>();

  Stream<GetPictureModel> get getListBantuanBlocs => _GetPictureModel.stream;
  getListBantuanBloc(Map<String, dynamic> body, Function callback) async {
    GetPictureModel model = await _repository.fetchGetImageSelected(body: body);
    _GetPictureModel.sink.add(model);
    callback(model.status, model.error, model.message, model);
  }

  dispose() {
    _GetPictureModel.close();
  }
}
