part of 'flag_editor_bloc.dart';

@immutable
sealed class FlagEditorState {}

final class FlagEditorLoadingState extends FlagEditorState {}

final class FlagEditorReadyState extends FlagEditorState {}
