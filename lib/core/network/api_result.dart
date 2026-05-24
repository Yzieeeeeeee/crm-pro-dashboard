/// Sealed result type for API operations.
sealed class ApiResult<T> {
  const ApiResult();
}

/// Successful API result carrying data of type [T].
class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

/// Failed API result carrying an error message.
class ApiFailure<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  const ApiFailure(this.message, {this.statusCode});
}
