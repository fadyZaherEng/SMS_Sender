import 'package:json_annotation/json_annotation.dart';

part 'request_sms_notification.g.dart';

@JsonSerializable()
class RequestSmsNotification {
  final int? subscriberId;
  final int? compoundId;

  const RequestSmsNotification({
    this.subscriberId,
    this.compoundId,
  });

  factory RequestSmsNotification.fromJson(Map<String, dynamic> json) =>
      _$RequestSmsNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$RequestSmsNotificationToJson(this);
}
