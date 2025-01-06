// import 'package:flags/domain/editor/create_flag_data.dart';
// import 'package:flags/domain/editor/editor_flag.dart';
// import 'package:flags/domain/services/editor/editor_gallery.service.dart';
// import 'package:flags/logger.dart';
// 
// import 'package:flags/features/editor/my_flags/presentation/dialogs/create_flag.dialog.dart';
// import 'package:flags/shared/services/disposable.dart';
// 
// 
//
// abstract interface class IMyFlagsPresenter
//     with StateMixin<List<EditorFlagData>>
//     implements IDisposable {
//   Future<void> createFlag();
//
//   Future<void> openFlag(EditorFlagData flag);
//
//   ValueListenableList<EditorFlagData> get flags;
// }
//
// class MyFlagsPresenterImpl extends GetController
//     with StateMixin<List<EditorFlagData>>
//     implements IMyFlagsPresenter {
//   late final IEditorGalleryService editorGalleryService;
//
//
//   @override
//   Future<void> onInit() async {
//     editorGalleryService = await EditorGalleryServiceImpl().initialize();
//     change(
//       const SuccessStatus([]),
//     );
//
//     super.onInit();
//   }
//
//   @override
//   void onClose() {
//     Get.delete<IEditorGalleryService>();
//     super.onClose();
//   }
//
//   @override
//   Future<void> createFlag() async {
//     final data = await const CreateFlagDialog().showModal<CreateFlagData>();
//
//     if (data != null) {
//       final flag = EditorFlagData(
//         name: data.name,
//         proportion: data.proportion,
//       );
//
//       await editorGalleryService.insertFlag(flag);
//
//       await openFlag(flag);
//     }
//   }
//
//   @override
//   Future<void> openFlag(EditorFlagData flag) async {
//     logger.i(flag.objects.length);
//     await QR.toName(
//       Routes.editor,
//       params: {'data': flag},
//     );
//   }
// }
