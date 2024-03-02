// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart' hide Headers;

// ignore: depend_on_referenced_packages
import 'package:retrofit/retrofit.dart';

import '../responses/api_responses.dart';

enum RequestMethods {
  GET,
  POST,
  PUT,
  PATCH,
  DELETE,
  HEAD,
  OPTIONS,
}

extension DioX on Dio {
  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }

  Future<Response> fetchApi({
    required String path,
    required RequestMethods method,
    //
    dynamic data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    String? baseUrl,
    String? contentType,
  }) async {
    RequestMethods effectiveMethod = method;

    if (method == RequestMethods.PUT) {
      if (data is FormData) {
        data.fields.add(const MapEntry("_method", "PUT"));
        effectiveMethod = RequestMethods.POST;
      }
    }

    final effectiveOptions = Options(
      method: effectiveMethod.name,
      headers: headers,
      sendTimeout: sendTimeout,
      receiveTimeout: receiveTimeout,
      followRedirects: false,
    )
        .compose(
          options.copyWith(contentType: contentType),
          path,
          data: data,
          queryParameters: query,
        )
        .copyWith(
          baseUrl: _combineBaseUrls(
            options.baseUrl,
            baseUrl,
          ),
        );
    Response? response;

    try {
      response = await fetch(effectiveOptions);
    } on DioException catch (e) {
      response = e.response;
    }

    return response!;
  }

  Future<HttpResponse> fetchHttp({
    required String path,
    required RequestMethods method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    Duration? sendTimeout,
    Duration? receiveTimeout,
  }) async {
    final response = await fetch<dynamic>(
      Options(
        method: method.name,
        headers: headers,
        sendTimeout: sendTimeout,
        receiveTimeout: receiveTimeout,
      ).compose(
        options,
        path,
        data: data,
        queryParameters: query,
      ),
    );

    return HttpResponse(response.data, response);
  }
}
