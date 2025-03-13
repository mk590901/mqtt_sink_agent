import 'dart:convert';

import 'chunks_wrapper.dart';
import 'file_chunks.dart';
import 'files_container.dart';

// Var 2
class Scheduler {
  final Map<String,FilesContainer> _container = {}; // key -> client Id

  ChunksWrapper? addChunk(final String jsonString) {
    ChunksWrapper? result;
    // Extract client Id and file Name
    Map<String, dynamic> chunk = jsonDecode(jsonString);
    String client = chunk['client'];
    String file = chunk['file'];

    if (!existClient(client)) {
      createClientAndFileChunksHeader(file, client);
    }
    else {
      if (!existFlleChunks(client, file)) {
        createFileChunksHeader(file, client);
      }
    }
    result = addChunkToClient(client, file, jsonString);
    return result;
  }

  ChunksWrapper? addChunkToClient(String client, String file, String jsonString) {
    FilesContainer? container = _container[client];
    FileChunks? fileChunk = container?.get(file);
    ChunksWrapper? result = fileChunk?.addChunk(jsonString);
    return result;
  }

  void createFileChunksHeader(String file, String client) {
    FilesContainer? container = _container[client];
    FileChunks? chunks = FileChunks(file);
    container?.put(file, chunks);
  }

  void createClientAndFileChunksHeader(String file, String client) {
    FilesContainer? container = FilesContainer();
    FileChunks? chunks = FileChunks(file);
    container.put(file, chunks);
    _container[client] = container;
  }

  bool existFlleChunks(client, file) {
    FilesContainer? container = _container[client];
    if (container == null) {
      return false;
    }
    return container.contains(file);
  }

  bool existClient(String client) {
    return _container.containsKey(client);
  }

  void removeEntry(final String client) {
    _container.remove(client);
  }
}

// Var 1
// class Scheduler {
//   final Map<String,FileChunks> _container = {}; // key -> client Id
//
//   ChunksWrapper? addChunk(final String jsonString) {
//     ChunksWrapper? result;
//   // Extract client Id and file Name
//     Map<String, dynamic> chunk = jsonDecode(jsonString);
//     String client = chunk['client'];
//     String file = chunk['file'];
//
//     if (!existClient(client)) {
//       createClientAndFileChunksHeader(file, client);
//     }
//     result = addChunkToClient(client, jsonString);
//     return result;
//   }
//
//   ChunksWrapper? addChunkToClient(String client, String jsonString) {
//     FileChunks? fileChunk;
//     fileChunk = _container[client];
//     ChunksWrapper? result = fileChunk?.addChunk(jsonString);
//     return result;
//   }
//
//   void createClientAndFileChunksHeader(String file, String client) {
//     FileChunks? fileChunk = FileChunks(file);
//     _container[client] = fileChunk;
//   }
//
//   bool existClient(String client) {
//     return _container.containsKey(client);
//   }
//
//   void removeEntry(final String client) {
//     _container.remove(client);
//   }
//
// }