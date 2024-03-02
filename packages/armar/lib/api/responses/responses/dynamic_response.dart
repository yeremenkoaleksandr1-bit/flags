import 'package:armar/api/api.dart';
import 'package:dio/dio.dart';

class ApiDynamicResponse extends ApiResponse<Map<String, dynamic>> {
  ApiDynamicResponse._(super.response) : super(success: true);

  static Future<ApiDynamicResponse> responseOf({
    required Future<Response> fetch,
  }) async =>
      ApiDynamicResponse._(await fetch);

  @override
  Map<String, dynamic> getData(ApiDataFactoryCallBack? dataFactory) {
    return response.data;
  }
}
