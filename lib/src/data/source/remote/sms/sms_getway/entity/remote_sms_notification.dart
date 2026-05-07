import 'package:json_annotation/json_annotation.dart';
import 'package:sms_sender/src/domain/entities/sms/sms_notification.dart';

part 'remote_sms_notification.g.dart';

@JsonSerializable()
class RemoteSmsNotification {
  final int? NotificationUserId;
  final String? Destination;
  final String? Body;
  final String? message;

  const RemoteSmsNotification({
    this.NotificationUserId,
    this.Destination,
    this.Body,
    this.message,
  });

  factory RemoteSmsNotification.fromJson(Map<String, dynamic> json) =>
      _$RemoteSmsNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteSmsNotificationToJson(this);
}

extension RemoteSmsNotificationExtension on RemoteSmsNotification? {
  SmsNotification mapToDomain() {
    return SmsNotification(
      notificationUserId: this?.NotificationUserId ?? 0,
      destination: this?.Destination ?? '',
      body: this?.Body ?? '',
      message: this?.message ?? '',
    );
  }
}

extension SmsNotificationListExtension on List<RemoteSmsNotification> {
  List<SmsNotification> mapToDomainList() {
    return map((remote) => remote.mapToDomain()).toList();
  }
}
