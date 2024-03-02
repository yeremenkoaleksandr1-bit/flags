import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/src/utils.dart';
import 'package:fast_equatable/fast_equatable.dart';
import 'package:memoize/memoize.dart';

import '../../shared/shared.dart';

class FilterOption {
  FilterOption({
    required this.value,
    required this.label,
    this.children,
  });

  final String value;
  final String label;
  final List<FilterOption>? children;

  List<FilterOption> flatten() {
    List<FilterOption> flatList = [];

    void traverse(FilterOption currentOption) {
      flatList.add(currentOption);

      if (currentOption.children != null) {
        for (var child in currentOption.children!) {
          traverse(child);
        }
      }
    }

    traverse(this);
    return flatList;
  }

  static TreeNode<FilterOption> nodeJsonJson(
    Map<String, dynamic> json, {
    TreeNode<FilterOption>? parent,
  }) {
    final node = TreeNode(
      parent: parent,
      item: FilterOption(
        value: json["value"],
        label: json["label"],
      ),
    );

    node.children.addAll(
      json['children'] != null
          ? List.of(json['children']).map(
              (e) => nodeJsonJson(e, parent: node),
            )
          : [],
    );

    return node;
  }

  factory FilterOption.fromJson(Map<String, dynamic> json) {
    return FilterOption(
      value: json["value"],
      label: json["label"],
      children: json['children'] != null
          ? [
              ...List.of(json['children']).map(
                (e) => FilterOption.fromJson(e),
              ),
            ]
          : null,
    );
  }
}

class FilterValues with FastEquatable {
  FilterValues({required Map<String, dynamic> data}) {
    final temp = {...data};
    temp.removeWhere(
      (key, value) {
        if (value is List) {
          return value.isEmpty;
        } else if (value is String) {
          return value.isEmpty;
        } else if (value == null) {
          return true;
        }

        return false;
      },
    );
    this.data = temp;
  }

  late final Map<String, dynamic> data;

  int _getNestedListLength(dynamic listOrValue) {
    if (listOrValue is List) {
      int length = 0;
      for (var item in listOrValue) {
        length += _getNestedListLength(item);
      }
      return length;
    } else {
      return 1;
    }
  }

  int get length => memo0<int>(() {
        int length = 0;

        for (final e in data.values) {
          length += _getNestedListLength(e);
        }

        return length;
      })();

  FilterValues clone() {
    return FilterValues(
      data: json.decode(
        json.encode(data),
      ),
    );
  }

  String toQuery() {
    return encodeMap(
      {...data.map((key, value) => MapEntry("filters[$key]", value))},
      (key, value) {
        if (value == null) return key;
        return '$key=$value';
      },
      listFormat: ListFormat.multiCompatible,
      isQuery: false,
      encode: false,
    );
  }

  @override
  bool get cacheHash => true;

  @override
  List<Object?> get hashParameters => [data];
}
