import 'dart:isolate';
import 'dart:ui';

import 'package:submission_resto/common/utils/notification_helper.dart';
import 'package:submission_resto/data/api/api_service.dart';
import 'package:submission_resto/main.dart';
import 'package:http/http.dart' as http;


final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializationIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    final http.Client httpClient = http.Client();

    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await ApiService(httpClient: httpClient).getListRestaurants();
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
