import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

typedef UIImage = ui.Image;

extension UiImageExtensions on ImageProvider {
  Future<UIImage> get image async {
    final completer = Completer<UIImage>();

    final stream = resolve(ImageConfiguration.empty);
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        if (!completer.isCompleted) {
          completer.complete(info.image);
        }
        stream.removeListener(listener);
      },
      // Without onError a failed decode left this future pending forever.
      onError: (error, stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);

    return await completer.future;
  }
}
