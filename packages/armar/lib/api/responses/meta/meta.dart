part 'page_meta.dart';

class ResponseMeta {
  ResponseMeta({
    required this.limit,
    required this.total,
    required this.page,
  });

  final ResponsePageMeta page;

  final int limit;
  final int total;

  @override
  String toString() {
    return 'ResponseMeta{page: $page, limit: $limit, total: $total}';
  }

  factory ResponseMeta.fromJson(Map<String, dynamic> json) {
    return ResponseMeta(
      page: ResponsePageMeta.fromJson(json["page"]),
      limit: json["limit"],
      total: json["total"],
    );
  }
}

class ResponseWithMeta<T> {
  ResponseWithMeta({
    required this.data,
    required this.meta,
  });

  final List<T> data;
  final ResponseMeta meta;

  factory ResponseWithMeta.fromJson(
    Map<String, dynamic> json, {
    required T Function(Map<String, dynamic> json) dataBuilder,
    String dataKey = 'data',
  }) {
    return ResponseWithMeta<T>(
      data: [
        ...List.of(json[dataKey]).map(
          (e) => dataBuilder(e),
        ),
      ],
      meta: ResponseMeta.fromJson(json['meta']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseWithMeta &&
          runtimeType == other.runtimeType &&
          data == other.data &&
          meta == other.meta;

  @override
  int get hashCode => data.hashCode ^ meta.hashCode;
}
