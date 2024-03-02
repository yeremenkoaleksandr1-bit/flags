import 'dart:io';

import 'package:armar/api/api.dart';
import 'package:armar/armar.dart';
import 'package:armar/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ArmarFlutterCore {
  Future<ArmarFlutterCore> init({
    required ArApiClient apiClient,
    NotificationsServiceImpl? notificationsService,
  }) async {
    await initDependencies();
    await apiClient.init();

    if (notificationsService != null) {
      await notificationsService.init();
    }

    return this;
  }

  Future<void> initDependencies() async {
    final widgetsFlutterBindings = WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    await initPermissions();
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var hiveDirectory = Directory('${appDocumentDir.path}/local_storage');

    if (!await hiveDirectory.exists()) {
      hiveDirectory = await hiveDirectory.create(recursive: true);
    }
  }

  Future<bool> initPermissions() async {
    var status = await Permission.manageExternalStorage.status;

    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }

    status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }

    return status.isGranted;
  }
}
