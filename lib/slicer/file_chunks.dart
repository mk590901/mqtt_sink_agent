import 'dart:convert';

import 'chunks_wrapper.dart';

class FileChunks {
  final String _fileName;
  final List<String> _chunks = [];

  FileChunks(this._fileName);

  ChunksWrapper? addChunk(final String jsonString) {
    ChunksWrapper? result;
  // Extract file Name
    Map<String, dynamic> chunk = jsonDecode(jsonString);
    _chunks.add(jsonString);
    int total = chunk['total'];
    if (total == _chunks.length) {
      String client = chunk['client'];
      result = ChunksWrapper(client, _fileName, _chunks);
    }
    return result;
  }

}