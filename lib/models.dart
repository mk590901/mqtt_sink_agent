// Models
class FileSystemItem {
  final String name;
  final String path;
  final bool isDirectory;
  final List<FileSystemItem> children;
  bool isChecked;

  FileSystemItem({
    required this.path,
    required this.name,
    required this.isDirectory,
    this.children = const [],
    this.isChecked = false,
  });
}