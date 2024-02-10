import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  TaskListBloc() : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) {});
  }
}
