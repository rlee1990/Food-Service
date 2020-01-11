import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:food_dev/enums/connection_state.dart';



class ConnectivityService {

StreamController<ConnectionStatus> connectionStatusController = StreamController<ConnectionStatus>();

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      var connectionStatus = _getStatusFromResult(result);

      connectionStatusController.add(connectionStatus);
    });
  }

  ConnectionStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectionStatus.cellular;
      case ConnectivityResult.wifi:
        return ConnectionStatus.wifi;
      case ConnectivityResult.none:
        return ConnectionStatus.offline;
      default:
      return ConnectionStatus.offline;
    }
  }
}