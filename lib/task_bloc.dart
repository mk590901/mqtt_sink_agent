// task_bloc.dart
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_sink_agent/task.dart';
import 'aux_classes.dart';
import 'client_helper.dart';
import 'models.dart';

class TaskEvent {}

class StartTask extends TaskEvent {
  final List<FileSystemItem> selectedFiles;
  StartTask(this.selectedFiles);
}

class TaskState {}

class TaskInitial extends TaskState {}

class TaskInProgress extends TaskState {}

class TaskSuccess extends TaskState {}

class TaskFailure extends TaskState {}

class TaskBloc extends Bloc<TaskEvent, TaskState> implements IReaction {

  bool error = false;
  String errorMessage = '';

  TaskBloc() : super(TaskInitial()) {
    on<StartTask>(_onStartTask);
  }

  Future<void> _onStartTask(StartTask event, Emitter<TaskState> emit) async {

    error = false;

    emit(TaskInProgress());

    ClientHelper.instance()?.setFilesList(event.selectedFiles);

    Task(this).execute();

  }

  @override
  void result(Response response) {
    if (response.message.contains('Failed')) {
      error = true;
      errorMessage = response.message;
    }

    if (response.message.contains('Disconnected')) {
      if (!error) {
        emit(TaskSuccess());
      }
      else {
        emit(TaskFailure());
      }
    }
  }
}
