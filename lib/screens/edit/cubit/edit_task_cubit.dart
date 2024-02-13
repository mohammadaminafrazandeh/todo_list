import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  EditTaskCubit() : super(EditTaskInitial());
}
