import 'dart:async';
import 'dart:math';

import 'package:armar/api/extensions/http_response_x.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../logger.dart';
import '../inspectors/inspectors.dart';
import 'responses/error.reponse.dart';

typedef ApiDataFactoryCallBack = dynamic Function(Map<String, dynamic> json);

abstract class ApiResponse<T> {
  ApiResponse(
    this.response, {
    this.dataKey = 'data',
    required this.success,
    ApiDataFactoryCallBack? dataFactory,
  }) : _dataFactory = dataFactory;

  final Response<dynamic> response;

  final String dataKey;

  final bool success;

  final ApiDataFactoryCallBack? _dataFactory;

  T getData(ApiDataFactoryCallBack? dataFactory);

  FutureOr<D?> where<D>({
    FutureOr<D> Function(T data)? onSuccess,
    FutureOr<D> Function(ResponseErrorData data)? onError,
  }) {
    try {
      if (response.isSuccessful && success) {
        return onSuccess?.call(getData(_dataFactory));
      } else {
        return onErrorWrapper<D>(response, onError);
      }
    } on DioException catch (e) {
      return onErrorWrapper<D>(e.response!, onError);
    }

    return null;
  }

  FutureOr<D?> onErrorWrapper<D>(
    Response<dynamic> response,
    FutureOr<D> Function(ResponseErrorData data)? onError,
  ) async {
    if (!kReleaseMode) {
      logger.d(
        "statusCode: ${response.statusCode}\n"
        "data: ${response.data}",
        error: response.realUri.toString(),
      );
    }
    return onError?.call(
      ErrorApiResponse(response).getData(_dataFactory),
    );
  }
}
