import '../../../armar.dart';

class ApiListResponse<T> extends ApiResponse<ApiListData<T>> {
  ApiListResponse._(
    super.response, {
    required super.dataFactory,
    super.dataKey,
  }) : super(success: true);

  static Future<ApiListResponse<T>> responseOf<T>({
    required Future<Response> fetch,
    required T Function(Map<String, dynamic> json) converter,
  }) async =>
      ApiListResponse._(
        await fetch,
        dataFactory: converter,
      );

  @override
  ApiListData<T> getData(ApiDataFactoryCallBack? dataFactory) {
    return ApiListData(
      items: [
        ...List.of(response.data[dataKey]).map(
          (e) => dataFactory!(e),
        ),
      ],
    );
  }
}

class ApiListData<T> {
  final List<T> items;

  ApiListData({required this.items});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiListData &&
          runtimeType == other.runtimeType &&
          items == other.items;

  @override
  int get hashCode => items.hashCode;
}
