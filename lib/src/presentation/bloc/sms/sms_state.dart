part of 'sms_bloc.dart';

@immutable
sealed class SmsState {}

final class SmsInitial extends SmsState {}
final class SendSmsLoading extends SmsState {}
final class SendSmsSuccess extends SmsState {
  final String responseMessage;

  SendSmsSuccess({required this.responseMessage});
}
final class SendSmsFailure extends SmsState {
  final String errorMessage;

  SendSmsFailure({required this.errorMessage});
}