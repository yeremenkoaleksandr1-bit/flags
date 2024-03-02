import 'package:armar/api/api.dart';

import '../../../logger.dart';

class ErrorApiResponse extends ApiResponse<ResponseErrorData> {
  ErrorApiResponse(
    super.response,
  ) : super(success: false);

  @override
  ResponseErrorData getData(ApiDataFactoryCallBack? dataFactory) {
    var data = {};
    if (response.data is Map) {
      data = response.data;
    }


    return ResponseErrorData(
      statusCode: response.statusCode!,
      errors: data['errors'] ?? {},
      message: data['message'],
    );
  }
}

class ResponseErrorData {
  final int statusCode;
  final Map<String, dynamic> errors;

  final String? message;

  ResponseErrorData({
    required this.errors,
    this.message,
    required this.statusCode,
  });
}
