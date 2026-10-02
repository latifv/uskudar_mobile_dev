import 'dart:async';

final class Completer<T> {
  Completer() {
    _isCompleted = false;
  }

  bool _isCompleted = false;
  T? _value;
  void Function(T)? _completeCallback;

  bool get isCompleted => _isCompleted;

  void complete(T value) {
    if (!_isCompleted) {
      _isCompleted = true;
      _value = value;
      if (_completeCallback != null) {
        _completeCallback?.call(value);
      }
    }
  }

  Future<T> get future {
    return Future<T>.delayed(
      Duration.zero,
      () => _isCompleted ? _value as T : Future.value(_value as T),
    );
  }

  void then(void Function(T) callback) {
    if (_isCompleted) {
      callback(_value as T);
    } else {
      _completeCallback = callback;
    }
  }
}
