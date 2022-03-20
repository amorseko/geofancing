import 'package:geofancing/src/models/car_working_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

// class HistoryCarWorkingBloc {
//   final _repository = Repository();
//   final _getHistoryCarWorking = PublishSubject<HistoryCarWorkingModels>();
//
//   Stream<HistoryCarWorkingModels> get getHistoryCarWorking =>
//       _getHistoryCarWorking.stream;
//
//   getsHistoryCarWorking(Map<String, dynamic> body, Function(HistoryCarWorkingModels model) callback) async {
//     HistoryCarWorkingModels model =
//     await _repository.historyCarWorking(body: body);
//     _getHistoryCarWorking.sink.add(model);
//     callback(model);
//   }
//
//   dispose() {
//     _getHistoryCarWorking.close();
//   }
// }

class HistoryCarWorkingBloc {
  final _repository = Repository();
  final _getHistoryCarWorking =
  PublishSubject<HistoryCarWorkingModels>();

  Stream<HistoryCarWorkingModels> get getHistoryCarWorking => _getHistoryCarWorking.stream;

  getsHistoryCarWorking(Map<String, dynamic> body, Function(HistoryCarWorkingModels model) callback) async {
    HistoryCarWorkingModels model = await _repository.historyCarWorking(body:body);
    _getHistoryCarWorking.sink.add(model);
    callback(model);
  }

  dispose() {
    _getHistoryCarWorking.close();
  }
}

final bloc = HistoryCarWorkingBloc();
