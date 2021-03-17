import 'package:summarizeddebts/exceptions/exception_messages.dart';

class ErrorException implements Exception {
  String cause;
  ExceptionMessages status;

  ErrorException();

  ErrorException.withCause(this.cause);

  ErrorException.withCode(this.cause, this.status);

  ErrorException.withStatus(this.status);
}
