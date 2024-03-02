import 'package:armar/armar.dart';

class RequestsInspector extends QueuedInterceptorsWrapper {
  final void Function(DioException, ErrorInterceptorHandler)? onErrorHandle;
  final void Function(RequestOptions, RequestInterceptorHandler)?
      onRequestHandle;
  final void Function(Response<dynamic>, ResponseInterceptorHandler)?
      onResponseHandle;

  RequestsInspector({
    this.onErrorHandle,
    this.onRequestHandle,
    this.onResponseHandle,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    onErrorHandle?.call(err, handler);
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    onRequestHandle?.call(options, handler);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    onResponseHandle?.call(response, handler);
    super.onResponse(response, handler);
  }
}
