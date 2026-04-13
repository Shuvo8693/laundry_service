/// Abstract interface for converting network errors to domain-specific failures
/// 
/// Implementations of this interface should convert various network exceptions
/// into standardized failure objects that can be handled by the application.
/// 
/// Type parameter [T] represents the failure type (e.g., Failure, Either, etc.)
abstract class NetworkErrorConverter<T> {
  /// Converts an exception to a failure object
  /// 
  /// [exception] - The exception to convert
  /// Returns a failure object representing the error
  T convert(Exception exception);
}
