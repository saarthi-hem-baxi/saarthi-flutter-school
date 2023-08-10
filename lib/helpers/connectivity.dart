import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saarthi_pedagogy_studentapp/widgets/common/no_internet.dart';

class ConnectivityHandler extends GetxController {
  // ignore: unused_field
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  RxBool isConnected = false.obs;

  bool dialogDisplayed = false;
  final Connectivity _connectivity = Connectivity();
  // StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  ConnectivityHandler() {
    initConnectivity();

    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
    if (result == ConnectivityResult.none) {
      // Get.to(const NoInternetConnection());
      if (!dialogDisplayed) {
        dialogDisplayed = true;
        Get.dialog(
          NoInternetConnection(
            connectivityHandler: this,
          ),
        ); //barrierDismissible: false, title: '', titlePadding: EdgeInsets.zero, content:
      }
      isConnected.value = false;
    } else {
      if (dialogDisplayed) {
        Get.back();
        dialogDisplayed = false;
      }
      isConnected.value = true;
    }
  }
}
