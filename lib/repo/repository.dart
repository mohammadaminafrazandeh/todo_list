import 'package:todo_list/source/source.dart';

class Repository<T> implements DataSource<T> {
  final DataSource<T> localDataSource;
  Repository(this.localDataSource);
  @override
  Future<T> createOrUpdate(T data) {
    return localDataSource.createOrUpdate(data);
  }

  @override
  Future<void> delete(T data) {
    return localDataSource.delete(data);
  }

  @override
  Future<void> deleteAll() {
    return localDataSource.deleteAll();
  }

  @override
  Future<void> deleteById(id) {
    return localDataSource.deleteById(id);
  }

  @override
  Future<T> findById(id) {
    return localDataSource.findById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeyword = ''}) {
    return localDataSource.getAll(searchKeyword: searchKeyword);
  }
}
