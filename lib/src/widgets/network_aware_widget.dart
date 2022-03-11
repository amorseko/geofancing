import 'package:flutter/material.dart';
import 'package:geofancing/src/utility/network_status_service.dart';
import 'package:provider/provider.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget onlineChild;
  final Widget offlineChild;

  const NetworkAwareWidget({ key, this.onlineChild, this.offlineChild })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    NetworkStatus networkStatus = Provider.of<NetworkStatus>(context);

    if(networkStatus == NetworkStatus.Online) {
      return onlineChild;
    } else {
      return offlineChild;
    }
  }
}