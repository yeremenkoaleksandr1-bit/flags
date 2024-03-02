import 'package:armar/armar.dart';

abstract class Repository {
  Repository() : _dio = Get.find<IApiClient>().dio;

  final Dio _dio;

  Dio get dio => _dio;

  RequestOptions setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
