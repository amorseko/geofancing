
import 'package:dio/dio.dart';
import 'package:geofancing/src/models/absen_model.dart';
import 'package:geofancing/src/models/default_model.dart';
import 'package:geofancing/src/models/history_model.dart';
import 'package:geofancing/src/models/standart_model.dart';
import 'package:geofancing/src/resources/api_provider.dart';
import 'package:geofancing/src/models/members_model.dart';
class Repository {
  final apiProvider = ApiProvider();

  Future<MemberModels> actLogin({Map<String, dynamic> body}) =>
      apiProvider.login(body: body);

  Future<StandartModels> actChangePassUser({Map<String, dynamic> body}) =>
      apiProvider.changePass(body: body);

  void getLang({Map<String, dynamic> body}) =>
      apiProvider.getLang(body: body);

  Future<DefaultModel> submitAbsen({FormData formData}) => apiProvider.submitAbsen(formData: formData);

  Future<HistoryModels> getHistoryAbsen({Map<String, dynamic> body}) => apiProvider.getHistoryAbsen(body:body);
  Future<AbsenModels> getTodayAbsen({Map<String, dynamic> body}) => apiProvider.getTodayAbsen(body:body);

}