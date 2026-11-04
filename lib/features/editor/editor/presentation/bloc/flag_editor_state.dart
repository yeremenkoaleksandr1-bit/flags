part of 'flag_editor_cubit.dart';

final class FlagEditorState extends Equatable {
  final bool isOpenedStylesBoard;
  final bool isOpenedShapesBoard;
  final bool isOpenedEmblemsBoard;
  final bool isOpenedCustomPaintBoard;

  final FlagStyle selectedStyle;

  final List<EditorDraggableWidget> sceneObjects;

  const FlagEditorState({
    this.isOpenedStylesBoard = false,
    this.isOpenedShapesBoard = false,
    this.isOpenedEmblemsBoard = false,
    this.isOpenedCustomPaintBoard = false,
    required this.selectedStyle,
    required this.sceneObjects,
  });

  @override
  List<Object?> get props => [
        isOpenedStylesBoard,
        isOpenedShapesBoard,
        isOpenedEmblemsBoard,
        isOpenedCustomPaintBoard,
        selectedStyle,
        sceneObjects,
      ];

  FlagEditorState copyWith({
    bool? isOpenedStylesBoard,
    bool? isOpenedShapesBoard,
    bool? isOpenedEmblemsBoard,
    bool? isOpenedCustomPaintBoard,
    FlagStyle? selectedStyle,
    List<EditorDraggableWidget>? sceneObjects,
  }) {
    return FlagEditorState(
      isOpenedStylesBoard: isOpenedStylesBoard ?? this.isOpenedStylesBoard,
      isOpenedShapesBoard: isOpenedShapesBoard ?? this.isOpenedShapesBoard,
      isOpenedEmblemsBoard: isOpenedEmblemsBoard ?? this.isOpenedEmblemsBoard,
      isOpenedCustomPaintBoard:
          isOpenedCustomPaintBoard ?? this.isOpenedCustomPaintBoard,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      sceneObjects: sceneObjects ?? this.sceneObjects,
    );
  }
}
