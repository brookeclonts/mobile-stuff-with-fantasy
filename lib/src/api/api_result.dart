/// A discriminated union for API call outcomes.
///
/// Every API call returns either [Success] with typed data
/// or [Failure] with an error message and optional status code.
sealed class ApiResult<T> {
  const ApiResult();

  /// True when the call succeeded.
  bool get isSuccess => this is Success<T>;

  /// Unwrap the data or throw. Use [when] for exhaustive handling.
  T get data => (this as Success<T>).value;

  /// Pattern-match both branches.
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, int? statusCode) failure,
  }) {
    return switch (this) {
      Success<T>(:final value) => success(value),
      Failure<T>(:final message, :final statusCode) => failure(message, statusCode),
    };
  }
}

final class Success<T> extends ApiResult<T> {
  const Success(this.value);
  final T value;
}

final class Failure<T> extends ApiResult<T> {
  const Failure(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
}
