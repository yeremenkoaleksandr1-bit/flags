import 'emblems.dart';

class Resources {
  static Resources get i => _singleton;
  static final Resources _singleton = Resources._internal();

  factory Resources() {
    return _singleton;
  }

  Resources._internal();

  final EmblemsResources emblemsResources = EmblemsResources();

  Future<void> initialize() async {
    await emblemsResources.loadEmblems();
  }
}
