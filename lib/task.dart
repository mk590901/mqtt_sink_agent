// Task
import 'package:mqtt_sink_agent/typedef.dart';

import 'aux_classes.dart';
import 'mqtt_bridge.dart';

class Task {

  final IReaction reaction;
  late  MQTTBridge mqttBridge;

  //final Random random = Random();

  void response(bool rc, String text, bool next) {
    print ('response $rc, $text, $next');
  }

  void connect (VoidBridgeCallback cb) {
    print ('******* connect [${mqttBridge.state()}] *******');
    mqttBridge.postComposite('Connect', cb);
  }

  Task (this.reaction) {
    mqttBridge = MQTTBridge(response);
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
