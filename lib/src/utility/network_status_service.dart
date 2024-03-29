import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';

enum NetworkStatus { Online, Offiline }

class NetworkStatusService {
  StreamController<NetworkStatus> networkStatusController = StreamController<NetworkStatus>();

  NetworkStatusService () {
    Connectivity().onConnectivityChanged.listen((status) {
      print(status);
      networkStatusController.add(_getNetworkStatus(status));
    });
  }

  NetworkStatus _getNetworkStatus(ConnectivityResult status) {
    return status == ConnectivityResult.mobile || status == ConnectivityResult.wifi ? NetworkStatus.Online : NetworkStatus.Offiline;

  }
}