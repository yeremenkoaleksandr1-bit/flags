class DynamicResponse {
  final Map<String, dynamic> data;

  DynamicResponse({required this.data});

  @override
  factory DynamicResponse.fromJson(Map<String, dynamic> data) =>
      DynamicResponse(data: data);
}
