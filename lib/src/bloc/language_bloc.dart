import 'package:geofancing/src/resources/repository.dart';
import 'package:geofancing/src/models/standart_model.dart';
import 'package:rxdart/rxdart.dart';
class LanguageBloc {
  final _repository = Repository();
  final _getLang = PublishSubject<StandartModels>();

  getLang(Map<String, dynamic> body, Function callback) async {
    print(body);
    final model = await _repository.getLang(body: body);
    callback(model);
  }

}

final bloc = LanguageBloc();