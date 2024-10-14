extension ListX<T> on List<T> {
  List<T> getUniques() {
    return List<T>.from(Set<T>.from(this));
  }

  void swap(int index1, int index2) {
    final length = this.length;
    RangeError.checkValidIndex(index1, this, "index1", length);
    RangeError.checkValidIndex(index2, this, "index2", length);
    if (index1 != index2) {
      final tmp1 = this[index1];
      this[index1] = this[index2];
      this[index2] = tmp1;
    }
  }
}
