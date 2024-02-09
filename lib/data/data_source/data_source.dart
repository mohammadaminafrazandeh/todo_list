abstract class DataSource<T> {
  List<T> getAll(String searchKeyword);
  T getById(dynamic id);
  T createOrUpdate(T item);
  void delete(T item);
  void deleteById(dynamic id);
  void deleteAll();
}
