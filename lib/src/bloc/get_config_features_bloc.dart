import 'package:geofancing/src/models/config_get_features.dart';
import 'package:geofancing/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ConfigGetFeaturesBloc {
  final _repository = Repository();
  final _configGetFeaturesBloc = PublishSubject<ConfigGetFeaturesModel>();

  Stream<ConfigGetFeaturesModel> get configGetFeatureBloc => _configGetFeaturesBloc.stream;
  configGetFeature(Function(ConfigGetFeaturesModel model) callback) async {
    ConfigGetFeaturesModel model = await _repository.fetchConfigGetFeatures();
    _configGetFeaturesBloc.sink.add(model);
    callback(model);
  }
  dispose() {
    _configGetFeaturesBloc.close();
  }
}

final bloc = ConfigGetFeaturesBloc();