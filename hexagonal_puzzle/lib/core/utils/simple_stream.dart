import 'dart:async';

class SimpleStream<T> {
  final StreamController<T> _stream = StreamController<T>();

  Sink<T> get _input => _stream.sink;

  Stream<T> get output => _stream.stream;

  T? _currentValue;

  T? get current => _currentValue;

  void update(T value) {
    _currentValue = value;
    _input.add(value);
  }

  void close() {
    _stream.close();
  }
}