import 'package:armar/armar.dart';
import 'package:armar/form_builder/fields/search_field/theme/search_field.theme.dart';
import 'package:armar/rx/rx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:widget_finder/widget_finder.dart';

import '../../../logger.dart';
import '../drop_down_search_field/ar_dropdown_search.dart';
import '../drop_down_search_field/dropdown/drop_down_search_field.dart';

class ArLocalSearchFieldBuilder<R> extends FormBuilderFieldDecoration<String> {
  ArLocalSearchFieldBuilder({
    super.key,
    required this.items,
    required this.titleBy,
    required this.valueBy,
    super.onChanged,
    this.onChangedValue,
    super.decoration,
    super.validator,
    required super.name,
    super.initialValue,
  }) : super(builder: (state) => Builder(builder: state.build));

  final List<R> items;

  final String Function(R item) titleBy;
  final String Function(R item) valueBy;

  final ValueChanged<R?>? onChangedValue;

  @override
  FormBuilderFieldDecorationState<ArLocalSearchFieldBuilder<R>, String>
      createState() => SearchLocalFieldState<R>();
}

class SearchLocalFieldState<R> extends FormBuilderFieldDecorationState<
    ArLocalSearchFieldBuilder<R>, String> with WidgetsBindingObserver {
  final GlobalKey _key = GlobalKey();

  final List<R> _items = [];

  late final RxValue<R?> _selectedItem;

  final TextEditingController _textEditingController = TextEditingController();

  String _titleBy(R value) => widget.titleBy(value);

  String _valueBy(R value) => widget.valueBy(value);

  final SuggestionsBoxController _suggestionsBoxController =
      SuggestionsBoxController();

  @override
  void initState() {
    _items.addAll(widget.items);

    _selectedItem = (widget.initialValue != null
            ? _items.firstWhere(
                (e) => _valueBy(e) == widget.initialValue,
              )
            : null)
        .rx;

    setValue(widget.initialValue);
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }

  void _onSelect(R item) {
    widget.onChangedValue?.call(item);
    widget.onChanged?.call((_valueBy(item)));
    _selectedItem.value = item;
    setValue(_valueBy(item));
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
    _suggestionsBoxController.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ArLocalSearchFieldBuilder<R> oldWidget) {
    if(oldWidget.items != widget.items){
      _items.clear();
      _items.addAll(widget.items);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChange(String? value) {
    if (value == null) {
      _clearItem();
    }
    super.didChange(value);
  }

  Future<Iterable<R>> filterSuggestions(String value) async {
    return _items.where(
      (e) => _titleBy(e).toLowerCase().contains(
            value.toLowerCase(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ArSearchFieldTheme>()!;

    Widget child = LayoutBuilder(
      key: _key,
      builder: (BuildContext context, BoxConstraints constraints) {
        return FastValueBuilder(
          listen: _selectedItem,
          builder: (R? value) {
            return ArDropDownSearchField<R>(
              suggestionsBoxController: _suggestionsBoxController,
              intercepting: true,
              actionWhenSuggestionsStartOpening: () async {
                // _scrollController.position.correctPixels(_scrollController.position.pixels);
                // final RenderBox renderBox =
                // _key.currentContext!.findRenderObject() as RenderBox;
                // _offset = renderBox.localToGlobal(Offset.zero);
                // await _scrollController.animateTo(
                //   _offset.dy,
                //   duration: const Duration(milliseconds: 250),
                //   curve: Curves.linear,
                // );
              },
              debounceDuration: const Duration(milliseconds: 1000),
              hideSuggestionsOnKeyboardHide: true,
              loadingBuilder: (context) => const SizedBox(
                height: 64,
                width: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              noItemsFoundBuilder: (context) => const SizedBox(
                height: 64,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "Немає результатів",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              textFieldConfiguration: TextFieldConfiguration(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintStyle: context.textTheme.bodyMedium!.copyWith(
                    color: value == null ? Colors.black : null,
                  ),
                  suffixIcon: value != null
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
                    .merge(widget.decoration)
                    .merge(theme.decoration?.call(value != null))
                    .copyWith(
                      hintText: value != null ? _titleBy(value) : null,
                    ),
              ),
              suggestionsBoxDecoration: theme.suggestionsBoxDecoration,
              suggestionsCallback: filterSuggestions,
              itemBuilder: (BuildContext context, R suggestion) {
                return ListTile(
                  title: Text(_titleBy(suggestion)),
                );
              },
              onSuggestionSelected: _onSelect,
              displayAllSuggestionWhenTap: false,
            );
          },
        );
      },
    );

    return RepaintBoundary(child: child);
  }
}
