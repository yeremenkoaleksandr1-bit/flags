import 'dart:async';

import 'package:armar/api/api.dart';
import 'package:dio/dio.dart';

class ApiDataResponse<T> extends ApiResponse<T> {
  ApiDataResponse._(
    super.response, {
    required super.dataFactory,
    super.dataKey,
  }) : super(success: true);

  static Future<ApiDataResponse<T>> responseOf<T>({
    required Future<Response> fetch,
    required T Function(Map<String, dynamic> json) converter,
  }) async =>
      ApiDataResponse._(
        await fetch,
        dataFactory: converter,
      );

  @override
  T getData(ApiDataFactoryCallBack? dataFactory) => dataFactory!(response.data[dataKey]);
}
