import 'package:armar/armar.dart';
import 'package:armar/form_builder/fields/search_field/theme/search_field.theme.dart';
import 'package:flutter/material.dart';

import '../../../logger.dart';
import '../drop_down_search_field/ar_dropdown_search.dart';
import '../drop_down_search_field/dropdown/src/widgets/search_field_configuration.dart';
import '../states/text_form_field.state.dart';

part 'search_field_item.dart';

class ArRemoteSearchFieldBuilder<R> extends ArFormBuilderField<R> {
  ArRemoteSearchFieldBuilder({
    super.key,
    this.initialValueData,
    required this.onFetch,
    this.decoration,
    super.validator,
    required super.name,
  }) : super(
          builder: (state) => Builder(
            builder: (context) => state.build(context),
          ),
        );

  final InputDecoration? decoration;

  final Future<List<SearchFieldItem<R>>> Function(String value) onFetch;

  final SearchFieldItem<R>? initialValueData;

  @override
  ArFormBuilderFieldState<ArRemoteSearchFieldBuilder<R>, R> createState() =>
      SearchFieldState<R>();
}

class SearchFieldState<R>
    extends ArFormBuilderFieldState<ArRemoteSearchFieldBuilder<R>, R> {
  final FocusNode _focusNode = FocusNode();

  late final RxValue<SearchFieldItem<R>?> _selectedItem =
      widget.initialValueData.rx;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    setValue(widget.initialValueData?.value);

    super.initState();
  }

  void _onSelect(SearchFieldItem<R> item) {
    widget.onChanged?.call((item.value));
    _selectedItem.value = item;
    setValue(item.value);
    _textEditingController.clear();
  }

  void _clearItem() {
    widget.onChanged?.call(null);
    _selectedItem.value = null;
    setValue(null);
    _textEditingController.clear();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void didChange(R? value) {
    if (value == null) {
      _clearItem();
    }
    super.didChange(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ArSearchFieldTheme>()!;

    return FastBuilder(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ArDropDownSearchField<SearchFieldItem<R>>(
            debounceDuration: const Duration(milliseconds: 1000),
            hideSuggestionsOnKeyboardHide: false,
            loadingBuilder: buildLoading,
            noItemsFoundBuilder: noItemsFoundBuilder,
            textFieldConfiguration: TextFieldConfiguration(
              controller: _textEditingController,
              decoration: buildInputDecoration(context, theme),
              focusNode: _focusNode,
            ),
            autoFlipDirection: true,
            autoFlipMinHeight: 32,
            getImmediateSuggestions: true,
            direction: AxisDirection.up,
            suggestionsBoxDecoration: theme.suggestionsBoxDecoration,
            suggestionsCallback: widget.onFetch,
            itemBuilder: buildListItem,
            onSuggestionSelected: _onSelect,
            displayAllSuggestionWhenTap: true,
          ),
          if (errorText != null)
            Text(
              errorText!,
              style: const TextStyle(color: Colors.red),
            )
        ],
      ),
    );
  }

  Widget buildLoading(context) => const SizedBox(
        height: 64,
        width: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );

  Widget buildListItem(BuildContext context, SearchFieldItem<R> suggestion) {
    return ListTile(
      title: Text(
        suggestion.title,
      ),
    );
  }

  InputDecoration buildInputDecoration(
      BuildContext context, ArSearchFieldTheme theme) {
    return InputDecoration(
      hintStyle: context.textTheme.bodyMedium!.copyWith(
        color: _selectedItem.value == null ? Colors.black : null,
      ),
      suffixIcon: _selectedItem.value != null
          ? IconButton(
              onPressed: _clearItem,
              icon: IconTheme(
                data: theme.closeIconTheme,
                child: Icon(
                  theme.closeIcon,
                ),
              ),
            )
          : null,
    )
        .merge(theme.decoration?.call(_selectedItem.value != null))
        .merge(widget.decoration)
        .copyWith(
          hintText: _selectedItem.value?.title,
        );
  }

  Widget noItemsFoundBuilder(context) => const SizedBox(
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
