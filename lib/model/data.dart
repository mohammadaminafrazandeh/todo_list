import 'package:hive/hive.dart';

part 'data.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String name = '';
  @HiveField(1)
  bool isComplete = false;
  @HiveField(2)
  Priority priority = Priority.low;
}

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}
