import 'package:armar/api/client.dart';
import 'package:dio/dio.dart';

import '../../logger.dart';

class CsrfTokenInspector {
  static Future<void> refreshCsrf(Response<dynamic> response) async {
    final client = IApiClient.get;
    client.setArCookies(client.getSetResponseCookies(response));
  }

  static Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final client = IApiClient.get;
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
      extra: requestOptions.extra,
      sendTimeout: requestOptions.sendTimeout,
      receiveTimeout: requestOptions.receiveTimeout,
      responseType: requestOptions.responseType,
      validateStatus: requestOptions.validateStatus,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
      followRedirects: requestOptions.followRedirects,
      maxRedirects: requestOptions.maxRedirects,
      persistentConnection: requestOptions.persistentConnection,
      requestEncoder: requestOptions.requestEncoder,
      responseDecoder: requestOptions.responseDecoder,
      listFormat: requestOptions.listFormat,
    );

    return client.dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
