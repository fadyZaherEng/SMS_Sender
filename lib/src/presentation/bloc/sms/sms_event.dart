part of 'sms_bloc.dart';

@immutable
sealed class SmsEvent {}

final class SmsInitialEvent extends SmsEvent {}

final class SmsSendEvent extends SmsEvent {
  final String phoneNumber;
  final String message;
  final BuildContext context;
  final int notificationUserId;

  SmsSendEvent({
    required this.phoneNumber,
    required this.message,
    required this.context,
    required this.notificationUserId,
  });
}

final class GetSMSNotificationToSendOtp extends SmsEvent {
  final int subscriberId;
  final int compoundId;

  GetSMSNotificationToSendOtp({
    required this.compoundId,
    required this.subscriberId,
  });
}

final class UpdateNotificationUserStateEvent extends SmsEvent {
  final NotificationUserStateRequest request;

  UpdateNotificationUserStateEvent({
    required this.request,
  });
}

final class BulkUpdateNotificationUserStateEvent extends SmsEvent {
  final BulkNotificationUserStateRequest request;

  BulkUpdateNotificationUserStateEvent({
    required this.request,
  });
}
