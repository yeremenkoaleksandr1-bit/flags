abstract interface class IJsonConverter<M, T> {
  T toJson(M m);

  M fromJson(T j);
}
