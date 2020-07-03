
import 'package:geofancing/src/resources/api_provider.dart';
import 'package:geofancing/src/models/members_model.dart';
class Repository {
  final apiProvider = ApiProvider();

  Future<MemberModels> actLogin({Map<String, dynamic> body}) =>
      apiProvider.login(body: body);

  void getLang({Map<String, dynamic> body}) =>
      apiProvider.getLang(body: body);
}