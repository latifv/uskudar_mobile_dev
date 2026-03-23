final class NetworkResponse<T> {
  factory NetworkResponse.fromList(
    List<dynamic> list, {
    required T Function(List<dynamic>) mapper,
  }) {
    return NetworkResponse<T>._(isSuccess: true, data: mapper(list));
  }
  const NetworkResponse._({required this.isSuccess, this.data, this.message});

  final bool isSuccess;
  final T? data;
  final String? message;

  NetworkResponse<R> map<R>(R Function(T) mapper) {
    final data = this.data;
    if (data == null) {
      return NetworkResponse<R>._(isSuccess: isSuccess, message: message);
    }

    return NetworkResponse<R>._(
      isSuccess: isSuccess,
      data: mapper(data),
      message: message,
    );
  }

  static NetworkResponse<T> fromJson<T>(
    Map<String, dynamic> json, {
    T Function(dynamic)? fromJsonT,
  }) {
    final data = json['data'];
    final message =
        (json['message'] as String?) ?? (json['Message'] as String?);
    final isSuccess =
        json['isSuccess'] as bool? ?? json['IsSuccess'] as bool? ?? false;

    final parsedData = data != null && fromJsonT != null
        ? fromJsonT(data)
        : data;

    return NetworkResponse<T>._(
      isSuccess: isSuccess,
      data: parsedData as T?,
      message: message,
    );
  }

  @override
  String toString() {
    return 'NetworkResponse{isSuccess: $isSuccess, data: $data, message: $message}';
  }
}
