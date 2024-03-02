library dropdown_search;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/properties/clear_button_props.dart';
import 'src/properties/dropdown_button_props.dart';
import 'src/properties/dropdown_decorator_props.dart';
import 'src/properties/popup_props.dart';
import 'src/widgets/popup_menu.dart';
import 'src/widgets/selection_widget.dart';

export 'src/properties/bottom_sheet_props.dart';
export 'src/properties/clear_button_props.dart';
export 'src/properties/dialog_props.dart';
export 'src/properties/dropdown_button_props.dart';
export 'src/properties/dropdown_decorator_props.dart';
export 'src/properties/favorite_item_props.dart';
export 'src/properties/icon_button_props.dart';
export 'src/properties/list_view_props.dart';
export 'src/properties/menu_props.dart';
export 'src/properties/modal_bottom_sheet_props.dart';
export 'src/properties/popup_props.dart';
export 'src/properties/scrollbar_props.dart';
export 'src/properties/text_field_props.dart';

typedef DropdownSearchOnFind<T> = Future<List<T>> Function(String text);
typedef DropdownSearchItemAsString<T> = String Function(T item);
typedef DropdownSearchFilterFn<T> = bool Function(T item, String filter);
typedef DropdownSearchCompareFn<T> = bool Function(T item1, T item2);
typedef DropdownSearchBuilder<T> = Widget Function(
    BuildContext context, T? selectedItem);
typedef DropdownSearchBuilderMultiSelection<T> = Widget Function(
  BuildContext context,
  List<T> selectedItems,
);
typedef DropdownSearchPopupItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  bool isSelected,
);
typedef DropdownSearchPopupItemEnabled<T> = bool Function(T item);
typedef ErrorBuilder<T> = Widget Function(
  BuildContext context,
  String searchEntry,
  dynamic exception,
);
typedef EmptyBuilder<T> = Widget Function(
    BuildContext context, String searchEntry);
typedef LoadingBuilder<T> = Widget Function(
    BuildContext context, String searchEntry);
typedef BeforeChange<T> = Future<bool?> Function(T? prevItem, T? nextItem);
typedef BeforePopupOpening<T> = Future<bool?> Function(T? selectedItem);
typedef BeforePopupOpeningMultiSelection<T> = Future<bool?> Function(
    List<T> selItems);
typedef BeforeChangeMultiSelection<T> = Future<bool?> Function(
  List<T> prevItems,
  List<T> nextItems,
);
typedef FavoriteItemsBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  bool isSelected,
);
typedef ValidationMultiSelectionBuilder<T> = Widget Function(
  BuildContext context,
  List<T> item,
);

typedef PositionCallback = RelativeRect Function(
  RenderBox popupButtonObject,
  RenderBox overlay,
);

typedef OnItemAdded<T> = void Function(List<T> selectedItems, T addedItem);
typedef OnItemRemoved<T> = void Function(List<T> selectedItems, T removedItem);
typedef PopupBuilder = Widget Function(
    BuildContext context, Widget popupWidget);

typedef FavoriteItems<T> = List<T> Function(List<T> items);

enum Mode { dialog, modalBottomSheet, menu, bottomSheet }

class DropdownSearch<T> extends StatefulWidget {
  final List<T> items;

  final T? selectedItem;

  final List<T> selectedItems;

  final DropdownSearchOnFind<T>? asyncItems;

  final ValueChanged<T?>? onChanged;

  final ValueChanged<List<T>>? onChangedMultiSelection;

  final DropdownSearchBuilder<T>? dropdownBuilder;

  final DropdownSearchBuilderMultiSelection<T>? dropdownBuilderMultiSelection;

  final DropdownSearchItemAsString<T>? itemAsString;

  final DropdownSearchFilterFn<T>? filterFn;

  final bool enabled;

  final DropdownSearchCompareFn<T>? compareFn;

  final AutovalidateMode? autoValidateMode;

  final FormFieldSetter<T>? onSaved;

  final FormFieldSetter<List<T>>? onSavedMultiSelection;

  final FormFieldValidator<T>? validator;

  final FormFieldValidator<List<T>>? validatorMultiSelection;

  final BeforeChange<T>? onBeforeChange;

  final BeforeChangeMultiSelection<T>? onBeforeChangeMultiSelection;

  final bool isMultiSelectionMode;

  final ClearButtonProps clearButtonProps;

  final DropdownButtonProps dropdownButtonProps;

  final PopupPropsMultiSelection<T> popupProps;

  final DropDownDecoratorProps dropdownDecoratorProps;

  final BeforePopupOpening<T>? onBeforePopupOpening;

  final BeforePopupOpeningMultiSelection<T>? onBeforePopupOpeningMultiSelection;

  DropdownSearch({
    Key? key,
    this.onSaved,
    this.validator,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.items = const [],
    this.selectedItem,
    this.asyncItems,
    this.dropdownBuilder,
    this.dropdownDecoratorProps = const DropDownDecoratorProps(),
    this.clearButtonProps = const ClearButtonProps(),
    this.dropdownButtonProps = const DropdownButtonProps(),
    this.enabled = true,
    this.filterFn,
    this.itemAsString,
    this.compareFn,
    this.onBeforeChange,
    this.onBeforePopupOpening,
    PopupProps<T> popupProps = const PopupProps.menu(),
  })  : assert(
          !popupProps.showSelectedItems || T == String || compareFn != null,
        ),
        popupProps = PopupPropsMultiSelection.from(popupProps),
        isMultiSelectionMode = false,
        dropdownBuilderMultiSelection = null,
        validatorMultiSelection = null,
        onBeforeChangeMultiSelection = null,
        selectedItems = const [],
        onSavedMultiSelection = null,
        onChangedMultiSelection = null,
        onBeforePopupOpeningMultiSelection = null,
        super(key: key);

  DropdownSearch.multiSelection({
    Key? key,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.items = const [],
    this.asyncItems,
    this.dropdownDecoratorProps = const DropDownDecoratorProps(),
    this.clearButtonProps = const ClearButtonProps(),
    this.dropdownButtonProps = const DropdownButtonProps(),
    this.enabled = true,
    this.filterFn,
    this.itemAsString,
    this.compareFn,
    this.selectedItems = const [],
    this.popupProps = const PopupPropsMultiSelection.menu(),
    FormFieldSetter<List<T>>? onSaved,
    ValueChanged<List<T>>? onChanged,
    BeforeChangeMultiSelection<T>? onBeforeChange,
    BeforePopupOpeningMultiSelection<T>? onBeforePopupOpening,
    FormFieldValidator<List<T>>? validator,
    DropdownSearchBuilderMultiSelection<T>? dropdownBuilder,
  })  : assert(
          !popupProps.showSelectedItems || T == String || compareFn != null,
        ),
        onChangedMultiSelection = onChanged,
        onBeforePopupOpeningMultiSelection = onBeforePopupOpening,
        onSavedMultiSelection = onSaved,
        onBeforeChangeMultiSelection = onBeforeChange,
        validatorMultiSelection = validator,
        dropdownBuilderMultiSelection = dropdownBuilder,
        isMultiSelectionMode = true,
        dropdownBuilder = null,
        validator = null,
        onBeforeChange = null,
        selectedItem = null,
        onSaved = null,
        onChanged = null,
        onBeforePopupOpening = null,
        super(key: key);

  @override
  DropdownSearchState<T> createState() => DropdownSearchState<T>();
}

class DropdownSearchState<T> extends State<DropdownSearch<T>> {
  final ValueNotifier<List<T>> _selectedItemsNotifier = ValueNotifier([]);
  final ValueNotifier<bool> _isFocused = ValueNotifier(false);
  final _popupStateKey = GlobalKey<SelectionWidgetState<T>>();

  @override
  void initState() {
    super.initState();
    _selectedItemsNotifier.value = isMultiSelectionMode
        ? List.from(widget.selectedItems)
        : _itemToList(widget.selectedItem);
  }

  @override
  void didUpdateWidget(DropdownSearch<T> oldWidget) {
    List<T> oldSelectedItems = isMultiSelectionMode
        ? oldWidget.selectedItems
        : _itemToList(oldWidget.selectedItem);

    List<T> newSelectedItems = isMultiSelectionMode
        ? widget.selectedItems
        : _itemToList(widget.selectedItem);

    if (!listEquals(oldSelectedItems, newSelectedItems)) {
      _selectedItemsNotifier.value = List.from(newSelectedItems);
    }

    ///this code check if we need to refresh the popup widget to update
    ///containerBuilder widget
    if (widget.popupProps.containerBuilder !=
        oldWidget.popupProps.containerBuilder) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _popupStateKey.currentState?.setState(() {});
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T?>>(
      valueListenable: _selectedItemsNotifier,
      builder: (context, data, wt) {
        return IgnorePointer(
          ignoring: !widget.enabled,
          child: InkWell(
            onTap: () => _selectSearchMode(),
            child: _formField(),
          ),
        );
      },
    );
  }

  List<T> _itemToList(T? item) {
    List<T?> nullableList = List.filled(1, item);
    return nullableList.whereType<T>().toList();
  }

  Widget _defaultSelectedItemWidget() {
    Widget defaultItemMultiSelectionMode(T item) {
      return Container(
        height: 32,
        padding: const EdgeInsets.only(left: 8, right: 1),
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColorLight,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                _selectedItemAsString(item),
                style: Theme.of(context).textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            MaterialButton(
              height: 20,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(0),
              minWidth: 20,
              onPressed: () {
                removeItem(item);
              },
              child: const Icon(
                Icons.close_outlined,
                size: 20,
              ),
            )
          ],
        ),
      );
    }

    Widget selectedItemWidget() {
      if (widget.dropdownBuilder != null) {
        return widget.dropdownBuilder!(
          context,
          getSelectedItem,
        );
      } else if (widget.dropdownBuilderMultiSelection != null) {
        return widget.dropdownBuilderMultiSelection!(
          context,
          getSelectedItems,
        );
      } else if (isMultiSelectionMode) {
        return Wrap(
          children: getSelectedItems
              .map((e) => defaultItemMultiSelectionMode(e))
              .toList(),
        );
      }
      return Text(
        _selectedItemAsString(getSelectedItem),
        style: widget.dropdownDecoratorProps.baseStyle,
        textAlign: widget.dropdownDecoratorProps.textAlign,
      );
    }

    return selectedItemWidget();
  }

  Widget _formField() {
    return isMultiSelectionMode
        ? _formFieldMultiSelection()
        : _formFieldSingleSelection();
  }

  Widget _formFieldSingleSelection() {
    return FormField<T>(
      enabled: widget.enabled,
      onSaved: widget.onSaved,
      validator: widget.validator,
      autovalidateMode: widget.autoValidateMode,
      initialValue: widget.selectedItem,
      builder: (FormFieldState<T> state) {
        if (state.value != getSelectedItem) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              state.didChange(getSelectedItem);
            }
          });
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _isFocused,
            builder: (context, isFocused, w) {
              return InputDecorator(
                baseStyle: widget.dropdownDecoratorProps.baseStyle,
                textAlign: widget.dropdownDecoratorProps.textAlign,
                textAlignVertical:
                    widget.dropdownDecoratorProps.textAlignVertical,
                isEmpty:
                    getSelectedItem == null && widget.dropdownBuilder == null,
                isFocused: isFocused,
                decoration: _manageDropdownDecoration(state),
                child: _defaultSelectedItemWidget(),
              );
            });
      },
    );
  }

  Widget _formFieldMultiSelection() {
    return FormField<List<T>>(
      enabled: widget.enabled,
      onSaved: widget.onSavedMultiSelection,
      validator: widget.validatorMultiSelection,
      autovalidateMode: widget.autoValidateMode,
      initialValue: widget.selectedItems,
      builder: (FormFieldState<List<T>> state) {
        if (state.value != getSelectedItems) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              state.didChange(getSelectedItems);
            }
          });
        }
        return ValueListenableBuilder<bool>(
            valueListenable: _isFocused,
            builder: (context, isFocused, w) {
              return InputDecorator(
                baseStyle: widget.dropdownDecoratorProps.baseStyle,
                textAlign: widget.dropdownDecoratorProps.textAlign,
                textAlignVertical:
                    widget.dropdownDecoratorProps.textAlignVertical,
                isEmpty: getSelectedItems.isEmpty &&
                    widget.dropdownBuilderMultiSelection == null,
                isFocused: isFocused,
                decoration: _manageDropdownDecoration(state),
                child: _defaultSelectedItemWidget(),
              );
            });
      },
    );
  }

  ///manage dropdownSearch field decoration
  InputDecoration _manageDropdownDecoration(FormFieldState state) {
    return (widget.dropdownDecoratorProps.dropdownSearchDecoration ??
            const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
              border: OutlineInputBorder(),
            ))
        .applyDefaults(Theme.of(state.context).inputDecorationTheme)
        .copyWith(
          enabled: widget.enabled,
          suffixIcon: _manageSuffixIcons(),
          errorText: state.errorText,
        );
  }

  ///function that return the String value of an object
  String _selectedItemAsString(T? data) {
    if (data == null) {
      return "";
    } else if (widget.itemAsString != null) {
      return widget.itemAsString!(data);
    } else {
      return data.toString();
    }
  }

  ///function that manage Trailing icons(close, dropDown)
  Widget _manageSuffixIcons() {
    clearButtonPressed() => clear();
    dropdownButtonPressed() => _selectSearchMode();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        if (widget.clearButtonProps.isVisible && getSelectedItems.isNotEmpty)
          IconButton(
            style: widget.clearButtonProps.style,
            isSelected: widget.clearButtonProps.isSelected,
            selectedIcon: widget.clearButtonProps.selectedIcon,
            onPressed: widget.clearButtonProps.onPressed ?? clearButtonPressed,
            icon: widget.clearButtonProps.icon,
            constraints: widget.clearButtonProps.constraints,
            hoverColor: widget.clearButtonProps.hoverColor,
            highlightColor: widget.clearButtonProps.highlightColor,
            splashColor: widget.clearButtonProps.splashColor,
            color: widget.clearButtonProps.color,
            focusColor: widget.clearButtonProps.focusColor,
            iconSize: widget.clearButtonProps.iconSize,
            padding: widget.clearButtonProps.padding,
            splashRadius: widget.clearButtonProps.splashRadius,
            alignment: widget.clearButtonProps.alignment,
            autofocus: widget.clearButtonProps.autofocus,
            disabledColor: widget.clearButtonProps.disabledColor,
            enableFeedback: widget.clearButtonProps.enableFeedback,
            focusNode: widget.clearButtonProps.focusNode,
            mouseCursor: widget.clearButtonProps.mouseCursor,
            tooltip: widget.clearButtonProps.tooltip,
            visualDensity: widget.clearButtonProps.visualDensity,
          ),
        if (widget.dropdownButtonProps.isVisible)
          IconButton(
            style: widget.dropdownButtonProps.style,
            isSelected: widget.dropdownButtonProps.isSelected,
            selectedIcon: widget.dropdownButtonProps.selectedIcon,
            onPressed:
                widget.dropdownButtonProps.onPressed ?? dropdownButtonPressed,
            icon: widget.dropdownButtonProps.icon,
            constraints: widget.dropdownButtonProps.constraints,
            hoverColor: widget.dropdownButtonProps.hoverColor,
            highlightColor: widget.dropdownButtonProps.highlightColor,
            splashColor: widget.dropdownButtonProps.splashColor,
            color: widget.dropdownButtonProps.color,
            focusColor: widget.dropdownButtonProps.focusColor,
            iconSize: widget.dropdownButtonProps.iconSize,
            padding: widget.dropdownButtonProps.padding,
            splashRadius: widget.dropdownButtonProps.splashRadius,
            alignment: widget.dropdownButtonProps.alignment,
            autofocus: widget.dropdownButtonProps.autofocus,
            disabledColor: widget.dropdownButtonProps.disabledColor,
            enableFeedback: widget.dropdownButtonProps.enableFeedback,
            focusNode: widget.dropdownButtonProps.focusNode,
            mouseCursor: widget.dropdownButtonProps.mouseCursor,
            tooltip: widget.dropdownButtonProps.tooltip,
            visualDensity: widget.dropdownButtonProps.visualDensity,
          ),
      ],
    );
  }

  RelativeRect _position(RenderBox popupButtonObject, RenderBox overlay) {
    // Calculate the show-up area for the dropdown using button's size & position based on the `overlay` used as the coordinate space.
    return RelativeRect.fromSize(
      Rect.fromPoints(
        popupButtonObject.localToGlobal(
          popupButtonObject.size.bottomLeft(Offset.zero),
          ancestor: overlay,
        ),
        popupButtonObject.localToGlobal(
          popupButtonObject.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Size(overlay.size.width, overlay.size.height),
    );
  }

  ///open dialog
  Future _openSelectDialog() {
    return showGeneralDialog(
      context: context,
      barrierDismissible: widget.popupProps.dialogProps.barrierDismissible,
      barrierLabel: widget.popupProps.dialogProps.barrierLabel,
      transitionDuration: widget.popupProps.dialogProps.transitionDuration,
      barrierColor:
          widget.popupProps.dialogProps.barrierColor ?? Colors.black54,
      useRootNavigator: widget.popupProps.dialogProps.useRootNavigator,
      anchorPoint: widget.popupProps.dialogProps.anchorPoint,
      transitionBuilder: widget.popupProps.dialogProps.transitionBuilder,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          buttonPadding: widget.popupProps.dialogProps.buttonPadding,
          actionsOverflowButtonSpacing:
              widget.popupProps.dialogProps.actionsOverflowButtonSpacing,
          insetPadding: widget.popupProps.dialogProps.insetPadding,
          actionsPadding: widget.popupProps.dialogProps.actionsPadding,
          actionsOverflowDirection:
              widget.popupProps.dialogProps.actionsOverflowDirection,
          actionsOverflowAlignment:
              widget.popupProps.dialogProps.actionsOverflowAlignment,
          actionsAlignment: widget.popupProps.dialogProps.actionsAlignment,
          actions: widget.popupProps.dialogProps.actions,
          alignment: widget.popupProps.dialogProps.alignment,
          clipBehavior: widget.popupProps.dialogProps.clipBehavior,
          elevation: widget.popupProps.dialogProps.elevation,
          contentPadding: widget.popupProps.dialogProps.contentPadding,
          shape: widget.popupProps.dialogProps.shape,
          backgroundColor: widget.popupProps.dialogProps.backgroundColor,
          semanticLabel: widget.popupProps.dialogProps.semanticLabel,
          content: _popupWidgetInstance(),
        );
      },
    );
  }

  Future _openBottomSheet() {
    return showBottomSheet(
      context: context,
      enableDrag: widget.popupProps.bottomSheetProps.enableDrag,
      backgroundColor: widget.popupProps.bottomSheetProps.backgroundColor,
      clipBehavior: widget.popupProps.bottomSheetProps.clipBehavior,
      elevation: widget.popupProps.bottomSheetProps.elevation,
      shape: widget.popupProps.bottomSheetProps.shape,
      transitionAnimationController:
          widget.popupProps.bottomSheetProps.animation,
      constraints: widget.popupProps.bottomSheetProps.constraints,
      builder: (ctx) => _popupWidgetInstance(),
    ).closed;
  }

  ///open BottomSheet (Dialog mode)
  Future _openModalBottomSheet() {
    final sheetTheme = Theme.of(context).bottomSheetTheme;
    return showModalBottomSheet<T>(
      context: context,
      useSafeArea: widget.popupProps.modalBottomSheetProps.useSafeArea,
      barrierColor: widget.popupProps.modalBottomSheetProps.barrierColor,
      backgroundColor:
          widget.popupProps.modalBottomSheetProps.backgroundColor ??
              sheetTheme.modalBackgroundColor ??
              sheetTheme.backgroundColor ??
              Colors.white,
      isDismissible: widget.popupProps.modalBottomSheetProps.barrierDismissible,
      isScrollControlled:
          widget.popupProps.modalBottomSheetProps.isScrollControlled,
      enableDrag: widget.popupProps.modalBottomSheetProps.enableDrag,
      clipBehavior: widget.popupProps.modalBottomSheetProps.clipBehavior,
      elevation: widget.popupProps.modalBottomSheetProps.elevation,
      shape: widget.popupProps.modalBottomSheetProps.shape,
      anchorPoint: widget.popupProps.modalBottomSheetProps.anchorPoint,
      useRootNavigator:
          widget.popupProps.modalBottomSheetProps.useRootNavigator,
      transitionAnimationController:
          widget.popupProps.modalBottomSheetProps.animation,
      constraints: widget.popupProps.modalBottomSheetProps.constraints,
      builder: (ctx) => _popupWidgetInstance(),
    );
  }

  ///openMenu
  Future _openMenu() {
    // Here we get the render object of our physical button, later to get its size & position
    final popupButtonObject = context.findRenderObject() as RenderBox;
    // Get the render object of the overlay used in `Navigator` / `MaterialApp`, i.e. screen size reference
    var overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    return showCustomMenu<T>(
      menuModeProps: widget.popupProps.menuProps,
      context: context,
      position: (widget.popupProps.menuProps.positionCallback ?? _position)(
        popupButtonObject,
        overlay,
      ),
      child: _popupWidgetInstance(),
    );
  }

  Widget _popupWidgetInstance() {
    return SelectionWidget<T>(
      key: _popupStateKey,
      popupProps: widget.popupProps,
      itemAsString: widget.itemAsString,
      filterFn: widget.filterFn,
      items: widget.items,
      asyncItems: widget.asyncItems,
      onChanged: _handleOnChangeSelectedItems,
      compareFn: widget.compareFn,
      isMultiSelectionMode: isMultiSelectionMode,
      defaultSelectedItems: List.from(getSelectedItems),
    );
  }

  ///Function that manage focus listener
  ///set true only if the widget already not focused to prevent unnecessary build
  ///same thing for clear focus,
  void _handleFocus(bool isFocused) {
    if (isFocused && !_isFocused.value) {
      FocusScope.of(context).unfocus();
      _isFocused.value = true;
    } else if (!isFocused && _isFocused.value) {
      _isFocused.value = false;
    }
  }

  ///handle on change value , if the validation is active , we validate the new selected item
  void _handleOnChangeSelectedItems(List<T> selectedItems) {
    changeItem() {
      _selectedItemsNotifier.value = List.from(selectedItems);
      if (widget.onChanged != null) {
        widget.onChanged!(getSelectedItem);
      } else if (widget.onChangedMultiSelection != null) {
        widget.onChangedMultiSelection!(selectedItems);
      }
    }

    if (widget.onBeforeChange != null) {
      widget.onBeforeChange!(getSelectedItem,
              selectedItems.isEmpty ? null : selectedItems.first)
          .then((value) {
        if (value == true) {
          changeItem();
        }
      });
    } else if (widget.onBeforeChangeMultiSelection != null) {
      widget.onBeforeChangeMultiSelection!(getSelectedItems, selectedItems)
          .then((value) {
        if (value == true) {
          changeItem();
        }
      });
    } else {
      changeItem();
    }

    _handleFocus(false);
  }

  bool _isEqual(T i1, T i2) => widget.compareFn?.call(i1, i2) ?? i1 == i2;

  Future<void> _selectSearchMode() async {
    //handle onBefore popupOpening
    if (widget.onBeforePopupOpening != null) {
      if (await widget.onBeforePopupOpening!(getSelectedItem) == false) return;
    } else if (widget.onBeforePopupOpeningMultiSelection != null) {
      if (await widget.onBeforePopupOpeningMultiSelection!(getSelectedItems) ==
          false) return;
    }

    _handleFocus(true);
    if (widget.popupProps.mode == Mode.menu) {
      await _openMenu();
    } else if (widget.popupProps.mode == Mode.modalBottomSheet) {
      await _openModalBottomSheet();
    } else if (widget.popupProps.mode == Mode.bottomSheet) {
      await _openBottomSheet();
    } else {
      await _openSelectDialog();
    }
    //dismiss either by selecting items OR clicking outside the popup
    widget.popupProps.onDismissed?.call();
    _handleFocus(false);
  }

  void changeSelectedItem(T? selectedItem) =>
      _handleOnChangeSelectedItems(_itemToList(selectedItem));

  void changeSelectedItems(List<T> selectedItems) =>
      _handleOnChangeSelectedItems(selectedItems);

  void removeItem(T itemToRemove) => _handleOnChangeSelectedItems(
      getSelectedItems..removeWhere((i) => _isEqual(itemToRemove, i)));

  void clear() => _handleOnChangeSelectedItems([]);

  T? get getSelectedItem =>
      getSelectedItems.isEmpty ? null : getSelectedItems.first;

  List<T> get getSelectedItems => _selectedItemsNotifier.value;

  ///check if the dropdownSearch is focused
  bool get isFocused => _isFocused.value;

  ///return true if we are in multiSelection mode , false otherwise
  bool get isMultiSelectionMode => widget.isMultiSelectionMode;

  ///Deselect items programmatically on the popup of selection
  void popupDeselectItems(List<T> itemsToDeselect) {
    _popupStateKey.currentState?.deselectItems(itemsToDeselect);
  }

  ///Deselect ALL items programmatically on the popup of selection
  void popupDeselectAllItems() {
    _popupStateKey.currentState?.deselectAllItems();
  }

  ///select ALL items programmatically on the popup of selection
  void popupSelectAllItems() {
    _popupStateKey.currentState?.selectAllItems();
  }

  ///select items programmatically on the popup of selection
  void popupSelectItems(List<T> itemsToSelect) {
    _popupStateKey.currentState?.selectItems(itemsToSelect);
  }

  ///validate selected items programmatically on the popup of selection
  void popupOnValidate() {
    _popupStateKey.currentState?.onValidate();
  }

  ///validate selected items programmatically passed in param [itemsToValidate]
  void popupValidate(List<T> itemsToValidate) {
    closeDropDownSearch();
    changeSelectedItems(itemsToValidate);
  }

  void openDropDownSearch() => _selectSearchMode();

  SelectionWidgetState<T>? get getPopupState => _popupStateKey.currentState;

  void closeDropDownSearch() => _popupStateKey.currentState?.closePopup();

  bool get popupIsAllItemSelected =>
      _popupStateKey.currentState?.isAllItemSelected ?? false;

  List<T> get popupGetSelectedItems =>
      _popupStateKey.currentState?.getSelectedItem ?? [];

  void updatePopupState() => _popupStateKey.currentState?.setState(() {});
}
