import 'i_q_hsm_state_machine_helper.dart';
import 'runner.dart';
import 'threaded_code_executor.dart';
import 'utils.dart';

class QHsmHelper implements IQHsmStateMachineHelper {

  late String _state;
  late Runner runner = Runner(this);
  final Map<String,ThreadedCodeExecutor> _container = {};

  QHsmHelper(this._state);

  void insert (String state, String event, ThreadedCodeExecutor executor) {
    _container[createKey(state,event)] = executor;
  }

  // void runAsync (String state, String event, [Object? data]) {
  //   String key = createKey(state, event);
  //   if (!_container.containsKey(key)) {
  //     print('runAsync.error: $state->$event');
  //     return;
  //   }
  //   ThreadedCodeExecutor? executor = _container[key];
  //   executor?.executeAsync(data);
  // }

  // void runSync (String state, String event, [Object? data]) {
  //   String key = createKey(state, event);
  //   if (!_container.containsKey(key)) {
  //     print('runSync.error: $state->$event');
  //     return;
  //   }
  //   ThreadedCodeExecutor? executor = _container[key];
  //   executor?.executeSync(data);
  // }

  // void run (String event, [Object? data]) {
  //   String key = createKey(state, event);
  //   if (!_container.containsKey(key)) {
  //     print('runSync.error: $state->$event');
  //     return;
  //   }
  //   ThreadedCodeExecutor? executor = _container[key];
  //   executor?.executeSync(data);
  // }


  void post(String event, [Object? data]) {
    runner.post(event, data);
  }

  @override
  ThreadedCodeExecutor? executor(String event) {
    String key = createKey(_state, event);
    if (!_container.containsKey(key)) {
      print('runSync.error: $_state->$event');
      return null;
    }
    ThreadedCodeExecutor? executor = _container[key];
    return executor;
  }

  @override
  String getState() {
    return _state;
  }

  @override
  void setState(String state) {
    //print ('******* QHsmHelper.setState $_state->$state *******');
    _state = state;
  }

}