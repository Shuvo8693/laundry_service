class ErrorMessageMapper {
  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'no_internet_connection':
        return 'No internet connection';
      case 'invalid_credentials':
        return 'Invalid email or password';
      case 'user_not_found':
        return 'User not found';
      case 'server_error':
        return 'Server error occurred';
      default:
        return 'Unknown error';
    }
  }
}
