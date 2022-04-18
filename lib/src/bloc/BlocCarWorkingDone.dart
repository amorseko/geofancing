import 'package:geofancing/src/models/car_working_model_done.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class HistoryCarWorkingDoneBloc {
  final _repository = Repository();
  final _getHistoryCarWorkingDone = PublishSubject<HistoryCarWorkingModelsDone>();

  Stream<HistoryCarWorkingModelsDone> get getHistoryCarWorkingDone => _getHistoryCarWorkingDone.stream;

  getsHistoryCarWorkingDone(Map<String, dynamic> body, Function(HistoryCarWorkingModelsDone model) callback) async {
    HistoryCarWorkingModelsDone model = await _repository.historyCarWorkingDone(body:body);
    _getHistoryCarWorkingDone.sink.add(model);
    callback(model);
  }

  dispose() {
    _getHistoryCarWorkingDone.close();
  }
}

final bloc = HistoryCarWorkingDoneBloc();