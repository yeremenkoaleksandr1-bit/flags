import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

typedef UIImage = ui.Image;

extension UiImageExtensions on ImageProvider {
  Future<UIImage> get image async {
    final completer = Completer<UIImage>();

    resolve(ImageConfiguration.empty).addListener(
      ImageStreamListener(
        (info, _) {
          completer.complete(info.image);
        },
      ),
    );

    return await completer.future;
  }
}
