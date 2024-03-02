import 'package:armar/api/api.dart';
import 'package:dio/dio.dart';

class ApiPaginatedResponse<T> extends ApiResponse<ApiPaginatedData<T>> {
  ApiPaginatedResponse._(
    super.response, {
    super.dataKey,
    required super.dataFactory,
  }) : super(success: true);

  static Future<ApiPaginatedResponse<T>> responseOf<T>({
    required Future<Response> fetch,
    required T Function(Map<String, dynamic> json) converter,
  }) async =>
      ApiPaginatedResponse._(
        await fetch,
        dataFactory: converter,
      );

  @override
  ApiPaginatedData<T> getData(ApiDataFactoryCallBack? dataFactory) {
    return ApiPaginatedData(
      data: dataFactory!.call(response.data[dataKey]),
      meta: ResponseMeta.fromJson(response.data['meta']),
    );
  }
}

class ApiPaginatedData<T> {
  final T data;
  final ResponseMeta meta;

  ApiPaginatedData({
    required this.data,
    required this.meta,
  });
}
