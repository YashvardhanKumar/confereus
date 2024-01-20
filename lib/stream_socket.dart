import 'dart:async';

class SocketController<T> {
  SocketController();
  final _socketResponse = StreamController<T>();

  void Function(T) get add => _socketResponse.sink.add;

  Stream<T> get get => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}
