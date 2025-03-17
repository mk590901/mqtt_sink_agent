import 'dart:io';
import 'client_helper.dart';
import 'mqtt_bridge.dart';
import 'mqtt_service.dart';
import 'slicer/slicer.dart';
import 'typedef.dart';

class MQTTClient {

  late MqttService mqttService;

  final String subscribeTopic = 'hsm_v2/topic';

  final VoidCallbackStringBoolString callbackFunction;
  final MQTTBridge bridge;

  MQTTClient(this.callbackFunction, this.bridge) {
    mqttService = MqttService(callbackFunction, bridge);
  }

  void connect () {
    print('******* connect *******');
    mqttService.connect();
  }

  void subscribe () {
    print('******* subscribe *******');
    mqttService.subscribe(subscribeTopic);
  }

  void publish () {
    print('******* publish *******');
    mqttService.publish(subscribeTopic, getData(getSelectedFiles()));
  }

  void unsubscribe () {
    print('******* unsubscribe *******');
    mqttService.unsubscribe(subscribeTopic);
  }

  void disconnect () {
    print('******* disconnect *******');
    mqttService.disconnect();
  }

  void setUnitTest() {
    mqttService.setUnitTest();
  }

  List<String> getData(List<String> filesList) {
    List<String> bundle = [];
    String prefix = '/storage/emulated/0/Documents/';
    for (int i = 0; i < filesList.length; i++) {
      String filePath = filesList[i];
      String content = readFileContentSync(filePath);
      String subPath = filePath.replaceFirst(prefix, '');
      Slicer slicer = Slicer('1234', 2048);
      bundle.addAll(slicer.chunkMessage(subPath, content));
    }
    return bundle;
  }

  String readFileContentSync(String filePath) {
    try {
      // Read the file synchronously
      File file = File(filePath);
      String content = file.readAsStringSync();
      return content;
    } catch (e) {
      print('Error reading file: $e');
      return '';
    }
  }

  List<String> getSelectedFiles() {
    List<String>? list = ClientHelper.instance()?.getFilesList();
    return list?? [];
  }
}