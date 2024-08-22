part of 'area_cubit.dart';

@immutable
final class EditorAreaState extends Equatable {
  final Rect rect;

  const EditorAreaState({
    required this.rect,
  });

  EditorAreaState copyWith({
    Rect? rect,
  }) {
    return EditorAreaState(
      rect: rect ?? this.rect,
    );
  }

  @override
  List<Object?> get props => [rect];
}
