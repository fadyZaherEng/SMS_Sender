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

//GetSMSNotificationToSendOtp
final class GetSMSNotificationToSendOtpLoadingState extends SmsState {}

final class GetSMSNotificationToSendOtpSuccessState extends SmsState {
  final List<SmsNotification> smsNotificationOtp;

  GetSMSNotificationToSendOtpSuccessState({
    required this.smsNotificationOtp,
  });
}

final class GetSMSNotificationToSendOtpErrorState extends SmsState {
  final String errorMessage;

  GetSMSNotificationToSendOtpErrorState({
    required this.errorMessage,
  });
}

// UpdateNotificationUserState
final class UpdateNotificationUserStateLoadingState extends SmsState {}

final class UpdateNotificationUserStateSuccessState extends SmsState {
  final MessageResponse response;

  UpdateNotificationUserStateSuccessState({
    required this.response,
  });
}

final class UpdateNotificationUserStateErrorState extends SmsState {
  final String errorMessage;

  UpdateNotificationUserStateErrorState({
    required this.errorMessage,
  });
}

// BulkUpdateNotificationUserState
final class BulkUpdateNotificationUserStateLoadingState extends SmsState {}

final class BulkUpdateNotificationUserStateSuccessState extends SmsState {
  final MessageResponse response;

  BulkUpdateNotificationUserStateSuccessState({
    required this.response,
  });
}

final class BulkUpdateNotificationUserStateErrorState extends SmsState {
  final String errorMessage;

  BulkUpdateNotificationUserStateErrorState({
    required this.errorMessage,
  });
}
