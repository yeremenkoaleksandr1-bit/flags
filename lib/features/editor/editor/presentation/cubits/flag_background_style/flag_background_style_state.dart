part of 'flag_background_style_cubit.dart';

final class EditorFlagBackgroundStyleState extends Equatable {
  final FlagStyle style;

  const EditorFlagBackgroundStyleState({
    required this.style,
  });

  @override
  List<Object?> get props => [style];

  EditorFlagBackgroundStyleState copyWith({
    FlagStyle? style,
  }) {
    return EditorFlagBackgroundStyleState(
      style: style ?? this.style,
    );
  }
}
