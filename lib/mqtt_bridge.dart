import 'mqtt_cs_8_helper.dart';
import 'typedef.dart';

class MQTTBridge {
  late  MqttHelper  _hsmHelper;
  final VoidCallbackBoolString callbackFunction;

  late VoidBridgeCallback? bridgeCB;

  VoidBridgeCallback? getCallbackFunction() {
    return bridgeCB;
  }

  void putCallbackFunction(VoidBridgeCallback? cb) {
    bridgeCB = cb;
  }

  void response(String tag, bool ok, String text, bool next) {

    print('MQTTBridge.response [$tag]->[$text]->[$ok]');

    VoidBridgeCallback? cb = getCallbackFunction();
    cb?.call(ok,text);

    if (ok) {
      if (next) {
        post('Succeeded');
      }
    }
    else {
      if (next) {
        post('Failed');
      }
    }
  }

  MQTTBridge (this.callbackFunction) {
    _hsmHelper = MqttHelper(response, this);
    _hsmHelper.init();
  }

  String state() {
    return _hsmHelper.state();
  }

  void post (String eventName) {
    _hsmHelper.run(eventName);
  }

  void postComposite (String eventName, [VoidBridgeCallback? cb]) {
    putCallbackFunction(cb);
    _hsmHelper.run(eventName);
  }

  bool isSubscribed() {
    bool result = false;
    if (state() == 'AwaitPublishing') {
      result = true;
    }
    return result;
  }

  bool isConnected() {
    bool result = true;
    if (state() == 'Disconnected') {
      result = false;
    }
    return result;
  }

  void setUnitTest() {
    _hsmHelper.setUnitTest();
  }

}