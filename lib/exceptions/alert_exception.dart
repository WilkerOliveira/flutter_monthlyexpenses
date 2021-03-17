import 'package:summarizeddebts/exceptions/exception_messages.dart';

class AlertException implements Exception {
  ExceptionMessages message;

  AlertException({this.message});
}
