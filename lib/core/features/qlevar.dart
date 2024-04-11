import 'package:flutter/cupertino.dart';
import 'package:qlevar_router/qlevar_router.dart';

mixin QRContextMixin {
  BuildContext? get routeContext => QR.context;
}
