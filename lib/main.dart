import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

// Модели, события, состояния и BLoC остаются теми же
// (FileSystemItem, FileTreeEvent, FileTreeState, FileTreeBloc)
// Models
class FileSystemItem {
  final String name;
  final bool isDirectory;
  final List<FileSystemItem> children;
  bool isChecked;

  FileSystemItem({
    required this.name,
    required this.isDirectory,
    this.children = const [],
    this.isChecked = false,
  });
}

// BLoC Events
abstract class FileTreeEvent {}

class LoadDirectory extends FileTreeEvent {
  final String folderPath;
  LoadDirectory(this.folderPath);
}

class ToggleFileSelection extends FileTreeEvent {
  final FileSystemItem item;
  ToggleFileSelection(this.item);
}

// BLoC States
abstract class FileTreeState {}

class FileTreeInitial extends FileTreeState {}

class FileTreeLoading extends FileTreeState {}

class FileTreeLoaded extends FileTreeState {
  final FileSystemItem root;
  final List<FileSystemItem> selectedFiles;

  FileTreeLoaded(this.root, this.selectedFiles);
}

class FileTreeError extends FileTreeState {
  final String message;
  FileTreeError(this.message);
}

// BLoC
class FileTreeBloc extends Bloc<FileTreeEvent, FileTreeState> {
  FileTreeBloc() : super(FileTreeInitial()) {
    on<LoadDirectory>(_onLoadDirectory);
    on<ToggleFileSelection>(_onToggleFileSelection);
  }

  Future<void> _onLoadDirectory(
      LoadDirectory event, Emitter<FileTreeState> emit) async {
    try {
      emit(FileTreeLoading());
      final root = await _buildTree(event.folderPath);
      emit(FileTreeLoaded(root, []));
    } catch (e) {
      emit(FileTreeError(e.toString()));
    }
  }

  void _onToggleFileSelection(
      ToggleFileSelection event, Emitter<FileTreeState> emit) {
    if (state is FileTreeLoaded) {
      final currentState = state as FileTreeLoaded;
      final newSelectedFiles = List<FileSystemItem>.from(currentState.selectedFiles);

      event.item.isChecked = !event.item.isChecked;

      if (event.item.isChecked) {
        newSelectedFiles.add(event.item);
      } else {
        newSelectedFiles.removeWhere((item) => item.name == event.item.name);
      }

      emit(FileTreeLoaded(currentState.root, newSelectedFiles));
    }
  }

  Future<FileSystemItem> _buildTree(String path) async {
    final directory = Directory(path);
    final items = directory.listSync();

    final List<FileSystemItem> children = [];

    for (var item in items) {
      if (item is Directory) {
        children.add(await _buildTree(item.path));
      } else if (item is File) {
        children.add(FileSystemItem(
          name: item.path.split('/').last,
          isDirectory: false,
        ));
      }
    }

    return FileSystemItem(
      name: path.split('/').last,
      isDirectory: true,
      children: children,
    );
  }
}

// Виджет FileTreeWidget
class FileTreeWidget extends StatelessWidget {
  final String initialPath;

  const FileTreeWidget({required this.initialPath, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FileTreeBloc()..add(LoadDirectory(initialPath)),
      child: BlocBuilder<FileTreeBloc, FileTreeState>(
        builder: (context, state) {
          if (state is FileTreeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FileTreeError) {
            return Center(child: Text(state.message));
          }

          if (state is FileTreeLoaded) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildTree(context, state.root),
                  ),
                ),
                if (state.selectedFiles.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text(
                      'Selected files: ${state.selectedFiles.map((e) => e.name).join(", ")}',
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (state.selectedFiles.isNotEmpty) {
                        print('Selected files to process:');
                        for (var file in state.selectedFiles) {
                          print(file.name);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Operation completed')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('No files selected')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Perform Operation'),
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildTree(BuildContext context, FileSystemItem item) {
    return ExpansionTile(
      leading: item.isDirectory
          ? const Icon(Icons.folder)
          : Checkbox(
        value: item.isChecked,
        onChanged: (value) {
          context.read<FileTreeBloc>().add(ToggleFileSelection(item));
        },
      ),
      title: Text(item.name),
      children: item.children
          .map((child) => child.isDirectory
          ? _buildTree(context, child)
          : ListTile(
        leading: Checkbox(
          value: child.isChecked,
          onChanged: (value) {
            context.read<FileTreeBloc>().add(ToggleFileSelection(child));
          },
        ),
        title: Text(child.name),
      ))
          .toList(),
    );
  }
}

// Новая страница FileTreePage
class FileTreePage extends StatelessWidget {
  final String folderPath;

  const FileTreePage({required this.folderPath, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Explorer'),
        // Можно добавить действия в AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Пример: обновить дерево
              context.read<FileTreeBloc>().add(LoadDirectory(folderPath));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Здесь можно добавить дополнительные виджеты над FileTreeWidget
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.blueGrey[50],
              child: const Text(
                'Select files from the folder structure below:',
                style: TextStyle(fontSize: 16),
              ),
            ),
            // FileTreeWidget занимает оставшееся пространство
            Expanded(
              child: FileTreeWidget(initialPath: folderPath),
            ),
          ],
        ),
      ),
    );
  }
}

// Main
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FileTreePage(
        folderPath: '/storage/emulated/0/Documents/HsmProjects/', // Замените на ваш путь
      ),
    );
  }
}
