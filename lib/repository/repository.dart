// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo_list/data/data_source/data_source.dart';

class Repository implements DataSource {
  DataSource localDataSource;
  Repository({
    required this.localDataSource,
  });

  @override
  createOrUpdate(item) {
    return localDataSource.createOrUpdate(item);
  }

  @override
  void delete(item) {
    localDataSource.delete(item);
  }

  @override
  void deleteAll() {
    localDataSource.deleteAll();
  }

  @override
  void deleteById(id) {
    localDataSource.deleteById(id);
  }

  @override
  List getAll(String searchKeyword) {
    return localDataSource.getAll(searchKeyword);
  }

  @override
  getById(id) {
    return localDataSource.getById(id);
  }
}
