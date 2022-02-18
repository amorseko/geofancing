import 'package:geofancing/src/models/list_bank_model.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetListBankBloc {
  final _repository = Repository();
  final _GetListBankBloc = PublishSubject<ListBankModels>();

  Stream<ListBankModels> get getListGapoktanCmb => _GetListBankBloc.stream;
  getListBankBloc(Map<String, dynamic> body,Function callback) async {
    ListBankModels model = await _repository.getListBank(body:body);
    _GetListBankBloc.sink.add(model);
    callback(model);
  }

  dispose() {
    _GetListBankBloc.close();
  }
}