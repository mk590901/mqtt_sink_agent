import 'file_chunks.dart';

class FilesContainer {
  final Map<String,FileChunks> _container = {};

  void put (final String file, FileChunks chunks) {
    _container[file] = chunks;
  }

  FileChunks? get (final String file) {
    return _container[file];
  }

  bool contains (final String file) {
    return _container.containsKey(file);
  }

}