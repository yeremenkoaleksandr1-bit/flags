import 'package:armar/armar.dart';
import 'package:flags/presentation/presenters/my_flags/my_flags.presenter.dart';
import 'package:flutter/material.dart';

class MyFlagsScreen extends ArGetScreen<IMyFlagsPresenter> {
  const MyFlagsScreen({super.key, required super.presenter});

  @override
  Widget build(BuildContext context, IMyFlagsPresenter presenter) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyFlags"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [],
      ),
    );
  }
}
