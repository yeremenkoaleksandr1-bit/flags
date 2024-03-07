import 'package:flutter/material.dart';

class TotalMoneyWidget extends StatefulWidget {
  static final GlobalKey _key = GlobalKey();

  TotalMoneyWidget({
    required this.child,
  }) : super(key: _key);

  final Widget child;

  static TotalMoneyWidgetState? get instance {
    return _key.currentContext
        ?.findAncestorStateOfType<TotalMoneyWidgetState>();
  }

  @override
  State<TotalMoneyWidget> createState() => TotalMoneyWidgetState();
}

class TotalMoneyWidgetState extends State<TotalMoneyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
