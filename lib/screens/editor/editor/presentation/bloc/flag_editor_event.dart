part of 'flag_editor_bloc.dart';

@immutable
sealed class FlagEditorEvent {}

final class FlagEditorInitializeEvent extends FlagEditorEvent {}

final class FlagEditorSaveFlagEvent extends FlagEditorEvent {}
