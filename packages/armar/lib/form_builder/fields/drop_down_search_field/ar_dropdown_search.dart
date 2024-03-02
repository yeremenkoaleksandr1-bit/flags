import 'dart:async';
import 'package:armar/armar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import 'dropdown/drop_down_search_field.dart';
import 'dropdown/src/keyboard_suggestion_selection_notifier.dart';
import 'dropdown/src/should_refresh_suggestion_focus_index_notifier.dart';
import 'dropdown/src/type_def.dart';

class ArDropDownSearchField<T> extends StatefulWidget {
  final SuggestionsCallback<T> suggestionsCallback;

  final SuggestionSelectionCallback<T> onSuggestionSelected;

  final ItemBuilder<T> itemBuilder;
  final IndexedWidgetBuilder? itemSeparatorBuilder;

  final LayoutArchitecture? layoutArchitecture;

  final ScrollController? scrollController;

  final SuggestionsBoxDecoration suggestionsBoxDecoration;

  final SuggestionsBoxController? suggestionsBoxController;

  final Duration debounceDuration;

  final WidgetBuilder? loadingBuilder;

  final WidgetBuilder? noItemsFoundBuilder;

  final ErrorBuilder? errorBuilder;

  final bool intercepting;

  final AnimationTransitionBuilder? transitionBuilder;

  final Duration animationDuration;

  final double animationStart;

  final TextFieldConfiguration textFieldConfiguration;

  final double suggestionsBoxVerticalOffset;

  final bool getImmediateSuggestions;

  final bool hideOnLoading;

  final bool hideOnEmpty;

  final bool hideOnError;

  final bool hideSuggestionsOnKeyboardHide;

  final bool keepSuggestionsOnLoading;

  final bool keepSuggestionsOnSuggestionSelected;

  final bool autoFlipDirection;

  final bool autoFlipListDirection;

  final double autoFlipMinHeight;

  final bool hideKeyboard;

  final int minCharsForSuggestions;

  final bool hideKeyboardOnDrag;

  final Future<void> Function(bool)? onSuggestionsBoxToggle;
  final Future<void> Function()? actionWhenSuggestionsStartOpening;

  final bool displayAllSuggestionWhenTap;
  final AxisDirection direction;

  const ArDropDownSearchField({
    required this.suggestionsCallback,
    required this.itemBuilder,
    this.itemSeparatorBuilder,
    this.layoutArchitecture,
    this.intercepting = false,
    required this.onSuggestionSelected,
    this.textFieldConfiguration = const TextFieldConfiguration(),
    this.suggestionsBoxDecoration = const SuggestionsBoxDecoration(),
    this.debounceDuration = const Duration(milliseconds: 300),
    this.suggestionsBoxController,
    this.scrollController,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.errorBuilder,
    this.transitionBuilder,
    this.animationStart = 0.25,
    this.animationDuration = const Duration(milliseconds: 500),
    this.getImmediateSuggestions = false,
    this.suggestionsBoxVerticalOffset = 5.0,
    this.hideOnLoading = false,
    this.hideOnEmpty = false,
    this.hideOnError = false,
    this.hideSuggestionsOnKeyboardHide = true,
    this.keepSuggestionsOnLoading = true,
    this.keepSuggestionsOnSuggestionSelected = false,
    this.autoFlipDirection = false,
    this.autoFlipListDirection = true,
    this.autoFlipMinHeight = 64.0,
    this.hideKeyboard = false,
    this.minCharsForSuggestions = 0,
    this.onSuggestionsBoxToggle,
    this.hideKeyboardOnDrag = false,
    required this.displayAllSuggestionWhenTap,
    super.key,
    this.direction = AxisDirection.down,
    this.actionWhenSuggestionsStartOpening,
  })  : assert(animationStart >= 0.0 && animationStart <= 1.0),
        assert(
            direction == AxisDirection.down || direction == AxisDirection.up),
        assert(minCharsForSuggestions >= 0),
        assert(!hideKeyboardOnDrag ||
            hideKeyboardOnDrag && !hideSuggestionsOnKeyboardHide);

  @override
  // ignore: library_private_types_in_public_api
  _ArDropDownSearchFieldState<T> createState() =>
      _ArDropDownSearchFieldState<T>();
}

class _ArDropDownSearchFieldState<T> extends State<ArDropDownSearchField<T>>
    with WidgetsBindingObserver {
  FocusNode? _focusNode;
  final KeyboardSuggestionSelectionNotifier
      _keyboardSuggestionSelectionNotifier =
      KeyboardSuggestionSelectionNotifier();
  TextEditingController? _textEditingController;
  SuggestionsBox? _suggestionsBox;

  TextEditingController? get _effectiveController =>
      widget.textFieldConfiguration.controller ?? _textEditingController;

  FocusNode? get _effectiveFocusNode =>
      widget.textFieldConfiguration.focusNode ?? _focusNode;
  late VoidCallback _focusNodeListener;

  final LayerLink _layerLink = LayerLink();

  // Timer that resizes the suggestion box on each tick. Only active when the user is scrolling.
  Timer? _resizeOnScrollTimer;

  // The rate at which the suggestion box will resize when the user is scrolling
  final Duration _resizeOnScrollRefreshRate = const Duration(milliseconds: 500);

  // Will have a value if the dropdown_search_field is inside a scrollable widget
  ScrollPosition? _scrollPosition;

  // Keyboard detection
  // final Stream<bool>? _keyboardVisibility = (supportedPlatform) ? KeyboardVisibilityController().onChange : null;
  final Stream<bool>? _keyboardVisibility = null;
  late StreamSubscription<bool>? _keyboardVisibilitySubscription;

  bool _areSuggestionsFocused = false;
  late final _shouldRefreshSuggestionsFocusIndex =
      ShouldRefreshSuggestionFocusIndexNotifier(
          textFieldFocusNode: _effectiveFocusNode);

  @override
  void didChangeMetrics() {
    // Catch keyboard event and orientation change; resize suggestions list
    this._suggestionsBox!.onChangeMetrics();
  }

  @override
  void dispose() {
    this._suggestionsBox!.close();
    this._suggestionsBox!.widgetMounted = false;
    WidgetsBinding.instance.removeObserver(this);
    _keyboardVisibilitySubscription?.cancel();
    _effectiveFocusNode!.removeListener(_focusNodeListener);
    _focusNode?.dispose();
    _resizeOnScrollTimer?.cancel();
    _scrollPosition?.removeListener(_scrollResizeListener);
    _textEditingController?.dispose();
    _keyboardSuggestionSelectionNotifier.dispose();
    super.dispose();
  }

  KeyEventResult _onKeyEvent(FocusNode _, RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.arrowUp) ||
        event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      // do nothing to avoid puzzling users until keyboard arrow nav is implemented
    } else {
      _keyboardSuggestionSelectionNotifier.onKeyboardEvent(event);
    }
    return KeyEventResult.ignored;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.textFieldConfiguration.controller == null) {
      this._textEditingController = TextEditingController();
    }

    final textFieldConfigurationFocusNode =
        widget.textFieldConfiguration.focusNode;
    if (textFieldConfigurationFocusNode == null) {
      this._focusNode = FocusNode(onKey: _onKeyEvent);
    } else if (textFieldConfigurationFocusNode.onKey == null) {
      // * we add the _onKeyEvent callback to the textFieldConfiguration focusNode
      textFieldConfigurationFocusNode.onKey = ((node, event) {
        final keyEventResult = _onKeyEvent(node, event);
        return keyEventResult;
      });
    } else {
      final onKeyCopy = textFieldConfigurationFocusNode.onKey!;
      textFieldConfigurationFocusNode.onKey = ((node, event) {
        _onKeyEvent(node, event);
        return onKeyCopy(node, event);
      });
    }

    this._suggestionsBox = SuggestionsBox(
      context,
      widget.direction,
      widget.autoFlipDirection,
      widget.autoFlipListDirection,
      widget.autoFlipMinHeight,
    );

    widget.suggestionsBoxController?.suggestionsBox = this._suggestionsBox;
    widget.suggestionsBoxController?.effectiveFocusNode =
        this._effectiveFocusNode;

    this._focusNodeListener = () async {
      if (_effectiveFocusNode!.hasFocus) {
        await this._suggestionsBox!.open(
              actionWhenSuggestionsStartOpening:
                  widget.actionWhenSuggestionsStartOpening,
            );
      } else if (!_areSuggestionsFocused) {
        if (widget.hideSuggestionsOnKeyboardHide) {
          this._suggestionsBox!.close();
        }
      }

      await widget.onSuggestionsBoxToggle?.call(this._suggestionsBox!.isOpened);
    };

    this._effectiveFocusNode!.addListener(_focusNodeListener);

    // hide suggestions box on keyboard closed
    this._keyboardVisibilitySubscription =
        _keyboardVisibility?.listen((bool isVisible) {
      if (widget.hideSuggestionsOnKeyboardHide && !isVisible) {
        _effectiveFocusNode!.unfocus();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((duration) {
      if (mounted) {
        this._initOverlayEntry();
        // calculate initial suggestions list size
        this._suggestionsBox!.resize();

        // in case we already missed the focus event
        if (this._effectiveFocusNode!.hasFocus) {
          this._suggestionsBox!.open();
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scrollableState = ArScrollableView.of(context).scrollController;
    // The DropDownSearchField is inside a scrollable widget
    _scrollPosition = scrollableState.position;

    _scrollPosition!.removeListener(_scrollResizeListener);
    _scrollPosition!.isScrollingNotifier.addListener(_scrollResizeListener);
  }

  void _scrollResizeListener() {
    bool isScrolling = _scrollPosition!.isScrollingNotifier.value;
    _resizeOnScrollTimer?.cancel();
    if (isScrolling) {
      // Scroll started
      _resizeOnScrollTimer =
          Timer.periodic(_resizeOnScrollRefreshRate, (timer) {
        _suggestionsBox?.resize();
      });
    } else {
      // Scroll finished
      _suggestionsBox?.resize();
    }
  }

  void _initOverlayEntry() {
    this._suggestionsBox!.overlayEntry = OverlayEntry(builder: (context) {
      void giveTextFieldFocus() {
        _effectiveFocusNode?.requestFocus();
        _areSuggestionsFocused = false;
      }

      void onSuggestionFocus() {
        if (!_areSuggestionsFocused) {
          _areSuggestionsFocused = true;
        }
      }

      final suggestionsList = SuggestionsList<T>(
        suggestionsBox: _suggestionsBox,
        decoration: widget.suggestionsBoxDecoration,
        debounceDuration: widget.debounceDuration,
        intercepting: widget.intercepting,
        controller: this._effectiveController,
        loadingBuilder: widget.loadingBuilder,
        scrollController: widget.scrollController,
        noItemsFoundBuilder: widget.noItemsFoundBuilder,
        errorBuilder: widget.errorBuilder,
        transitionBuilder: widget.transitionBuilder,
        suggestionsCallback: widget.suggestionsCallback,
        animationDuration: widget.animationDuration,
        animationStart: widget.animationStart,
        getImmediateSuggestions: widget.getImmediateSuggestions,
        onSuggestionSelected: (T selection) {
          if (!widget.keepSuggestionsOnSuggestionSelected) {
            this._effectiveFocusNode!.unfocus();
            this._suggestionsBox!.close();
          }
          widget.onSuggestionSelected(selection);
        },
        itemBuilder: widget.itemBuilder,
        itemSeparatorBuilder: widget.itemSeparatorBuilder,
        layoutArchitecture: widget.layoutArchitecture,
        direction: _suggestionsBox!.direction,
        hideOnLoading: widget.hideOnLoading,
        hideOnEmpty: widget.hideOnEmpty,
        hideOnError: widget.hideOnError,
        keepSuggestionsOnLoading: widget.keepSuggestionsOnLoading,
        minCharsForSuggestions: widget.minCharsForSuggestions,
        keyboardSuggestionSelectionNotifier:
            _keyboardSuggestionSelectionNotifier,
        shouldRefreshSuggestionFocusIndexNotifier:
            _shouldRefreshSuggestionsFocusIndex,
        giveTextFieldFocus: giveTextFieldFocus,
        onSuggestionFocus: onSuggestionFocus,
        onKeyEvent: _onKeyEvent,
        hideKeyboardOnDrag: widget.hideKeyboardOnDrag,
        displayAllSuggestionWhenTap: widget.displayAllSuggestionWhenTap,
      );

      double w = _suggestionsBox!.textBoxWidth;
      if (widget.suggestionsBoxDecoration.constraints != null) {
        if (widget.suggestionsBoxDecoration.constraints!.minWidth != 0.0 &&
            widget.suggestionsBoxDecoration.constraints!.maxWidth !=
                double.infinity) {
          w = (widget.suggestionsBoxDecoration.constraints!.minWidth +
                  widget.suggestionsBoxDecoration.constraints!.maxWidth) /
              2;
        } else if (widget.suggestionsBoxDecoration.constraints!.minWidth !=
                0.0 &&
            widget.suggestionsBoxDecoration.constraints!.minWidth > w) {
          w = widget.suggestionsBoxDecoration.constraints!.minWidth;
        } else if (widget.suggestionsBoxDecoration.constraints!.maxWidth !=
                double.infinity &&
            widget.suggestionsBoxDecoration.constraints!.maxWidth < w) {
          w = widget.suggestionsBoxDecoration.constraints!.maxWidth;
        }
      }

      final Widget compositedFollower = CompositedTransformFollower(
        link: this._layerLink,
        showWhenUnlinked: false,
        offset: Offset(
            widget.suggestionsBoxDecoration.offsetX,
            _suggestionsBox!.direction == AxisDirection.down
                ? _suggestionsBox!.textBoxHeight +
                    widget.suggestionsBoxVerticalOffset
                : -widget.suggestionsBoxVerticalOffset),
        child: _suggestionsBox!.direction == AxisDirection.down
            ? suggestionsList
            : FractionalTranslation(
                translation:
                    const Offset(0.0, -1.0), // visually flips list to go up
                child: suggestionsList,
              ),
      );

      // When wrapped in the Positioned widget, the suggestions box widget
      // is placed before the Scaffold semantically. In order to have the
      // suggestions box navigable from the search input or keyboard,
      // Semantics > Align > ConstrainedBox are needed. This does not change
      // the style visually. However, when VO/TB are not enabled it is
      // necessary to use the Positioned widget to allow the elements to be
      // properly tappable.
      return MediaQuery.of(context).accessibleNavigation
          ? Semantics(
              container: true,
              child: Align(
                alignment: Alignment.topLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: w),
                  child: compositedFollower,
                ),
              ),
            )
          : Positioned(
              width: w,
              child: compositedFollower,
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: PointerInterceptor(
        intercepting: widget.intercepting,
        child: TextField(
            focusNode: this._effectiveFocusNode,
            controller: this._effectiveController,
            decoration: widget.textFieldConfiguration.decoration,
            style: widget.textFieldConfiguration.style,
            textAlign: widget.textFieldConfiguration.textAlign,
            enabled: widget.textFieldConfiguration.enabled,
            keyboardType: widget.textFieldConfiguration.keyboardType,
            autofocus: widget.textFieldConfiguration.autofocus,
            inputFormatters: widget.textFieldConfiguration.inputFormatters,
            autocorrect: widget.textFieldConfiguration.autocorrect,
            maxLines: widget.textFieldConfiguration.maxLines,
            textAlignVertical: widget.textFieldConfiguration.textAlignVertical,
            minLines: widget.textFieldConfiguration.minLines,
            maxLength: widget.textFieldConfiguration.maxLength,
            maxLengthEnforcement:
                widget.textFieldConfiguration.maxLengthEnforcement,
            obscureText: widget.textFieldConfiguration.obscureText,
            onChanged: widget.textFieldConfiguration.onChanged,
            onSubmitted: widget.textFieldConfiguration.onSubmitted,
            onEditingComplete: widget.textFieldConfiguration.onEditingComplete,
            onTap: widget.textFieldConfiguration.onTap,
            onTapOutside: widget.textFieldConfiguration.onTapOutside,
            scrollPadding: widget.textFieldConfiguration.scrollPadding,
            textInputAction: widget.textFieldConfiguration.textInputAction,
            textCapitalization:
                widget.textFieldConfiguration.textCapitalization,
            keyboardAppearance:
                widget.textFieldConfiguration.keyboardAppearance,
            cursorWidth: widget.textFieldConfiguration.cursorWidth,
            cursorRadius: widget.textFieldConfiguration.cursorRadius,
            cursorColor: widget.textFieldConfiguration.cursorColor,
            textDirection: widget.textFieldConfiguration.textDirection,
            enableInteractiveSelection:
                widget.textFieldConfiguration.enableInteractiveSelection,
            readOnly: widget.hideKeyboard,
            autofillHints: widget.textFieldConfiguration.autofillHints),
      ),
    );
  }
}
