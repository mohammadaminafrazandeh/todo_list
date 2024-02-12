import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_list/data/model/data.dart';
import 'package:todo_list/repository/repository.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<TaskEntity> repository;
  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TaskListStarted || event is TaskListSearch) {
        emit(TaskListLoading());
        final String searchTerm;
        if (event is TaskListSearch) {
          searchTerm = event.searchTerm;
        } else {
          searchTerm = '';
        }

        try {
          final List<TaskEntity> items;
          items = await repository.getAll(searchKeyword: searchTerm);
          if (items.isEmpty) {
            emit(TaskListEmpty());
          } else {
            emit(TaskListSuccess(tasks: items));
          }
        } catch (e) {
          emit(TaskListError(message: 'Error Massage : $e'));
        }
      } else if (event is TaskListDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      }
    });
  }
}
