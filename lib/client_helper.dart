import 'package:uuid/uuid.dart';

import 'models.dart';

class ClientHelper {
  static ClientHelper? _instance;

  final String _clientId = 'flutter_client_${const Uuid().v4()}';
  final List<String> _selectedFiles = [];

  static void initInstance() {
    _instance ??= ClientHelper();
  }

  static ClientHelper? instance() {
    if (_instance == null) {
      throw Exception("--- ClientHelper was not initialized ---");
    }
    return _instance;
  }

  String clientId () {
    return _clientId;
  }

  void setFilesList(List<FileSystemItem> selectedFiles) {
    _selectedFiles.clear();
    for (FileSystemItem item in selectedFiles) {
      _selectedFiles.add(item.path);
    }
  }

  List<String> getFilesList() {
    return _selectedFiles;
  }

}
