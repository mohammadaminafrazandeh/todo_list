import 'package:todo_list/data_source/data_source.dart';

class Repository<T> implements DataSource<T> {
  final DataSource<T> localDataSource;
  Repository(
    this.localDataSource,
  );

  @override
  Future<T> createOrUpdate(T item) async {
    return localDataSource.createOrUpdate(item);
  }

  @override
  Future<void> delete(T item) async {
    localDataSource.delete(item);
  }

  @override
  Future<void> deleteAll() async {
    localDataSource.deleteAll();
  }

  @override
  Future<void> deleteById(id) async {
    localDataSource.deleteById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeyword = ''}) async {
    return localDataSource.getAll(searchKeyword: searchKeyword);
  }

  @override
  Future<T> getById(id) async {
    return localDataSource.getById(id);
  }
}
