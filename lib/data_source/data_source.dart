abstract class DataSource<T> {
  Future<List<T>> getAll({String searchKeyword});
  Future<T> getById(dynamic id);
  Future<T> createOrUpdate(T item);
  Future<void> delete(T item);
  Future<void> deleteById(dynamic id);
  Future<void> deleteAll();
}
