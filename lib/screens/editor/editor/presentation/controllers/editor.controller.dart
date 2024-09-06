// import 'dart:math';
// import 'dart:ui';
//
// import 'package:flags/core/features/qlevar.dart';
// import 'package:flags/domain/editor/editor_flag.dart';
// import 'package:flags/domain/editor/shapes/shapes.dart';
// import 'package:flags/domain/editor/styles/style.dart';
// import 'package:flags/domain/game_objects/emblems/emblems.dart';
// import 'package:flags/domain/game_objects/game_objects.dart';
// import 'package:flags/logger.dart';
// import 'package:flags/screens/editor/editor/presentation/controllers/factories/boards/shapes_board.dart';
// import 'package:flags/screens/editor/editor/presentation/controllers/factories/boards/styles_board.dart';
// import 'package:flags/screens/editor/editor/presentation/object_handles/editor_draggable.dart';
// import 'package:flags/screens/editor/my_flags/domain/services/editr_gallery.service.dart';
// import 'package:flutter/foundation.dart';
// import 'package:qlevar_router/qlevar_router.dart';
// import 'package:state_manager/state_manager.dart';
//
// import 'factories/boards/emblems_factory.dart';
// import 'mixins/boards.dart';
//
// abstract interface class IEditorPresenter with StateMixin<dynamic> {
//   EditorFlagData get flag;
//
//   void selectBackgroundStyle(FlagStyle style);
//
//   Future<void> addObjectToScene(GameObject object);
//
//   Future<void> selectObject(EditorDraggableWidget? object);
//
//   Map<String, FlagStyle> get backgroundStyles;
//
//   Map<String, SShape> get shapes;
//
//   List<Emblem> get emblems;
//
//   ValueListenable<FlagStyle> get selectedStyle;
//
//   ValueListenable<List<EditorDraggableWidget>> get sceneObjects;
//
//   ValueListenable<EditorDraggableWidget?> get selectedObject;
//
//   void setOriginalAreaSize(Size value);
//
//   void onCloseEditor();
// }
//
// class EditorPresenterImpl extends GetController
//     with StateMixin<dynamic>, QRContextMixin, EditorBoardsMixin
//     implements IEditorPresenter {
//   @override
//   final EditorFlagData flag;
//
//   EditorPresenterImpl(this.flag);
//
//   Size _areaSize = Size.zero;
//
//   @override
//   late final Map<String, FlagStyle> backgroundStyles;
//   @override
//   late final Map<String, SShape> shapes;
//   @override
//   late final List<Emblem> emblems;
//
//   @override
//   late final ValueNotifier<FlagStyle> selectedStyle;
//
//   @override
//   late final ValueNotifierList<EditorDraggableWidget> sceneObjects;
//
//   @override
//   final ValueNotifier<EditorDraggableWidget?> selectedObject =
//       ValueNotifier(null);
//
//   @override
//   Future<void> onInit() async {
//     backgroundStyles = StylesBoardFactory.create(flag.rect);
//     shapes = ShapesBoardFactory.create();
//     selectedStyle = ValueNotifier(flag.backgroundStyle);
//     emblems = EmblemsFactory.create();
//     sceneObjects = ValueNotifierList([
//       ...flag.objects.map(EditorDraggableWidget.new),
//     ]);
//
//     change(
//       const SuccessStatus(null),
//     );
//
//     super.onInit();
//   }
//
//   @override
//   void selectBackgroundStyle(FlagStyle style) {
//     selectedStyle.value = style;
//   }
//
//   @override
//   Future<void> addObjectToScene(GameObject object) async {
//     sceneObjects.add(
//       EditorDraggableWidget(object),
//     );
//   }
//
//   @override
//   Future<void> selectObject(EditorDraggableWidget? object) async {
//     selectedObject.value = object;
//   }
//
//   @override
//   void onClose() {
//     disposeState();
//     selectedStyle.dispose();
//     sceneObjects.dispose();
//     selectedObject.dispose();
//     super.onClose();
//   }
//
//   @override
//   Future<void> onCloseEditor() async {
//     final sceneObjects = this.sceneObjects.value;
//
//     final effectiveFraction =
//         min(_areaSize.width, _areaSize.height) / (64 / flag.proportion);
//
//     logger.i(effectiveFraction);
//     final effectiveObjects = sceneObjects.map((e) {
//       return e.gameObject.copyWith(
//         size: e.gameObject.size / effectiveFraction,
//         position: e.gameObject.position / effectiveFraction,
//       );
//     }).toList();
//
//     final effectiveFlagData = flag.copyWith(
//       objects: effectiveObjects,
//       backgroundStyle: selectedStyle.value,
//     );
//
//     await IEditorGalleryService.I.saveFlag(effectiveFlagData);
//
//     await QR.back();
//   }
//
//   @override
//   void setOriginalAreaSize(Size value) {
//     _areaSize = value;
//   }
// }
