// task_bloc.dart
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
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

  final Random random = Random();

  TaskBloc() : super(TaskInitial()) {
    on<StartTask>(_onStartTask);
  }

  Future<void> _onStartTask(StartTask event, Emitter<TaskState> emit) async {

    emit(TaskInProgress());

    // Task simulation

    ClientHelper.instance()?.setFilesList(event.selectedFiles);

    try {
      Response response = await _performOperation();
      if (response.result) {
        emit(TaskSuccess());
      } else {
        emit(TaskFailure());
      }
    }
    catch (e) {
      emit(TaskFailure());
    }


  }

  // Sample of async operation
  // Future<bool> _performOperation(List<FileSystemItem> files) async {
  //   await Future.delayed(const Duration(seconds: 3)); // Simulation
  //   return oracle(); //files.isNotEmpty; // true -> succeeded. false -> failed
  // }

  // Future<Response> _performOperation(/*List<FileSystemItem> files*/) async {
  //
  //   List<String> selectedFiles = ClientHelper.instance()?.getFilesList()?? [];
  //   print('->$selectedFiles');
  //
  //   await Future.delayed(const Duration(seconds: 1)); // Simulation
  //   return Response(result: oracle(), message: 'Response'); //files.isNotEmpty; // true -> succeeded. false -> failed
  // }

  Future<Response> _performOperation() async {

    List<String> selectedFiles = ClientHelper.instance()?.getFilesList()?? [];
    print('->$selectedFiles');

    await Future.delayed(const Duration(seconds: 1)); // Simulation
    return Response(result: oracle(), message: 'Response'); //files.isNotEmpty; // true -> succeeded. false -> failed
  }

  bool oracle() {
    int value = getRandomInRange(1,100);
    return (value > 48 ? true : false);
  }

  int getRandomInRange(int min, int max) {
    if (min > max) {
      throw ArgumentError('min should be less than or equal to max');
    }
    return min + random.nextInt(max - min + 1);
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
