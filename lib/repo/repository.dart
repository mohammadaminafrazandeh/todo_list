import 'package:flutter/material.dart';
import 'package:todo_list/source/source.dart';

class Repository<T> with ChangeNotifier implements DataSource<T> {
  final DataSource<T> localDataSource;
  Repository(this.localDataSource);
  @override
  Future<T> createOrUpdate(T data) async {
    final T result = await localDataSource.createOrUpdate(data);
    notifyListeners();
    return result;
  }

  @override
  Future<void> delete(T data) async {
    await localDataSource.delete(data);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
    await localDataSource.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> deleteById(id) async {
    await localDataSource.deleteById(id);
    notifyListeners();
  }

  @override
  Future<T> findById(id) async {
    return localDataSource.findById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeyword = ''}) {
    return localDataSource.getAll(searchKeyword: searchKeyword);
  }
}
