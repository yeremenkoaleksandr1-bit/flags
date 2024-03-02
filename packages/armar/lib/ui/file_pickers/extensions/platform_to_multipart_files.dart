import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;

import 'package:armar/api/api.dart';

Future<Uint8List> readBytesFromFile(String path) async => Uint8List.fromList(
      await File.fromUri(Uri.parse(path)).readAsBytes(),
    );

extension PlatFormFileToMultiPart on PlatformFile {
  Future<MultipartFileExtended> toMultiPlatformImage() async {
    final fileData = File(path!);

    Uint8List bytes = await fileData.readAsBytes();

    final encodedImage = img.encodeJpg(img.decodeImage(bytes)!);
    return MultipartFileExtended.fromBytes(
      encodedImage,
      filename: name,
      contentType: MediaType("image", 'jpg'),
    );
  }
}

extension PlatFormFilesToMultiPart on List<PlatformFile> {
  Future<List<MultipartFile>> toMultiPlatformImages() async {
    List<MultipartFile> multipartFiles = [];

    for (final file in this) {
      multipartFiles.add(await file.toMultiPlatformImage());
    }

    return multipartFiles;
  }
}
