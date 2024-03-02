import 'package:armar/api/api.dart';
import 'package:dio/dio.dart';

class ApiPaginatedListResponse<T> extends ApiResponse<ApiPaginatedListData<T>> {
  ApiPaginatedListResponse._(
    super.response, {
    super.dataKey,
    required super.dataFactory,
  }) : super(success: true);

  static Future<ApiPaginatedListResponse<T>> responseOf<T>({
    required Future<Response> fetch,
    required T Function(Map<String, dynamic> json) converter,
  }) async =>
      ApiPaginatedListResponse._(
        await fetch,
        dataFactory: converter,
      );

  @override
  ApiPaginatedListData<T> getData(ApiDataFactoryCallBack? dataFactory) {
    return ApiPaginatedListData(
      items: [
        ...List.of(response.data[dataKey]).map(
          (e) => dataFactory!(e),
        ),
      ],
      meta: ResponseMeta.fromJson(response.data['meta']),
    );
  }
}

class ApiPaginatedListData<T> extends ApiListData<T> {
  final ResponseMeta meta;

  ApiPaginatedListData({
    required super.items,
    required this.meta,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiPaginatedListData &&
          runtimeType == other.runtimeType &&
          meta == other.meta;

  @override
  int get hashCode => meta.hashCode;
}
