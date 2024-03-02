import 'package:armar/api/api.dart';
import 'package:dio/dio.dart';

import '../../logger.dart';

class CookieInspector extends Interceptor  {

  final _client = IApiClient.get;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _client.setArCookies(_client.getSetResponseCookies(response)!);
    logger.w("[TEST]");
    super.onResponse(response, handler);
  }
}