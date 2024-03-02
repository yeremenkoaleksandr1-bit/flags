import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qlevar_router/qlevar_router.dart';

abstract class AppRouteWithPresenter<T> extends AppRoute {


  AppRouteWithPresenter({

    super.fullscreenDialog,
    required super.path,
    required super.builder,
    super.children,
    super.meta,
    super.middleware,
    super.name,
    super.pageType,
  });
}

abstract class AppRoute extends QRoute {
  AppRoute({
    this.fullscreenDialog = false,
    required super.path,
    required super.builder,
    super.children,
    super.meta,
    super.middleware,
    super.name,
    super.pageType,
  });

  final bool fullscreenDialog;
}
