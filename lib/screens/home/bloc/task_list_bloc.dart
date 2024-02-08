import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_list/data/model/data.dart';
import 'package:todo_list/repo/repository.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<TaskEntity> repository;
  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TaskListStarted || event is TaskListSearch) {
        final String searchTerm;
        emit(TaskListLoading());
        if (event is TaskListSearch) {
          searchTerm = event.searchTerm;
        } else {
          searchTerm = '';
        }

        try {
          final items = await repository.getAll(searchKeyword: searchTerm);
          if (items.isNotEmpty) {
            emit(TaskListSuccess(items));
          } else {
            emit(TaskListEmpty());
          }
        } catch (e) {
          //switch case can added here for better error handeling .
          emit(TaskListError('Error occured: $e'));
        }
      } else if (event is TaskListDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      }
    });
  }
}
