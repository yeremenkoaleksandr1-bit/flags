import 'package:armar/armar.dart';
import 'package:armar/form_builder/fields/search_field/theme/search_field.theme.dart';
import 'package:flutter/material.dart';

import '../drop_down_search_field/ar_dropdown_search.dart';
import '../drop_down_search_field/dropdown/src/widgets/search_field_configuration.dart';

typedef SearchItemBuilder<T> = Widget Function(
  BuildContext context,
  SelectOption<T> item,
  SelectOption<T>? selectedItem,
);

class ArSearchFieldBuilder<T> extends FormBuilderFieldDecoration<SelectOption<T>> {
  ArSearchFieldBuilder({
    super.key,
    required super.name,
    required this.onFetch,
    required this.buildItem,
    this.activeSuffixIcon = true,
    super.initialValue,
    super.decoration,
    super.enabled = true,
    super.onChanged,
    super.validator,
    this.errorBuilder,
    this.noItemsFoundBuilder,
    this.loadingBuilder,
    this.hideSuggestionsOnKeyboardHide = true,
    this.debounceDuration = const Duration(seconds: 1),
  }) : super(
          builder: (state) => Builder(
            builder: state.build,
          ),
        );

  final Future<List<SelectOption<T>>> Function(String value) onFetch;

  final SearchItemBuilder<T> buildItem;

  final bool activeSuffixIcon;

  final Widget Function(BuildContext, Object?)? errorBuilder;
  final Widget Function(BuildContext)? noItemsFoundBuilder;
  final Widget Function(BuildContext)? loadingBuilder;
  final Duration debounceDuration;
  final bool hideSuggestionsOnKeyboardHide;

  @override
  FormBuilderFieldDecorationState<ArSearchFieldBuilder<T>, SelectOption<T>>
      createState() => _CuSearchFieldState<T>();
}

class _CuSearchFieldState<T>
    extends FormBuilderFieldDecorationState<ArSearchFieldBuilder<T>, SelectOption<T>> {
  late final RxValue<SelectOption<T>?> _selectedItem = RxValue(null);

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      Get.engine.addPostFrameCallback((timeStamp) {
        _selectedItem.value = widget.initialValue;

        super.setValue(widget.initialValue);
      });
    }
  }

  void _onSelect(SelectOption<T> item) {
    super.setValue(item);
    super.validate();
    widget.onChanged?.call(item);
    _selectedItem.value = item;

    _textEditingController.clear();
  }

  void _clearItem() {
    super.setValue(null);
    super.validate();
    widget.onChanged?.call(null);
    _selectedItem.value = null;

    _textEditingController.clear();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ArSearchFieldTheme>()!;

    return FastBuilder(
      () {
        final suffix = widget.activeSuffixIcon
            ? _selectedItem.value != null
                ? IconButton(
                    onPressed: _clearItem,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  )
                : null
            : null;

        return ArDropDownSearchField<SelectOption<T>>(
          debounceDuration: widget.debounceDuration,
          hideSuggestionsOnKeyboardHide: widget.hideSuggestionsOnKeyboardHide,
          loadingBuilder: widget.loadingBuilder ?? (context) => buildLoading(),
          noItemsFoundBuilder:
              widget.noItemsFoundBuilder ?? (context) => buildNoResults(),
          //   hideKeyboardOnDrag: true,
          getImmediateSuggestions: false,
          errorBuilder: widget.errorBuilder ??
              (context, error) {
                return ArTextBodyMedium(error.toString());
              },
          textFieldConfiguration: TextFieldConfiguration(
            enabled: widget.enabled,
            controller: _textEditingController,
            decoration: InputDecoration(
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
                      ? theme.decoration!
                          .call(_selectedItem.value == null || !widget.enabled)
                      : null,
                )
                .merge(
                  widget.decoration.copyWith(
                    hintText: _selectedItem.value?.label ??
                        widget.decoration.hintText,
                    errorText: super.errorText,
                  ),
                ),
          ),
          suggestionsBoxDecoration: theme.suggestionsBoxDecoration,
          suggestionsCallback: widget.onFetch,
          itemBuilder: (BuildContext context, SelectOption<T> item) {
            return widget.buildItem(context, item, _selectedItem.value);
          },
          onSuggestionSelected: _onSelect,
          displayAllSuggestionWhenTap: true,
        );
      },
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
          "Немає результатів",
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
