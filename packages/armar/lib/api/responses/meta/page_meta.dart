part of 'meta.dart';

class ResponsePageMeta {
  ResponsePageMeta({
    required this.current,
    required this.total,
  });

  final int current;
  final int total;

  factory ResponsePageMeta.fromJson(Map<String, dynamic> json) {
    return ResponsePageMeta(
      current: json["current"],
      total: json["total"],
    );
  }

  @override
  String toString() {
    return 'ResponsePageMeta{current: $current, total: $total}';
  }
}
