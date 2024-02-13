// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:todo_list/data/model/data.dart';
import 'package:todo_list/repo/repository.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  final TaskEntity _task;
  final Repository<TaskEntity> repository;
  EditTaskCubit(
    this.repository,
    this._task,
  ) : super(EditTaskInitial(_task));

  void onSaveChangesClick() {
    repository.createOrUpdate(_task);
  }

  void onTextChanged(String text) {
    _task.name = text;
  }

  void onPriorityChanged(Priority priority) {
    _task.priority = priority;
    emit(EditTaskPriorityChange(_task));
  }
}
