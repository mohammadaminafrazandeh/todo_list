part of 'task_list_bloc.dart';

@immutable
sealed class TaskListState {}

final class TaskListInitial extends TaskListState {}

final class TaskListLoading extends TaskListState {}

final class TaskListSuccess extends TaskListState {
  final List tasks;
  TaskListSuccess({
    required this.tasks,
  });
}

final class TaskListError extends TaskListState {
  final String message;
  TaskListError({
    required this.message,
  });
}

final class TaskListEmpty extends TaskListState {}
