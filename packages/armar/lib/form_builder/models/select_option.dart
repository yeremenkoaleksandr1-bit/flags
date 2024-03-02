class SelectOption<T> {
  String label;
  T value;

  SelectOption(this.label, this.value);

  Map<String, dynamic> toJson() => {
        'value': value,
      };

  @override
  String toString() {
    return 'SelectOption{label: $label, value: $value}';
  }
}
