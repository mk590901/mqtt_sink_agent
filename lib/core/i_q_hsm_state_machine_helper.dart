import 'threaded_code_executor.dart';

abstract class IQHsmStateMachineHelper {
  String getState();
  void setState(String state);
  ThreadedCodeExecutor? executor(String event);
}
