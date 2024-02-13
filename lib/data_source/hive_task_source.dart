import 'package:hive/hive.dart';
import 'package:todo_list/data/model/data.dart';
import 'package:todo_list/data_source/data_source.dart';

class HiveTaskDataSource implements DataSource<TaskEntity> {
  final Box<TaskEntity> box;
  HiveTaskDataSource(
    this.box,
  );

  @override
  Future<TaskEntity> createOrUpdate(TaskEntity item) async {
    if (item.isInBox) {
      item.save();
    } else {
      item.id = await box.add(item);
    }
    return item;
  }

  @override
  Future<void> delete(TaskEntity item) async {
    item.delete();
  }

  @override
  Future<void> deleteAll() async {
    box.clear();
  }

  @override
  Future<void> deleteById(id) async {
    box.delete(id);
  }

  @override
  Future<List<TaskEntity>> getAll({String searchKeyword = ''}) async {
    if (searchKeyword.isNotEmpty) {
      return box.values
          .where((element) => element.name.contains(searchKeyword))
          .toList();
    } else {
      return box.values.toList();
    }
  }

  @override
  Future<TaskEntity> getById(id) async {
    return box.values.firstWhere((element) => element.id == id);
  }
}
