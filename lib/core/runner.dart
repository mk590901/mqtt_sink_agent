import 'dart:collection';
import 'i_q_hsm_state_machine_helper.dart';
import 'threaded_code_executor.dart';

class TcEventWrapper {
  final Object? _data;
  final String  _event;

  TcEventWrapper(this._event, this._data);

  Object? data() {
    return _data;
  }

  String event() {
    return _event;
  }
}

class Runner {

  final Queue<TcEventWrapper>	_eventsQueue	= Queue<TcEventWrapper>();
  final IQHsmStateMachineHelper? _helper;
  late String targetState;

  Runner (this._helper);

  void post(String event, [Object? data]) {
    //print('post.addQueue [$event($data)]');
    //scheduleMicrotask(() {  //  ?
      _eventsQueue.add(TcEventWrapper(event, data));
      while (_eventsQueue.isNotEmpty) {
        TcEventWrapper eventWrapper = _eventsQueue.removeFirst();
        //print('post event [${eventWrapper.event()}, ${eventWrapper.data()}]');
        ThreadedCodeExecutor? executor = _helper?.executor(
            eventWrapper.event());
        executor?.executeSync(data);
      }
    //}); //  ?
  }
}
