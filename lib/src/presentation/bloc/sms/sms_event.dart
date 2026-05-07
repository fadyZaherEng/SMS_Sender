part of 'sms_bloc.dart';

@immutable
sealed class SmsEvent {}

final class SmsInitialEvent extends SmsEvent {}

final class SmsSendEvent extends SmsEvent {
  final String phoneNumber;
  final String message;
  final BuildContext context;

  SmsSendEvent({
    required this.phoneNumber,
    required this.message,
    required this.context,
  });
}
