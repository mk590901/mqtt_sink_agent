import 'typedef.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class IReaction {
  void result(Response response);
}

// Bloc
class TaskBloc extends Bloc<TaskEvent, TaskState> implements IReaction {

  //final List<Response> trace = [];

  //late Emitter<TaskState> currentEmit_;
  bool error = false;
  String errorMessage = '';

  TaskBloc() : super(TaskInitial()) {
    on<ExecuteTaskEvent>(_onExecuteTask);
  }

  Future<void> _onExecuteTask(ExecuteTaskEvent event, Emitter<TaskState> emit) async {
    final currentMessages = (state is TaskLoaded || state is TaskError || state is TaskLoading)
        ? List<Pair<bool, String>>.from((state as dynamic).messages)
        : <Pair<bool, String>>[];
    error = false;
    emit(TaskLoading(messages: currentMessages));
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
        emit(TaskLoaded(messages: List.from([])..add(Pair(true, /*response.message*/'Operation completed succeeded'))));
      }
      else {
        emit(TaskError(messages: List.from([])..add(Pair(false, /*response.message*/errorMessage))));
      }
    }
  }

}

// Events
abstract class TaskEvent {}

class ExecuteTaskEvent extends TaskEvent {}

// States
abstract class TaskState {
  final List<Pair<bool, String>> messages;

  TaskState(this.messages);
}

class TaskInitial extends TaskState {
  TaskInitial() : super([]);
}

class TaskLoading extends TaskState {
  TaskLoading({required List<Pair<bool, String>> messages}) : super(messages);
}

class TaskLoaded extends TaskState {
  TaskLoaded({required List<Pair<bool, String>> messages}) : super(messages);
}

class TaskError extends TaskState {
  TaskError({required List<Pair<bool, String>> messages}) : super(messages);
}

// Task
class Task {

  final IReaction reaction;
  //late  MQTTBridge mqttBridge;

  //final Random random = Random();

  void response(bool rc, String text, bool next) {
    print ('response $rc, $text, $next');
  }

  void connect (VoidBridgeCallback cb) {
    //print ('******* connect [${mqttBridge.state()}] *******');
    //mqttBridge.postComposite('Connect', cb);
  }

  // Future<void> connect(VoidBridgeCallback cb) async {
  //   print ('******* connect [${mqttBridge.state()}] *******');
  //   mqttBridge.postComposite('Connect', cb);
  // }

  Task (this.reaction) {
    //mqttBridge = MQTTBridge(response);
  }

  void execute() {
    bool rc = false;
    String message = 'result';

    connect((bool rc_, String parameter_) {
      rc = rc_;
      message = parameter_;
      print('******* execute $rc, $message');
      reaction.result(Response(result: rc, message: message));
    });
    //return Future.value();;
  }

}

// Response
class Response {
  final bool result;
  final String message;
  Response({required this.result, required this.message});
  @override
  String toString() {
    return '[$result,$message]';
  }
}

// Pair class
class Pair<T1, T2> {
  final T1 first;
  final T2 second;
  Pair(this.first, this.second);
}

