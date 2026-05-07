import 'package:json_annotation/json_annotation.dart';
import 'package:sms_sender/src/domain/entities/sms/sms_notification.dart';

part 'remote_sms_notification.g.dart';

@JsonSerializable()
class RemoteSmsNotification {
  @JsonKey(name: 'notificationUserId')
  final int? notificationUserId;
  @JsonKey(name: 'destination')
  final String? destination;
  @JsonKey(name: 'body')
  final String? body;

  const RemoteSmsNotification({
    this.notificationUserId,
    this.destination,
    this.body,
   });

  factory RemoteSmsNotification.fromJson(Map<String, dynamic> json) =>
      _$RemoteSmsNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteSmsNotificationToJson(this);
}

extension RemoteSmsNotificationExtension on RemoteSmsNotification? {
  SmsNotification mapToDomain() {
    return SmsNotification(
      notificationUserId: this?.notificationUserId ?? 0,
      destination: this?.destination ?? '',
      body: this?.body ?? '',
     );
  }
}

extension SmsNotificationListExtension on List<RemoteSmsNotification> {
  List<SmsNotification> mapToDomainList() {
    return map((remote) => remote.mapToDomain()).toList();
  }
}
