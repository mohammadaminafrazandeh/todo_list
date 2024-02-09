import 'package:flutter/cupertino.dart';
import 'package:todo_list/data_source/data_source.dart';

class Repository<T> extends ChangeNotifier implements DataSource<T> {
  final DataSource<T> localDataSource;
  Repository(
    this.localDataSource,
  );

  @override
  Future<T> createOrUpdate(T item) async {
    final result = localDataSource.createOrUpdate(item);
    notifyListeners();
    return result;
  }

  @override
  Future<void> delete(T item) async {
    localDataSource.delete(item);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
    localDataSource.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> deleteById(id) async {
    localDataSource.deleteById(id);
    notifyListeners();
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
