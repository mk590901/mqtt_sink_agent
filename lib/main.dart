import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'client_helper.dart';
import 'models.dart';
import 'task_bloc.dart';

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
          path: item.path,
          name: item.path.split('/').last,
          isDirectory: false,
        ));
      }
    }

    return FileSystemItem(
      path: path,
      name: path.split('/').last,
      isDirectory: true,
      children: children,
    );
  }
}

// FileTreeWidget with active button
class FileTreeWidget extends StatelessWidget {
  final String initialPath;

  const FileTreeWidget({required this.initialPath, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FileTreeBloc()..add(LoadDirectory(initialPath))),
        BlocProvider(create: (context) => TaskBloc()),
      ],
      child: BlocBuilder<FileTreeBloc, FileTreeState>(
        builder: (context, fileState) {
          if (fileState is FileTreeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (fileState is FileTreeError) {
            return Center(child: Text(fileState.message));
          }

          if (fileState is FileTreeLoaded) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildTree(context, fileState.root),
                  ),
                ),
                if (fileState.selectedFiles.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Text(
                      'Selected files:\n${fileState.selectedFiles.map((e) => e.name).join(", ")}',
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<TaskBloc, TaskState>(
                    builder: (context, taskState) {
                      bool isInProgress = taskState is TaskInProgress;
                      bool isFailure = taskState is TaskFailure;

                      String buttonText = 'Upload';
                      Color buttonColor = Colors.blue;
                      Color textColor = Colors.white;
                      if (isInProgress) {
                        buttonText = 'In Progress';
                      } else if (isFailure) {
                        buttonText = 'Retry';
                        buttonColor = Colors.red;
                      }

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: isInProgress
                                ? null // Block press on button if task in progress
                                : () {
                              if (fileState.selectedFiles.isNotEmpty) {
                                context.read<TaskBloc>().add(StartTask(fileState.selectedFiles));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('No files selected')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              //minimumSize: const Size(double.infinity, 50),
                              backgroundColor: buttonColor, foregroundColor: textColor,
                              //backgroundColor: isFailure ? Colors.red : null,
                            ),
                            child: Text(buttonText),
                          ),
                          if (isInProgress)
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                        ],
                      );
                    },
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
          ? const Icon(Icons.folder_outlined)
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

// FileTreePage
class FileTreePage extends StatelessWidget {
  final String folderPath;

  const FileTreePage({required this.folderPath, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects Viewer'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.blueGrey[50],
              child: const Text(
                'Select files for send to desktop from below projects:',
                style: TextStyle(fontSize: 16),
              ),
            ),
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
  ClientHelper.initInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FileTreePage(
        folderPath: '/storage/emulated/0/Documents/HsmProjects/',
      ),
    );
  }
}
