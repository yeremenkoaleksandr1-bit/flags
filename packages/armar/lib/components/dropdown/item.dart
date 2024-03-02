import 'dart:async';

import 'package:flutter/material.dart';

class ArDropdownItem<T> {
  ArDropdownItem({
    required this.value,
    this.height = 42,
    this.enabled = true,
    required this.tag,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  });

  final T value;
  final String tag;
  final FutureOr<void> Function()? onTap;
  final double height;
  final Widget child;

  final EdgeInsets padding;

  final bool enabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArDropdownItem &&
          runtimeType == other.runtimeType &&
          tag == other.tag;

  @override
  int get hashCode => tag.hashCode;
}
