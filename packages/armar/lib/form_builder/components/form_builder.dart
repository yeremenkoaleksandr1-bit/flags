import 'package:flutter/material.dart';

import '../fields/states/text_form_field.state.dart';
import '../mixins/form_state.mixin.dart';

class ArFormBuilder extends StatefulWidget {
  ArFormBuilder(
    this.state, {
    required Widget Function(ArFormBuilderState state) builder,
    this.autovalidateMode,
    this.canPopScope = true,
    this.initialValue = const <String, dynamic>{},
    this.skipDisabled = false,
    this.enabled = true,
    this.clearValueOnUnregister = false,
  })  : onChanged = state.onFormDataChanged,
        child = Builder(builder: (context) {
          return builder(state.formState);
        }),
        super(
          key: state.formStateKey,
        );

  final FormStatePresenterMixin state;

  final VoidCallback? onChanged;

  final bool canPopScope;

  final Widget child;

  final AutovalidateMode? autovalidateMode;

  final Map<String, dynamic> initialValue;

  final bool skipDisabled;

  final bool enabled;

  final bool clearValueOnUnregister;

  static ArFormBuilderState? of(BuildContext context) =>
      context.findAncestorStateOfType<ArFormBuilderState>();

  @override
  ArFormBuilderState createState() => ArFormBuilderState();
}

typedef ArFormBuilderFields = Map<String,
    ArFormBuilderFieldState<ArFormBuilderField<dynamic>, dynamic>>;

class ArFormBuilderState extends State<ArFormBuilder> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ArFormBuilderFields _fields = {};
  final Map<String, dynamic> _instantValue = {};
  final Map<String, dynamic> _savedValue = {};

  final Map<String, Function> _transformers = {};
  bool _focusOnInvalid = true;

  bool get focusOnInvalid => _focusOnInvalid;

  bool get enabled => widget.enabled;

  /// Verify if all fields on form are valid.
  bool get isValid => fields.values.every((field) => field.isValid);

  /// Will be true if some field on form are dirty.
  ///
  /// Dirty: The value of field is changed by user or by logic code.
  bool get isDirty => fields.values.any((field) => field.isDirty);

  /// Will be true if some field on form are touched.
  ///
  /// Touched: The field is focused by user or by logic code.
  bool get isTouched => fields.values.any((field) => field.isTouched);

  /// Get a map of errors
  Map<String, String> get errors => {
        for (var element
            in fields.entries.where((element) => element.value.hasError))
          element.key.toString(): element.value.errorText ?? ''
      };

  /// Get initialValue.
  Map<String, dynamic> get initialValue => widget.initialValue;

  /// Get all fields of form.
  ArFormBuilderFields get fields => _fields;

  Map<String, dynamic> get instantValue =>
      Map<String, dynamic>.unmodifiable(_instantValue.map((key, value) =>
          MapEntry(key, _transformers[key]?.call(value) ?? value)));

  /// Returns the saved value only
  Map<String, dynamic> get value =>
      Map<String, dynamic>.unmodifiable(_savedValue.map((key, value) =>
          MapEntry(key, _transformers[key]?.call(value) ?? value)));

  dynamic transformValue<T>(String name, T? v) {
    final t = _transformers[name];
    return t != null ? t.call(v) : v;
  }

  dynamic getTransformedValue<T>(String name, {bool fromSaved = false}) {
    return transformValue<T>(name, getRawValue(name));
  }

  T? getRawValue<T>(String name, {bool fromSaved = false}) {
    return (fromSaved ? _savedValue[name] : _instantValue[name]) ??
        initialValue[name];
  }

  void setInternalFieldValue<T>(String name, T? value) {
    _instantValue[name] = value;
    widget.onChanged?.call();
  }

  void removeInternalFieldValue(String name) {
    _instantValue.remove(name);
  }

  void registerField(String name, ArFormBuilderFieldState field) {
    // Each field must have a unique name.  Ideally we could simply:
    //   assert(!_fields.containsKey(name));
    // However, Flutter will delay dispose of deactivated fields, so if a
    // field is being replaced, the new instance is registered before the old
    // one is unregistered.  To accommodate that use case, but also provide
    // assistance to accidental duplicate names, we check and emit a warning.
    final oldField = _fields[name];
    assert(() {
      if (oldField != null) {
        debugPrint('Warning! Replacing duplicate Field for $name'
            ' -- this is OK to ignore as long as the field was intentionally replaced');
      }
      return true;
    }());

    _fields[name] = field;
    field.registerTransformer(_transformers);

    field.setValue(
      oldField?.value ?? (_instantValue[name] ??= field.initialValue),
      populateForm: false,
    );
  }

  void unregisterField(String name, ArFormBuilderFieldState field) {
    if (_fields.containsKey(name)) {
      // assert(_fields.containsKey(name));
      // Only remove the field when it is the one registered.  It's possible that
      // the field is replaced (registerField is called twice for a given name)
      // before unregisterField is called for the name, so just emit a warning
      // since it may be intentional.
      if (field == _fields[name]) {
        _fields.remove(name);
        _transformers.remove(name);
        if (widget.clearValueOnUnregister) {
          _instantValue.remove(name);
          _savedValue.remove(name);
        }
      } else {
        assert(() {
          // This is OK to ignore when you are intentionally replacing a field
          // with another field using the same name.
          debugPrint('Warning! Ignoring Field unregistration for $name'
              ' -- this is OK to ignore as long as the field was intentionally replaced');
          return true;
        }());
      }
    }
  }

  void save() {
    _formKey.currentState!.save();
    // Copy values from instant to saved
    _savedValue.clear();
    _savedValue.addAll(_instantValue);
  }

  void invalidateField({required String name, String? errorText}) =>
      fields[name]?.invalidate(errorText ?? '');

  bool validate({
    bool focusOnInvalid = true,
    bool autoScrollWhenFocusOnInvalid = false,
  }) {
    _focusOnInvalid = focusOnInvalid;
    final hasError = !_formKey.currentState!.validate();
    if (hasError) {
      final wrongFields =
          fields.values.where((element) => element.hasError).toList();
      if (wrongFields.isNotEmpty) {
        if (focusOnInvalid) {
          wrongFields.first.focus();
        }
        if (autoScrollWhenFocusOnInvalid) {
          wrongFields.first.ensureScrollableVisibility();
        }
      }
    }
    return !hasError;
  }

  bool saveAndValidate({
    bool focusOnInvalid = true,
    bool autoScrollWhenFocusOnInvalid = false,
  }) {
    save();
    return validate(
      focusOnInvalid: focusOnInvalid,
      autoScrollWhenFocusOnInvalid: autoScrollWhenFocusOnInvalid,
    );
  }

  void reset() {
    _formKey.currentState?.reset();
  }

  void clearFields() {
    fields.forEach((key, value) {
      value.clear();
    });
  }

  void patchValue(Map<String, dynamic> val) {
    val.forEach((key, dynamic value) {
      _fields[key]?.didChange(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: widget.autovalidateMode,
      canPop: widget.canPopScope,
      // `onChanged` is called during setInternalFieldValue else will be called early
      child: _FormBuilderScope(
        formState: this,
        child: FocusTraversalGroup(
          policy: WidgetOrderTraversalPolicy(),
          child: widget.child,
        ),
      ),
    );
  }
}

class _FormBuilderScope extends InheritedWidget {
  const _FormBuilderScope({
    required super.child,
    required ArFormBuilderState formState,
  }) : _formState = formState;

  final ArFormBuilderState _formState;

  /// The [Form] associated with this widget.
  ArFormBuilder get form => _formState.widget;

  @override
  bool updateShouldNotify(_FormBuilderScope oldWidget) =>
      oldWidget._formState != _formState;
}
