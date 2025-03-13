class Response {
  final bool result;
  final String message;
  Response({required this.result, required this.message});
  @override
  String toString() {
    return '[$result,$message]';
  }
}

// Pair class
class Pair<T1, T2> {
  final T1 first;
  final T2 second;
  Pair(this.first, this.second);
}

