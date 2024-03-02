import 'package:armar/armar.dart';
import 'package:armar/form_builder/fields/search_field/theme/search_field.theme.dart';
import 'package:flutter/material.dart';

import '../../../logger.dart';
import '../drop_down_search_field/ar_dropdown_search.dart';
import '../drop_down_search_field/dropdown/src/widgets/search_field_configuration.dart';

typedef LocalSearchItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  T? selectedItem,
);

class ArSearchField<T> extends StatefulWidget {
  const ArSearchField({
    super.key,
    required this.items,
    required this.titleBy,
    required this.valueBy,
    required this.decoration,
    this.initialValue,
    required this.onChanged,
    this.errorBuilder,
    this.noItemsFoundBuilder,
    this.loadingBuilder,
    this.debounceDuration = const Duration(seconds: 1),
    this.hideSuggestionsOnKeyboardHide = true,
    required this.buildItem,
    this.activeSuffixIcon = true,
    this.enabled = true,
  });

  final List<T> items;

  final T? initialValue;

  final bool enabled;

  final String Function(T item) titleBy;
  final String Function(T item) valueBy;

  final LocalSearchItemBuilder<T> buildItem;
  final bool activeSuffixIcon;
  final InputDecoration Function(bool hasChoose)? decoration;

  final void Function(String? value) onChanged;

  final Widget Function(BuildContext, Object?)? errorBuilder;
  final Widget Function(BuildContext)? noItemsFoundBuilder;
  final Widget Function(BuildContext)? loadingBuilder;
  final Duration debounceDuration;
  final bool hideSuggestionsOnKeyboardHide;

  @override
  State<ArSearchField> createState() => ArLocalSearchFieldState<T>();
}

class ArLocalSearchFieldState<T> extends State<ArSearchField<T>> {
  late final RxValue<T?> _selectedItem;

  final TextEditingController _textEditingController = TextEditingController();

  String _titleBy(T value) => widget.titleBy(value);

  String _valueBy(T value) => widget.valueBy(value);

  @override
  void initState() {
    _selectedItem = (widget.initialValue ?? widget.items.first).rx;

    super.initState();
  }

  void _onSelect(T item) {
    widget.onChanged((_valueBy(item)));
    _selectedItem.value = item;

    _textEditingController.clear();
  }

  void _clearItem() {
    widget.onChanged(null);
    _selectedItem.value = null;
    _textEditingController.clear();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<Iterable<T>> filterSuggestions(String value) async {
    return widget.items.where(
      (e) => _titleBy(e).toLowerCase().contains(
            value.toLowerCase(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ArSearchFieldTheme>()!;

    return FastBuilder(
      () {
        final hasChoose = _selectedItem.value != null;
        final decoration = widget.decoration?.call(hasChoose);

        final suffix = widget.activeSuffixIcon
            ? hasChoose
                ? IconButton(
                    onPressed: _clearItem,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  )
                : null
            : null;

        return ArDropDownSearchField<T>(
          debounceDuration: widget.debounceDuration,
          hideSuggestionsOnKeyboardHide: widget.hideSuggestionsOnKeyboardHide,
          loadingBuilder: widget.loadingBuilder ?? (context) => buildLoading(),
          noItemsFoundBuilder:
              widget.noItemsFoundBuilder ?? (context) => buildNoResults(),
          //   hideKeyboardOnDrag: true,

          errorBuilder: widget.errorBuilder ??
              (context, error) {
                return ArTextBodyMedium(error.toString());
              },
          textFieldConfiguration: TextFieldConfiguration(
            enabled: widget.enabled,
            controller: _textEditingController,
            decoration: buildInputDecoration(
                context, suffix, theme, hasChoose, decoration),
          ),
          suggestionsBoxDecoration: theme.suggestionsBoxDecoration,
          suggestionsCallback: filterSuggestions,
          itemBuilder: (BuildContext context, T item) {
            return widget.buildItem(context, item, _selectedItem.value);
          },
          onSuggestionSelected: _onSelect,
          autoFlipDirection: true,
          autoFlipMinHeight: 32,

          getImmediateSuggestions: false,
          displayAllSuggestionWhenTap: true,
        );
      },
    );
  }

  InputDecoration buildInputDecoration(
    BuildContext context,
    IconButton? suffix,
    ArSearchFieldTheme theme,
    bool hasChoose,
    InputDecoration? decoration,
  ) {
    return InputDecoration(
      hintStyle: context.textTheme.bodyMedium!.copyWith(
        color: _selectedItem.value == null || !widget.enabled
            ? Colors.black
            : null,
      ),
      suffixIcon: suffix,
    )
        .merge(
          // ignore: prefer_null_aware_operators
          theme.decoration != null
              ? theme.decoration!.call(hasChoose || !widget.enabled)
              : null,
        )
        .merge(
          decoration?.copyWith(
            hintText: _selectedItem.value != null
                ? _titleBy(_selectedItem.value as T)
                : decoration.hintText,
          ),
        );
  }

  Widget buildLoading() {
    return const SizedBox(
      height: 64,
      width: double.infinity,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildNoResults() {
    return const SizedBox(
      height: 64,
      width: double.infinity,
      child: Center(
        child: Text(
          "No results",
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
