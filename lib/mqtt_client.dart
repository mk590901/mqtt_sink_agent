import 'dart:io';
import 'dart:math';

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

//    List<String> list = getFilesList('/storage/emulated/0/Documents/HsmProjects/mqtt_cs_9.hsm/');
    //String folder = '/storage/emulated/0/Documents/HsmProjects/mqtt_cs_9.hsm/';
    //List<String> list = getAllFiles(Directory(folder));
    //print ('$list');

    // mqttService.publish(subscribeTopic, getData(/*list*/[
    //   '/storage/emulated/0/Documents/HsmProjects/mqtt_cs_9.hsm/generic_code/dart/mqtt_cs_9_helper.dart',
    //   '/storage/emulated/0/Documents/HsmProjects/mqtt_cs_9.hsm/mqtt_cs_9.svg',
    //   '/storage/emulated/0/Documents/HsmProjects/mqtt_cs_9.hsm/mqtt_cs_9.scene.json',
    //   '/storage/emulated/0/Documents/HsmProjects/mqtt_cs_9.hsm/generic_code/toit/mqtt_cs_9_helper.toit',
    // ]));


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

  String randomString(int length) {
    const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void setUnitTest() {
    mqttService.setUnitTest();
  }

  // List<String> getData() {
  //   List<String> result = [];
  //   for (int i = 0; i < 5; i++) {
  //     result.add(randomString(256));
  //   }
  //   return result;
  // }

  // List<String> getData(List<String> filesList) {
  //   List<String> bundle = [];
  //   String filePath = '/storage/emulated/0/Documents/HsmProjects/mqtt_cs_9.hsm/generic_code/dart/mqtt_cs_9_helper.dart';
  //   String content = readFileContentSync(filePath);
  //   Slicer slicer = Slicer('1234', 2048);
  //   String prefix = '/storage/emulated/0/Documents/';
  //   String subPath = filePath.replaceFirst(prefix, '');
  //   //bundle = slicer.chunkMessage('HsmProjects/mqtt_cs_9.hsm/generic_code/dart/mqtt_cs_9_helper.dart', content);
  //   bundle = slicer.chunkMessage(subPath, content);
  //   return bundle;
  // }

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

  List<String> getFilesList(String folderPath) {
    List<String> result = [];
    // Create a Directory object
    Directory directory = Directory(folderPath);

    try {
      // Check if the directory exists
      if (directory.existsSync()) {
    // Get a list of files in the directory
        List<FileSystemEntity> files = directory.listSync();
    // Get the names of the files
        for (var file in files) {
          result.add(file.path);
        }
      }
      else {
        print('Directory does not exist');
      }
    }
    catch (e) {
      print('Error accessing directory: $e');
    }
    return result;
  }

  List<String> getAllFiles(Directory directory)  {
    List<String> filePaths = [];
    // Create a Directory object
    try {
      // Check if the directory exists
      if (directory.existsSync()) {
        // Get a list of files and directories in the directory
        List<FileSystemEntity> entities = directory.listSync();

        for (var entity in entities) {
          if (entity is File) {
            // Add the file path to the list
            filePaths.add(entity.path);
          } else if (entity is Directory) {
            // Recursively get files in the subdirectory and add to the list
            filePaths.addAll(getAllFiles(entity));
          }
        }
      } else {
        print('Directory does not exist');
      }
    } catch (e) {
      print('Error accessing directory: $e');
    }
    return filePaths;
  }

  // String getData() {
  //   String text = '';
  //   String filePath = '/storage/emulated/0/Documents/HsmProjects/mqtt_cs_9.hsm/generic_code/dart/mqtt_cs_9_helper.dart';
  //   text = readFileContentSync(filePath);
  //   return text;
  // }

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