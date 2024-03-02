import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

class MultipartFileExtended extends MultipartFile {
  final String? filePath; //this one!

  MultipartFileExtended(
    Stream<List<int>> Function() stream,
    length, {
    filename,
    this.filePath,
    contentType,
    Map<String, List<String>>? headers,
  }) : super.fromStream(
          stream,
          length,
          filename: filename,
          contentType: contentType,
          headers: headers,
        );

  factory MultipartFileExtended.fromBytes(
    List<int> value, {
    String? filename,
    MediaType? contentType,
    final Map<String, List<String>>? headers,
  }) {
    return MultipartFileExtended(
      () => Stream.fromIterable([value]),
      value.length,
      filename: filename,
      contentType: contentType,
      headers: headers,
    );
  }

  static MultipartFileExtended fromFileSync(
    String filePath, {
    required String filename,
    required MediaType contentType,
  }) =>
      multipartFileFromPathSync(
        filePath,
        filename: filename,
        contentType: contentType,
      );
}

MultipartFileExtended multipartFileFromPathSync(
  String filePath, {
  String? filename,
  required MediaType contentType,
}) {
  filename ??= p.basename(filePath);
  var file = File(filePath);
  var length = file.lengthSync();

  stream() => file.openRead();

  return MultipartFileExtended(
    stream,
    length,
    filename: filename,
    contentType: contentType,
    filePath: filePath,
  );
}
