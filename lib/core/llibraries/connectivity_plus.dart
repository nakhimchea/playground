import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:playground/core/helpers/debouncer.dart';

import '../../widgets/dialog/alert/dialog_manager.dart';

class ConnectivityPlusManager {
  ConnectivityPlusManager._() {
    isConnected.then((value) {
      if (!value && _dialogEnabled) AlertDialogManager.showNoInternetConnection();
    });

    _listener = connectity.onConnectivityChanged.listen((events) {
      _debouncer.run(() {
        // customPrint('ConnectivityPlusManager: $events');
        if (_latestStatus == events) return;
        _latestStatus = events;

        if (isConnectedWithStatus(events)) {
          if (_dialogEnabled) {
            // Will dismiss all dialogs, not only the no internet one
            Future.delayed(const Duration(milliseconds: 150)).then((_) {
              if (AlertDialogManager.isShowingNoInternet && Get.isOverlaysOpen) {
                Get.back(closeOverlays: true);
              }
            });
          }

          // Only trigger update when connected and it is in foreground
          // if (FlutterFGBGManager.shared.isForeground) {
          //   ChatChannelRepository.shared.updatePresenceStatus('ConnectivityPlusManager', true);
          // }
        } else {
          if (_dialogEnabled) {
            AlertDialogManager.showNoInternetConnection();
            Timer.periodic(const Duration(milliseconds: 500), (timer) async {
              final connected = await isConnected;

              if (connected && AlertDialogManager.isShowingNoInternet && Get.isOverlaysOpen) {
                Get.back(closeOverlays: true);
              }

              if (connected) timer.cancel();
            });
          }
        }
      });
    });
  }
  static final shared = ConnectivityPlusManager._();

  final connectity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _listener;
  List<ConnectivityResult>? _latestStatus;

  final List<String> _ignoreRoutes = [];
  late final bool _dialogEnabled = Platform.isAndroid && _ignoreRoutes.contains(Get.currentRoute);

  final _debouncer = Debouncer(milliseconds: 200);

  Future<bool> get isConnected async {
    final status = await connectity.checkConnectivity();
    return isConnectedWithStatus(status);
  }

  bool isConnectedWithStatus(List<ConnectivityResult> status) {
    return status.contains(ConnectivityResult.wifi) ||
        status.contains(ConnectivityResult.mobile) ||
        status.contains(ConnectivityResult.ethernet);
  }

  void dispose() {
    _debouncer.cancel();
    _listener?.cancel();
  }
}
