import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

class MainRouterBuilder extends StatelessWidget {
  final QRouter router;

  const MainRouterBuilder({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: router,
    );
  }
}
