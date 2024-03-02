import 'package:armar/armar.dart';

abstract class GameProcessScreen<T> extends ArGetScreen<T> {
  const GameProcessScreen({super.key, required super.presenter});
}
