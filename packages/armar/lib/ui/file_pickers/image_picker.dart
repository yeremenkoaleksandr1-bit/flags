import 'package:file_picker/file_picker.dart';

abstract class ArImagePicker {
  static Future<PlatformFile?> pickImage() => _pick<PlatformFile>() ;

  static Future<List<PlatformFile>?> pickImages() =>
      _pick<List<PlatformFile>>(allowMultiple: true) ;


  static Future<T?> _pick<T>({
    bool allowMultiple = false,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      if (allowMultiple) {
        return result.files as T;
      } else {
        return result.files.first as T;
      }
    }

    return null;
  }
}
